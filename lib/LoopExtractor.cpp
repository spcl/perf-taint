#define DEBUG_TYPE "LoopExtractor"

#include "LoopExtractor.hpp"

#include "LoopAnalyzer.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Scalar/IndVarSimplify.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

namespace {

    void LoopExtractor::getAnalysisUsage(AnalysisUsage & AU) const {
        // Pass does not modify the input information
        AU.setPreservesAll();
        //FIXME: do we need to call LoopSimplify or IndVarSimplify?
        // We require loop information
        AU.addRequired<LoopInfoWrapperPass>();
    }

    bool LoopExtractor::runOnFunction(Function & f) {
        DEBUG(dbgs() << "Analyze function: " << f.getName() << '\n');
        if (!f.isDeclaration()) {
            LoopInfo & LI = getAnalysis<LoopInfoWrapperPass>().getLoopInfo();
            for (Loop * l : LI) {
                DEBUG(dbgs() << "Analyze loop " << l->getName() << ' ' << l->isLoopSimplifyForm() << '\n');
                LoopAnalyzer analyzer(*l);
                analyzer.analyze();
                break;
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

