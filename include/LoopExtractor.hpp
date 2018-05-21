
#ifndef LOOPEXTRACTOR_HPP
#define LOOPEXTRACTOR_HPP

#include "results/LoopInformation.hpp"
#include "io/ValueToString.hpp"

#include <fstream>

class SCEVAnalyzer;
class LoopCounters;

namespace llvm {
    class Loop;
    class BasicBlock;
}

using namespace llvm;

class LoopExtractor
{
    SCEVAnalyzer & scev;
    LoopCounters & counters;
    ValueToString valueFormatter;
    std::ostream & results;
    std::ostream & loop;

    const SCEV * getInitialValue(const SCEV *val);
public:
    LoopExtractor(SCEVAnalyzer & _scev, LoopCounters & _counters,
                  std::ostream & _results, std::ostream & _loop):
        scev(_scev),
        counters(_counters),
        valueFormatter(scev),
        results(_results),
        loop(_loop)
    {}

    void extract(Loop * l);
    void printLoop(const results::LoopInformation & info, Loop *l, int depth = 1);
};

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
