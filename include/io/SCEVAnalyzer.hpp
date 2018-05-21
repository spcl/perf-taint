//
// Created by mcopik on 5/3/18.
//

#ifndef LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP

#include <string>

#include "results/LoopInformation.hpp"

#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"

using namespace llvm;

class LoopCounters;
namespace results {
    enum class UpdateType;
}

class SCEVAnalyzer
{
    ScalarEvolution & SE;
    LoopCounters & counters;
    std::ostream & log;
    bool verbose;

    std::string toString(const SCEVConstant * val, bool printAsUpdate);
    std::string toString(const SCEVTruncateExpr * val, bool printAsUpdate);
    std::string toString(const SCEVSignExtendExpr * va, bool printAsUpdatel);
    std::string toString(const SCEVZeroExtendExpr * val, bool printAsUpdate);
    std::string toString(const SCEVAddExpr * expr, bool printAsUpdate);
    std::string toString(const SCEVMulExpr * expr, bool printAsUpdate);
    std::string toString(const SCEVAddRecExpr * expr, bool printAsUpdate);
    std::string toString(const SCEVAddMulExpr * expr, bool printAsUpdate);

    results::UpdateType classify(const SCEVAddRecExpr *val);
    results::UpdateType classify(const SCEVAddMulExpr *val);
    results::UpdateType classify(const SCEVMulExpr *val);

    bool isLoopInvariant(const SCEV * scev, Loop * l);
public:
    SCEVAnalyzer(ScalarEvolution & _SE, LoopCounters & _counters, std::ostream & os):
        SE(_SE),
        counters(_counters),
        log(os),
        verbose(true)
    {}

    void silence();
    std::string toString(const SCEV * val, bool printAsUpdate = false);
    results::UpdateType classify(const SCEV *val);
    const SCEV * findSCEV(Value * val, Loop * l);
    const SCEV * findSCEV(const SCEV * val, Loop * l);
    const SCEV * get(Value * val);
    ScalarEvolution & getSE();
};

#endif //LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
