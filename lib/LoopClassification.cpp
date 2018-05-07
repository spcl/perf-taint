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
    bool hasSimpleIncrement = false;

    if(ExitingBlocks.size() > 1) {
        for(BasicBlock * bb : ExitingBlocks) {
            auto exit = analyzeExit( l, bb );
            result.countUpdates[ static_cast<int>(std::get<1>(exit)) ]++;
            result.loopExits.push_back( std::move(exit) );
        }
        result.isComputableBySE = false;
    } else {
        auto exit = analyzeExit( l, ExitingBlocks[0] );
        const SCEV * induction_variable = std::get<0>(exit);
        if(!induction_variable || isa<SCEVUnknown>(induction_variable)) {

        }
        const SCEV * backedge_count = scev.getSE().getBackedgeTakenCount(l);
        result.isComputableBySE = backedge_count->getSCEVType() != scCouldNotCompute;
        result.countUpdates[ static_cast<int>(std::get<1>(exit)) ]++;
        hasSimpleIncrement = std::get<1>(exit) == results::UpdateType::INCREMENT;
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

    // is countable: is computable AND has no children
    result.isCountableBySE = result.isComputableBySE && !result.isNested;
    result.countCountableBySE = result.isCountableBySE;
    result.countComputableBySE = 0;

    // is countable by polyhedra - only increments, no multipath
    result.countCountableByPolyhedra = 0;
    // only one child AND increment as update AND child is countable as well (later)
    result.isCountableByPolyhedra = !result.countMultipath && hasSimpleIncrement;
    for(Loop * nested : l->getSubLoops()) {
        counters.enterNested(counter++);
        auto res = classify(nested);
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

        int iter_bound = static_cast<int>(results::UpdateType::END_ENUM);
        for(int i = 0; i < iter_bound; ++i) {
            result.countUpdates[i] += res.countUpdates[i];
        }

        result.countComputableBySE += res.countComputableBySE;
        result.countCountableBySE += res.countCountableBySE;
        result.isComputableBySE &= res.isComputableBySE;

        result.countCountableByPolyhedra += res.countCountableByPolyhedra;
        result.isCountableByPolyhedra &= res.isCountableByPolyhedra;
    }
    // Add this loop only if we found it to be computable after inspecting all children
    if(result.isComputableBySE)
        result.countComputableBySE++;
    if(result.isCountableByPolyhedra)
        result.countCountableByPolyhedra++;
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
