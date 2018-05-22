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

void LoopExtractor::extract(Loop *l)
{
    LoopClassification classifier(scev, counters, results);
    classifier.silence();
    auto info = classifier.classify(l);

    if(info.includesMultipleExits)
        results << "multiple_exits\n";
    if(info.isCountableBySE)
        results << "computable_se: " << info.scalarEvolutionComputeTime << " " << '\n';
    if(info.isCountableGreg)
        printLoop(info, l);
    results << "---------\n";
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

void LoopExtractor::printLoop(const results::LoopInformation & info, Loop * l, int depth)
{
    std::string id_begin = "", id_end;
    for(int i = 0; i < depth; ++i) {
        id_begin += '$';
        id_end += '@';
    }
    loop << "!" << id_begin << "!" << '\n';
    loop << "outerloop: " << 1 << "\n";
    std::string var_name = counters.getCounterName(l);
    loop << "var:" << var_name << " ; ";
    auto & exit = info.loopExits.front();
    const SCEV * induction_variable = std::get<0>(exit);
    //dbgs() << *std::get<2>(exit) << "\n";
    auto * start_value = getInitialValue(induction_variable);
    dbgs() << *start_value << " " << scev.isUnknown(start_value) << "\n";
    loop << "start: " << scev.toString(getInitialValue(induction_variable)) << " ; ";
    loop << "update: " << var_name << " = " << scev.toString(induction_variable, true) << " ; ";
    //dbgs() << *std::get<2>(exit) << "\n";
    loop << "guard: " << valueFormatter.toString( std::get<2>(exit), std::get<3>(exit) ) << " ;\n";

    //dbgs() << *induction_variable << "\n";
//    ScalarEvolution & SE = scev.getSE();
//    auto tmp = (dyn_cast<SCEVAddRecExpr>(induction_variable))->evaluateAtIteration( dyn_cast<SCEVConstant>(SE.getConstant(APInt(32, 0))), SE );
//    if(isa<SCEVAddRecExpr>(tmp)) {
//        dbgs() << *(dyn_cast<SCEVAddRecExpr>(tmp))->evaluateAtIteration(dyn_cast<SCEVConstant>(SE.getConstant(APInt(32, 10))), SE ) << '\n';
//    }
    loop << "calls: {\n\n}\n";

    loop << "nested:{\n";
    for (const results::LoopInformation & info_ : info.nestedLoops) {
        printLoop(info_, info_.loop, depth + 1);
    }
    loop << "\n";
    loop << "!" << id_end << "!" << '\n';
}