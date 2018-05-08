//
// Created by mcopik on 5/3/18.
//

#include "LoopStatisticsPass.hpp"
#include "LoopClassification.hpp"
#include "LoopCounters.hpp"
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
#include <iostream>
#include <string>

static cl::opt<std::string> LogFileName("loop-statistics-log-name",
                                        cl::desc("Specify filename for output log"),
                                        cl::init("unknown"),
                                        cl::value_desc("filename"));

static cl::opt<std::string> LogDirName("loop-statistics-out-dir",
                                        cl::desc("Specify directory for output logs"),
                                        cl::init(""),
                                        cl::value_desc("filename"));

void LoopStatistics::getAnalysisUsage(AnalysisUsage & AU) const
{
    // Pass does not modify the input information
    AU.setPreservesAll();
    AU.addRequired<LoopInfoWrapperPass>();
    AU.addRequiredTransitive<ScalarEvolutionWrapperPass>();
}

static const char * LOG_HEADER[] = {
    "count_loops", "nested_depth", "count_computable_se",
    "count_countable_se", "count_countable_polyhedra", "count_uncountable_polyhedra_multipath",
    "count_uncountable_polyhedra_update", "count_multipath", "count_nested",
    "count_multiple_exits", "count_not_found", "count_unknown", "count_incr",
    "count_add", "count_mul", "count_affine"
};

void LoopStatistics::print(std::ostream & os, const results::LoopInformation & summary) const
{
    os << summary.countLoops << ",";
    os << summary.nestedDepth << ",";
    os << summary.countComputableBySE << ",";
    os << summary.countCountableBySE << ",";
    os << summary.countCountableByPolyhedra << ",";
    os << summary.countUncountableByPolyhedraMultipath << ",";
    os << summary.countUncountableByPolyhedraUpdate << ",";
    os << summary.countMultipath << ",";
    os << summary.countNested << ",";
    os << summary.countMultipleExits << ",";
    int iter_bound = static_cast<int>(results::UpdateType::END_ENUM);
    for(int i = 0; i < iter_bound; ++i) {
        os << summary.countUpdates[i] << ',';
    }
    os << '\n';
}

void LoopStatistics::printResults(const std::string & cur_date) const
{
    std::string name = LogDirName.getValue().empty() ?
                       (LogFileName.getValue().empty() ? LogFileName.getValue().c_str() : "unknown") :
                       cppsprintf("%s/%s", LogDirName.getValue().c_str(), LogFileName.getValue().c_str());
    name = cppsprintf("%s_%s", name.c_str(), cur_date.c_str());
    std::fstream results(name, std::ios::out);
    for(const char * val : LOG_HEADER)
        results << val << ',';
    results << '\n';
    auto summary = results::LoopInformation::summarize_nested(loops.begin(), loops.end());
    results << "total,";
    print(results, summary);
    results << "main_loops,";
    summary = results::LoopInformation::summarize(loops.begin(), loops.end());
    print(results, summary);
    results.close();
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
    std::string cur_date = cppsprintf("%d_%d_%d_%d_%d", parts->tm_mon + 1, parts->tm_mday, parts->tm_hour, parts->tm_min, parts->tm_sec);
    // Since neither m.getName() or m.getSourceFileName provides a meaningful name
    // We rely on the user to supply an additional log name.
    std::string name = LogDirName.getValue().empty() ?
                      "unrecognized" :
                      cppsprintf("%s/unrecognized", LogDirName.getValue().c_str());
    unrecognized_log.open(
        cppsprintf("%s_%s_%s", name.c_str(), LogFileName.getValue().c_str(), cur_date.c_str()),
        std::ios::out);
    for(Function & f : m) {
        runOnFunction(f);
    }
    printResults(cur_date);
    unrecognized_log.close();

    return false;
}

void LoopStatistics::runOnFunction(Function & f)
{
    if (!f.isDeclaration()) {
        LoopInfo &LI = getAnalysis<LoopInfoWrapperPass>(f).getLoopInfo();
        ScalarEvolution &SE = getAnalysis<ScalarEvolutionWrapperPass>(f).getSE();
        LoopCounters counters;
        SCEVAnalyzer analyzer(SE, counters, unrecognized_log);
        //SE.print(dbgs());
        int counter = 0;
        for (Loop * l : LI) {
            counters.enterNested(counter++);
            LoopClassification classifier(analyzer, counters, unrecognized_log);
            loops.push_back( std::move(classifier.classify(l)) );
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
RegisterStandardPasses SOpt(PassManagerBuilder::EP_EarlyAsPossible,
                            addLoopStatistics);