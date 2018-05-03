//
// Created by mcopik on 5/3/18.
//

#ifndef LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP

#include <string>

#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"

using namespace llvm;

class SCEVToString
{
    ScalarEvolution & SE;

    std::string toString(const SCEVConstant * val);
    std::string toString(const SCEVTruncateExpr * val);
    std::string toString(const SCEVAddExpr * expr);
    std::string toString(const SCEVMulExpr * expr);
    std::string toString(const SCEVAddRecExpr * expr);
    std::string toString(const SCEVAddMulExpr * expr);

public:
    SCEVToString(ScalarEvolution & _SE):
        SE(_SE)
    {}

    std::string toString(const SCEV * val);

};

#endif //LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
