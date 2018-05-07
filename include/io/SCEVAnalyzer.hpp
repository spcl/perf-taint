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

    std::string toString(const SCEVConstant * val);
    std::string toString(const SCEVTruncateExpr * val);
    std::string toString(const SCEVAddExpr * expr);
    std::string toString(const SCEVMulExpr * expr);
    std::string toString(const SCEVAddRecExpr * expr);
    std::string toString(const SCEVAddMulExpr * expr);

    results::UpdateType classify(const SCEVAddRecExpr *val);
    results::UpdateType classify(const SCEVAddMulExpr *val);
public:
    SCEVAnalyzer(ScalarEvolution & _SE, LoopCounters & _counters):
        SE(_SE),
        counters(_counters)
    {}

    std::string toString(const SCEV * val);
    results::UpdateType classify(const SCEV *val);
    const SCEV * get(Value * val);
    ScalarEvolution & getSE();
};

#endif //LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
