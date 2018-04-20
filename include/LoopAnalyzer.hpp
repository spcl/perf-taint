//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
#define LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP

#include "results/LoopInformation.hpp"

#include "llvm/IR/Instructions.h"

#include <vector>

namespace llvm {
    class Loop;
    class BasicBlock;
    class Value;
}

using namespace llvm;

class LoopAnalyzer
{
    Loop & loop;
    Value * findLoadedValue(Value *) const;
    bool compareValues(Value * first, Value * second) const;

    Value * inspectValue(Value * val, Value * loopVar) const;
public:
    LoopAnalyzer(Loop & _loop):
        loop(_loop)
    {}

    results::LoopInformation analyze();
    Value * findInductionVariable(BasicBlock * block) const;
    Value * findInductionInitValue(BasicBlock * block, Value*) const;
    std::pair<CmpInst::Predicate, Value *> findCondition(BasicBlock * block, Value*) const;
    std::vector<Instruction*> findUpdate(BasicBlock * latch,
                                         Value * loopCounter) const;
};

#endif //LOOP_EXTRACTOR_CPP_LOOPANALYZER_HPP
