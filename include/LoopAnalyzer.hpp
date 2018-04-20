//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
#define LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP

#include "results/LoopInformation.hpp"

#include <tuple>

namespace llvm {
    class Loop;
    class BasicBlock;
    class Value;
    class CmpInst;
    class Instruction;
}

using namespace llvm;

class LoopAnalyzer
{
    Loop & loop;
    bool compareValues(Value * first, Value * second) const;
public:
    LoopAnalyzer(Loop & _loop):
        loop(_loop)
    {}

    results::LoopInformation analyze();
    Value * findInductionVariable(BasicBlock * block) const;
    Value * findLoadedValue(Value *) const;
    CmpInst * findCondition(BasicBlock * block, Value*) const;
};

#endif //LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
