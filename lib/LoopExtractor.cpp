#define DEBUG_TYPE "LoopExtractor"

#include "LoopExtractor.hpp"

#include "LoopAnalyzer.hpp"
#include "io/StreamPrinter.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Scalar/IndVarSimplify.h"
#include "llvm/Transforms/Utils/LoopSimplify.h"
#include "llvm/Support/Debug.h"

using namespace llvm;


namespace {

    void LoopExtractor::getAnalysisUsage(AnalysisUsage & AU) const {
        // Pass does not modify the input information
        AU.setPreservesAll();
        //FIXME: do we need to call LoopSimplify or IndVarSimplify?
        // We require loop information
        //AU.addRequired<LoopSimplifyPass>();
        //AU.addRequired<IndVarSimplifyPass>();
        AU.addRequired<LoopInfoWrapperPass>();
        AU.addRequiredTransitive<ScalarEvolutionWrapperPass>();
    }

    bool LoopExtractor::analyzeNestedLoop(Loop * l, ScalarEvolution & SE, int offset)
    {
        SmallVector<BasicBlock *, 8> ExitingBlocks;
        l->getExitingBlocks(ExitingBlocks);
        //DEBUG(dbgs() << "Spec2: " << *dyn_cast<BranchInst>(ExitingBlocks[0]->getTerminator())->getCondition() << ' ');
        if(ExitingBlocks.size() > 1) {
            DEBUG(
                dbgs().indent(offset);
                dbgs() << "Multiple exit blocks, not supported now!\n");
                int i = 0;
                for(BasicBlock * bb : ExitingBlocks) {
                    dbgs().indent(offset);
                    const BranchInst * branch = dyn_cast<BranchInst>(bb->getTerminator());
                    const Instruction * condition = dyn_cast<Instruction>(branch->getCondition());
                    if(condition) {
                        dbgs() << i << ": " << *condition << '\n';
                        const SCEV * induction_variable = nullptr;
                        if(l->isLoopInvariant(condition->getOperand(0))) {
                            induction_variable = SE.getSCEV(condition->getOperand(1));
                        } else if(l->isLoopInvariant(condition->getOperand(1))) {
                            induction_variable = SE.getSCEV(condition->getOperand(0));
                        }
                        if(induction_variable) {
                            dbgs().indent(offset);
                            dbgs() << i << ": " << *induction_variable << "\n";
                        }
                    }
                    else
                        dbgs() << i << ": unknown" << '\n';
                }
            return false;
        }
        const BranchInst * branch = dyn_cast<BranchInst>(ExitingBlocks[0]->getTerminator());
        const Instruction * condition = dyn_cast<Instruction>(branch->getCondition());
        if(!condition) {
            DEBUG(
                dbgs().indent(offset);
                dbgs() << "Unknown condition type " << *condition->getType() <<
                       " , not supported now!\n");
            return false;
        }
        const SCEV * induction_variable = nullptr;
        if(l->isLoopInvariant(condition->getOperand(0))) {
            induction_variable = SE.getSCEV(condition->getOperand(1));
        } else if(l->isLoopInvariant(condition->getOperand(1))) {
            induction_variable = SE.getSCEV(condition->getOperand(0));
        } else {
            DEBUG(
                dbgs().indent(offset);
                dbgs() << "Unknown condition where both operands are not"
                          "loop invariant: " << *condition << "\n";
            );
            return false;
        }
        auto range = l->getLocRange();
        DEBUG(
            dbgs().indent(offset);
            dbgs() << "Loop: " << l->getName();
            if(range.getStart() && range.getEnd()) {
                dbgs() << " Loop location: from ";
                range.getStart().print(dbgs());
                dbgs() << " to: ";
                range.getEnd().print(dbgs());
                dbgs() << '\n';
            } else {
                dbgs() << " Loop location unknown" << '\n';
            }
            dbgs().indent(offset);
            dbgs() << "Variable: " << *induction_variable << "\n";
//                        dbgs() << "Initial value: " << induction_variable->getStart() << "\n";
            dbgs().indent(offset);
            dbgs() << "Condition: " << *condition << '\n';
        );

        for(Loop * nested : l->getSubLoops()) {
            dbgs() << '\n';
            analyzeNestedLoop(nested, SE, offset + 4);
        }
        dbgs() << '\n';
    }

    bool LoopExtractor::runOnFunction(Function & f) {
        DEBUG(dbgs() << "Analyzbge function: " << f.getName() << '\n');
        if (!f.isDeclaration()) {
            LoopInfo & LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
            ScalarEvolution & SE = getAnalysis<ScalarEvolutionWrapperPass>().getSE();
            SE.print(dbgs());
            for (Loop * l : LI) {
                analyzeNestedLoop(l, SE);
                //l = l->getSubLoops()[0];
                //DEBUG(dbgs() << *l->getLoopPreheader() << '\n');
//                DEBUG(dbgs() << *l->getHeader() << '\n');
//                DEBUG(dbgs() << *l->getLoopLatch() << '\n');
//                DEBUG(dbgs() << *l->getExitBlock() << '\n');


//                auto iter = l->getBlocks().begin();
//                auto iter2 = l->getBlocks().end();
//                for(; iter != iter2; ++iter) {
//                    for(auto iter3 = (*iter)->begin(); iter3 != (*iter)->end(); ++iter3) {
//                        //DEBUG(dbgs() << "Spec: " << *iter3 << '\n');
////                        if (SE.isSCEVable((*iter3).getType())) {
////                            DEBUG(dbgs() << "SCEV: " << *iter3 << " is " << *SE.getSCEVAtScope(&*iter3, l) << " of type: " << SE.getSCEVAtScope(&*iter3, l)->getSCEVType() << '\n');
////                            auto x = dyn_cast<SCEVAddRecExpr>(SE.getSCEV(&*iter3));
////                            if(x) {
////                                for (int i = 5; i < 15; ++i)
////                                    DEBUG(dbgs() << "Evaluate " << *x << " at "
////                                                 << i << " "
////                                                 << *x->evaluateAtIteration(
////                                                     SE.getConstant(
////                                                         APInt(32, i)), SE)
////                                                 << '\n');
////                            }
////                            }
////                        else{}
////                            //DEBUG(dbgs() << "Spec nonSCEV: " << '\n');
//                    }
//                }
                //DEBUG(dbgs() << "Backedge count" << *SE.getBackedgeTakenCount(l) << '\n');
                //DEBUG(dbgs() << "Analyze loop " << l->getName() << ' ' << l->isLoopSimplifyForm() << '\n');
                //LoopAnalyzer analyzer(*l);
                //StreamPrinter::print(dbgs(), analyzer.analyze());
            }
        }
        return false;
    }

}

// Allow running on LLVM IR bytecode
char LoopExtractor::ID = 0;
static llvm::RegisterPass<LoopExtractor> register_pass(
    "LoopExtractor",
    "Extract loop information",
    false /* Only looks at CFG */,
    false /* Analysis Pass */);

// Allow running dynamically through frontend such as Clang
void addLoopExtractor(const PassManagerBuilder &Builder,
                        legacy::PassManagerBase &PM) {
  PM.add(new LoopExtractor());
}
// run after optimizations
RegisterStandardPasses SOpt(PassManagerBuilder::EP_OptimizerLast,
                            addLoopExtractor);

