
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

    int undef_counter;

    const SCEV * getInitialValue(const SCEV *val);
public:
    LoopExtractor(SCEVAnalyzer & _scev, LoopCounters & _counters,
                  std::ostream & _results, std::ostream & _loop):
        scev(_scev),
        counters(_counters),
        valueFormatter(scev, _results),
        results(_results),
        loop(_loop),
        undef_counter(0)
    {
        scev.setValuePrinter(&valueFormatter);
    }

    bool extract(Loop * l, int idx);
    std::tuple<std::string, int, int> printLoop(const results::LoopInformation & info, Loop *l, int depth = 1, bool justHeader = false);
    bool printOuterLoop(const results::LoopInformation & info, Loop *l, int idx);
};

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
