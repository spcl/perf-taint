//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
#define LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP

#include "results/LoopInformation.hpp"

#include <vector>

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
    Value * findLoadedValue(Value *) const;
    bool compareValues(Value * first, Value * second) const;
public:
    LoopAnalyzer(Loop & _loop):
        loop(_loop)
    {}

    results::LoopInformation analyze();
    Value * findInductionVariable(BasicBlock * block) const;
    CmpInst * findCondition(BasicBlock * block, Value*) const;
    std::vector<Instruction*> findUpdate(BasicBlock * latch,
                                         Value * loopCounter) const;
};

#endif //LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
