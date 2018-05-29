//
// Created by mcopik on 5/17/18.
//

#include "LoopClassification.hpp"
#include "LoopExtractor.hpp"
#include "LoopCounters.hpp"
#include "io/SCEVAnalyzer.hpp"
#include "io/ValueToString.hpp"
#include "util/util.hpp"

#include "llvm/IR/Function.h"

#include <sstream>

const SCEV * LoopExtractor::getInitialValue(const SCEV *val)
{
    ScalarEvolution & SE = scev.getSE();
    switch (val->getSCEVType()) {
        case scAddRecExpr:
            return dyn_cast<SCEVAddRecExpr>(val)->evaluateAtIteration(
                SE.getConstant(APInt(32, 0)), SE);
        case scAddMulExpr:
            return dyn_cast<SCEVAddMulExpr>(val)->evaluateAtIteration(
                dyn_cast<SCEVConstant>(SE.getConstant(APInt(32, 0))), SE);
        default:
            assert(!"Unknown SCEV type!");
            return nullptr;
    }
}

bool LoopExtractor::extract(Loop *l, int idx)
{
    LoopClassification classifier(scev, counters, results);
    classifier.silence();
    auto info = classifier.classify(l);

    if(info.includesMultipleExits)
        results << "multiple_exits\n";
    if(info.isCountableBySE) {
        results << "computable_se: YES" << "\n";
        results << "se_time: " << info.scalarEvolutionComputeTime << " "
                << '\n';
    } else
        results << "computable_se: NO" << "\n";
    if(info.    isCountableGreg)
        results << "computable_greg: YES" << "\n";
    else
        results << "computable_greg: NO" << "\n";
    bool is_def = printOuterLoop(info, l, idx);
    results << "---------\n";
    return is_def;
//    SmallVector<BasicBlock *, 8> ExitingBlocks;
//    l->getExitingBlocks(ExitingBlocks);
//    if(ExitingBlocks.size() > 1) {
//        dbgs().indent(offset);
//        dbgs() << "Multiple exit blocks, not supported now!\n";
//        int i = 0;
//        for(BasicBlock * bb : ExitingBlocks) {
//            dbgs().indent(offset);
//            const BranchInst * branch = dyn_cast<BranchInst>(bb->getTerminator());
//            const Instruction * condition = dyn_cast<Instruction>(branch->getCondition());
//            if(condition) {
//                dbgs() << i << ": " << *condition << '\n';
//                const SCEV * induction_variable = nullptr;
//                if(l->isLoopInvariant(condition->getOperand(0))) {
//                    induction_variable = SE.getSCEV(condition->getOperand(1));
//                } else if(l->isLoopInvariant(condition->getOperand(1))) {
//                    induction_variable = SE.getSCEV(condition->getOperand(0));
//                }
//                if(induction_variable) {
//                    dbgs().indent(offset);
//                    dbgs() << i << ": " << *induction_variable << "\n";
//                }
//            }
//            else
//                dbgs() << i << ": unknown" << '\n';
//        }
//        return false;
//    }
//    const BranchInst * branch = dyn_cast<BranchInst>(ExitingBlocks[0]->getTerminator());
//    const Instruction * condition = dyn_cast<Instruction>(branch->getCondition());
//    if(!condition) {
//        dbgs().indent(offset);
//        dbgs() << "Unknown condition type " << *branch <<
//               " , not supported now!\n";
//        return false;
//    }
//    const SCEV * induction_variable = nullptr;
//    if(l->isLoopInvariant(condition->getOperand(0))) {
//        induction_variable = SE.getSCEV(condition->getOperand(1));
//    } else if(l->isLoopInvariant(condition->getOperand(1))) {
//        induction_variable = SE.getSCEV(condition->getOperand(0));
//    } else {
//        dbgs().indent(offset);
//        dbgs() << "Unknown condition where both operands are not"
//                  "loop invariant: " << *condition << "\n";
//        return false;
//    }
//    if(isa<SCEVUnknown>(induction_variable)) {
//        dbgs().indent(offset);
//        dbgs() << "Unknown type of SCEV! " << *induction_variable << "\n";
//        return false;
//    }
//    counters.addLoop(l, induction_variable, depth, multipath_id);
//    SCEVAnalyzer stringFormatter(SE, counters);
//    ValueToString valueFormatter(SE, stringFormatter);
//    auto range = l->getLocRange();
//    dbgs().indent(offset);
//    dbgs() << "Loop: " << l->getName();
//    if(range.getStart() && range.getEnd()) {
//        dbgs() << " Loop location: from ";
//        range.getStart().print(dbgs());
//        dbgs() << " to: ";
//        range.getEnd().print(dbgs());
//        dbgs() << '\n';
//    } else {
//        dbgs() << " Loop location unknown" << '\n';
//    }
//    dbgs().indent(offset);
//    dbgs() << "Variable: " << *induction_variable << "\n";
////                        dbgs() << "Initial value: " << induction_variable->getStart() << "\n";
//    dbgs().indent(offset);
//    dbgs() << "Initial value: " << *getInitialValue(induction_variable, SE) << '\n';
//    dbgs().indent(offset);
//    dbgs() << "Update: " << stringFormatter.toString(induction_variable) << '\n';
//    dbgs().indent(offset);
//    dbgs() << "Condition: " << valueFormatter.toString(condition) << '\n';
//
//    int counter = 0;
//    for(Loop * nested : l->getSubLoops()) {
//        counters.enterNested(counter);
//        analyzeNestedLoop(nested, SE, depth + 1, counter++, offset + 4);
//        counters.leaveNested();
//    }
//    dbgs() << '\n';
}

bool LoopExtractor::printOuterLoop(const results::LoopInformation & info, Loop * l, int idx)
{
    loop << "!!!!!!\n";
    loop << "outerloop: " << idx << ";" << "\n";
    std::vector<std::string> loops;
    int loop_count = 1, var_count = info.isCountableGreg;//info.loopExits.size() == 1;//
    if(var_count) {
        for (const results::LoopInformation &info_ : info.nestedLoops) {
            auto x = printLoop(info_, info_.loop, 2);
            //dbgs() << "Loops: " << loop_count << "\n";
            loop_count += std::get<1>(x);
            var_count += std::get<2>(x);
            loops.push_back(std::move(std::get<0>(x)));
        }
    }
    loop << "no_variables: " << var_count << "; no_loops: " << loop_count << "\n";
    auto res = printLoop(info, l, 1, true);
    loop << std::get<0>(res) << "\n";

    loop << "calls: {\n\n}\n";

    loop << "nested:{\n";
    if(!std::get<3>(res)) {
        for (const std::string &nested_loop : loops) {
            loop << nested_loop;
        }
    }
    loop << "}\n";
    loop << "!@!" << '\n';
    //TODO: why is this necessary?
    loop << "!@#parameters!@$\n";
    loop << "######\n";
    return info.loopExits.size() == 1;
}

// Loop representation, number of of loops, number of vars
std::tuple<std::string, int, int, bool> LoopExtractor::printLoop(const results::LoopInformation & info, Loop * l, int depth, bool justHeader)
{
    std::stringstream loop, loop_description;
    std::string id_begin = "", id_end;
    for(int i = 0; i < depth; ++i) {
        id_begin += '$';
        id_end += '@';
    }
    loop << "!" << id_begin << "!" << '\n';
    int loop_count = 1, var_count = 0;
    if(info.isCountableGreg) { //loopExits.size() == 1) {
        std::string var_name = counters.getCounterName(l);
        loop_description << "var:" << var_name << " ; ";
        auto &exit = info.loopExits.front();
        const SCEV *induction_variable = std::get<0>(exit);
        loop_description << "start: " << scev.toString(getInitialValue(induction_variable))
             << " ; ";
        loop_description << "update: "
             << scev.toString(induction_variable, true) << " ; ";
        loop_description << "guard: "
             << valueFormatter.toString(std::get<2>(exit), std::get<3>(exit))
             << " ;";
        loop_description << "header: " << l->getHeader()->getName().str() << "; cycles: 0;\n";
        ++var_count;
    }
    bool is_undefined = !info.isCountableGreg || loop_description.str().find("undef") != std::string::npos;
    if(is_undefined){
        loop << "UNDEF: undef" << undef_counter++ << "; header:; cycles: 0;\n";
    } else {
        loop << loop_description.str() << "\n";
    }
    if(justHeader)
        return std::make_tuple(loop.str(), loop_count, var_count, is_undefined);
    loop << "calls: {\n\n}\n";

    loop << "nested:{\n";
    if(!is_undefined) { //loopExits.size() == 1) {
        for (const results::LoopInformation &info_ : info.nestedLoops) {
            auto res = printLoop(info_, info_.loop, depth + 1);
            loop_count += std::get<1>(res);
            var_count += std::get<2>(res);
            loop << std::get<0>(res);
        }
    }
    // clean only if undefined has been introduced right now
    else if (info.isCountableGreg){
        // clear counters
        // we rely here on visiting depth-first - clean until you meet
        Loop * last_one = l;
        const results::LoopInformation * current = &info;
        while(!current->nestedLoops.empty()) {
            last_one = info.nestedLoops.back().loop;
            current = &info.nestedLoops.back();
        }
            counters.clearFromTo(l, last_one);
    }
    loop << "}\n";
    loop << "!" << id_end << "!" << '\n';
    return std::make_tuple(loop.str(), loop_count, var_count, is_undefined);
}