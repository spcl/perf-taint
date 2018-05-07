//
// Created by mcopik on 5/4/18.
//

#ifndef LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP

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

public:
    ValueToString(ScalarEvolution & _SE, SCEVAnalyzer & _scevPrinter) :
        SE(_SE),
        scevPrinter(_scevPrinter)
    {}

    std::string toString(Value * val);
    std::string toString(const Instruction * instr);
};

#endif //LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
