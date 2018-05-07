//
// Created by mcopik on 5/3/18.
//

#include "LoopStatisticsPass.hpp"
#include "LoopClassification.hpp"
#include "io/SCEVAnalyzer.hpp"
#include "util/util.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Transforms/IPO/PassManagerBuilder.h"
#include "llvm/IR/LegacyPassManager.h"
// include transformations required to run succesfully ScalarEvolution
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Utils.h"

#include <chrono>

static cl::opt<std::string> LogFileName("loop-statistics-log-name",
                                        cl::desc("Specify filename for output log"),
                                        cl::init("unknown"),
                                        cl::value_desc("filename"));

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

    // Get timestamp. AFAIK easier methods come only in C++20
    auto time = std::chrono::system_clock::now();
    std::time_t time_now = std::chrono::system_clock::to_time_t(time);
    struct tm *parts = std::localtime(&time_now);
    // Since neither m.getName() or m.getSourceFileName provides a meaningful name
    // We rely on the user to supply an additional log name.
    unrecognized_log.open(
        sprintf("unrecognized_%s_%i_%i_%i_%i_%i",
                LogFileName.getValue().c_str(), parts->tm_mon + 1, parts->tm_mday,
                parts->tm_hour, parts->tm_min, parts->tm_sec),
        std::ios::out);
    for(Function & f : m) {
        runOnFunction(f);
    }
    unrecognized_log.close();

    return false;
}

void LoopStatistics::runOnFunction(Function & f)
{
    if (!f.isDeclaration()) {
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(f).getLoopInfo();
        ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>(f).getSE();
        LoopCounters counters;
        SCEVAnalyzer analyzer(SE, counters);
        //SE.print(dbgs());
        int counter = 0;
        for (Loop * l : LI) {
            counters.enterNested(counter++);
            LoopClassification classifier(analyzer, counters, unrecognized_log);
            auto info = classifier.classify(l);
            counters.leaveNested();
        }
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