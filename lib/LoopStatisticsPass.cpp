//
// Created by mcopik on 5/3/18.
//

#include "LoopStatisticsPass.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/LegacyPassManager.h"
// include transformations required to run succesfully ScalarEvolution
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils.h"

void LoopStatistics::getAnalysisUsage(AnalysisUsage & AU) const
{
    // Pass does not modify the input information
    AU.setPreservesAll();
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequiredTransitive<ScalarEvolutionWrapperPass>();
}

bool LoopStatistics::runOnModule(Module & m)
{
    legacy::PassManager PM;
    // correlated-propagation
    PM.add(llvm::createCorrelatedValuePropagationPass());
    // mem2reg pass
    PM.add(llvm::createPromoteMemoryToRegisterPass());
    // instcombine
    PM.add(llvm::createInstructionCombiningPass());
    // loop-simplify
    PM.add(llvm::createLoopSimplifyPass());
    // indvarsimplify
    PM.add(llvm::createIndVarSimplifyPass());
    PM.run(m);

    for(Function & f : m) {
        runOnFunction(f);
    }

    return false;
}

void LoopStatistics::runOnFunction(Function & f)
{
    if (!f.isDeclaration()) {
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(f).getLoopInfo();
        ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>(f).getSE();
        SE.print(dbgs());
    }
}


// Allow running on LLVM IR bytecode
char LoopStatistics::ID = 0;
static llvm::RegisterPass<LoopStatistics> register_pass(
    "loop-statistics",
    "Extract loop information",
    false,
    false);

// Allow running dynamically through frontend such as Clang
void addLoopStatistics(const PassManagerBuilder &Builder,
                      legacy::PassManagerBase &PM) {
    PM.add(new LoopStatistics());
}
// run before vectorizer
RegisterStandardPasses SOpt(PassManagerBuilder::EP_VectorizerStart,
                            addLoopStatistics);