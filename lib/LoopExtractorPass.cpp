
#include "util/util.hpp"
#include "LoopExtractorPass.hpp"
#include "LoopExtractor.hpp"
#include "LoopCounters.hpp"
#include "io/SCEVAnalyzer.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils.h"

#include <iostream>

static cl::opt<std::string> LogFileName("loop-extractor-log-name",
                                        cl::desc("Specify filename for output log"),
                                        cl::init("unknown"),
                                        cl::value_desc("filename"));

static cl::opt<std::string> LogDirName("loop-extractor-out-dir",
                                       cl::desc("Specify directory for output logs"),
                                       cl::init(""),
                                       cl::value_desc("filename"));

using namespace llvm;

namespace {

    void LoopExtractorPass::getAnalysisUsage(AnalysisUsage &AU) const
    {
        // Pass does not modify the input information
        AU.setPreservesAll();
        // We require loop information
        AU.addRequired<LoopInfoWrapperPass>();
        AU.addRequiredTransitive<ScalarEvolutionWrapperPass>();
    }

    bool LoopExtractorPass::runOnModule(Module &m)
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

        // Since neither m.getName() or m.getSourceFileName provides a meaningful name
        // We rely on the user to supply an additional log name.
        std::string name = LogDirName.getValue().empty() ?
                           "results" :
                           cppsprintf("%s/results",
                                      LogDirName.getValue().c_str());
        log.open(
            cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()),
            std::ios::out);
        dbgs() << cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()) << '\n';

        std::string loops_name = LogDirName.getValue().empty() ?
                           "loops" :
                           cppsprintf("%s/loops",
                                      LogDirName.getValue().c_str());
        loops.open(
            cppsprintf("%s_%s", loops_name.c_str(), LogFileName.getValue().c_str()),
            std::ios::out);

        for (Function &f : m) {
            runOnFunction(f);
        }
        loops << "^^^^^^\n";
        log.close();
        loops.close();

        return false;
    }

    bool LoopExtractorPass::runOnFunction(Function &f) {
        if (!f.isDeclaration()) {
            LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(f).getLoopInfo();
            ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>(f).getSE();
            LoopCounters counters;
            SCEVAnalyzer analyzer(SE, counters, log);
            analyzer.silence();
            LoopExtractor extractor(analyzer, counters, log, loops);

            loops << cppsprintf("<<<Function:%s>>>", f.getName().str()) << '\n';
            loops << "!!!!!!\n";
            int counter = 0;
            for (Loop * l : LI) {
                counters.enterNested(l, counter++);
                extractor.extract(l);
                std::cout << "Extracted" << '\n';
                counters.leaveNested();
            }
            loops << "#####\n";
        }
        return false;
    }

}

// Allow running on LLVM IR bytecode
char LoopExtractorPass::ID = 0;
static llvm::RegisterPass<LoopExtractorPass> register_pass(
    "loop-extractor",
    "Extract loop information",
    false /* Only looks at CFG */,
    false /* Analysis Pass */);

// Allow running dynamically through frontend such as Clang
void addLoopExtractor(const PassManagerBuilder &Builder,
                        legacy::PassManagerBase &PM) {
  PM.add(new LoopExtractorPass());
}
// run after optimizations
RegisterStandardPasses SOpt(PassManagerBuilder::EP_OptimizerLast,
                            addLoopExtractor);

