//
// Created by mcopik on 5/4/18.
//

#include "LoopClassification.hpp"
#include "io/SCEVAnalyzer.hpp"
#include "LoopCounters.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"


results::LoopInformation LoopClassification::classify(Loop * l)
{
    results::LoopInformation result;
    SmallVector<BasicBlock *, 8> ExitingBlocks;
    l->getExitingBlocks(ExitingBlocks);
    if(ExitingBlocks.size() > 1) {
        for(BasicBlock * bb : ExitingBlocks) {
            result.loopExits.push_back( analyzeExit(l, bb) );
        }
        result.computableBySE = false;
    } else {
        auto exit = analyzeExit( l, ExitingBlocks[0] );
        const SCEV * induction_variable = std::get<0>(exit);
        if(!induction_variable || isa<SCEVUnknown>(induction_variable)) {

        }
        const SCEV * backedge_count = scev.getSE().getBackedgeTakenCount(l);
        result.computableBySE = backedge_count->getSCEVType() != scCouldNotCompute;
    }
    int counter = 0;
    //result.maxMultipath = l->getSubLoops().size();
    result.nestedDepth = 0;
    // count yourself and children, they will count their children.
    result.countLoops = 1;
    result.countMultipath = l->getSubLoops().size() > 1;
    result.includesMultipath = result.countMultipath;
    result.isNested = l->getSubLoops().size() > 0;
    result.countNested =  result.isNested;
    result.includesMultipleExits = ExitingBlocks.size() > 1;
    result.countMultipleExits = result.includesMultipleExits;
    for(Loop * nested : l->getSubLoops()) {
        counters.enterNested(counter++);
        auto res = classify(nested);
        // TODO: merge
        counters.leaveNested();
        //result.maxMultipath = std::max(result.maxMultipath, res.maxMultipath);
        result.nestedDepth = std::max(result.nestedDepth, res.nestedDepth);
        result.countLoops += res.countLoops;

        result.countMultipath += res.countMultipath;
        // `isMultipath` true when at least one children has multipath property
        result.includesMultipath |= res.includesMultipath;

        // don't update isNested since it's obvious
        result.countNested += res.countNested;

        // if any child has multiple exits - parent has multiple exits
        result.includesMultipleExits |= res.includesMultipleExits;
        result.countMultipleExits += res.countMultipleExits;
    }
    ++result.nestedDepth;

    return result;
}

/// For the exit block, determine the terminator instruction and find the appropiate condition
///
std::tuple<const SCEV *, results::UpdateType, const Instruction *> LoopClassification::analyzeExit(Loop * loop, BasicBlock * block)
{
    const BranchInst * branch = dyn_cast<BranchInst>(block->getTerminator());
    const Instruction * condition = dyn_cast<Instruction>(branch->getCondition());
    if(condition) {
        const SCEV * induction_variable = nullptr;
        if(loop->isLoopInvariant(condition->getOperand(0))) {
            induction_variable = scev.get(condition->getOperand(1));
        } else if(loop->isLoopInvariant(condition->getOperand(1))) {
            induction_variable = scev.get(condition->getOperand(0));
        }
        if(induction_variable) {
            return std::make_tuple(induction_variable, scev.classify(induction_variable), condition);
        } else {
            std::string output;
            raw_string_ostream string_os(output);
            string_os << *condition;
            os << "Unrecognized induction variable in: " << string_os.str() << '\n';
            return std::make_tuple(nullptr, results::UpdateType::UNKNOWN, condition);
        }
    } else {
        std::string output;
        raw_string_ostream string_os(output);
        string_os << *branch->getCondition();
        os << "Unrecognized condition: " << string_os.str() << '\n';
        return std::make_tuple(nullptr, results::UpdateType::UNKNOWN, nullptr);
    }
}
