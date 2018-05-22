//
// Created by mcopik on 5/4/18.
//

#ifndef LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP

#include "SCEVAnalyzer.hpp"

#include <string>

class SCEVAnalyzer;

namespace llvm {
    class Value;
    class Constant;
    class Argument;
    class Instruction;
    class ScalarEvolution;
}

using namespace llvm;

class ValueToString
{
    ScalarEvolution & SE;
    SCEVAnalyzer & scevPrinter;

    std::string toString(const Constant * arg);
    std::string toString(const Argument * arg);
    std::string toString(const BinaryOperator * op);
    std::string toString(const GetElementPtrInst * get);
    std::string toString(const ICmpInst * op, bool exitOnSuccess);
public:
    ValueToString( SCEVAnalyzer & _scevPrinter) :
        SE(_scevPrinter.getSE()),
        scevPrinter(_scevPrinter)
    {}

    std::string toString(const Instruction * instr, bool exitOnSuccess = false);
    std::string toString(Value * val);
};

#endif //LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
