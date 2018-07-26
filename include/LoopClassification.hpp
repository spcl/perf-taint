//
// Created by mcopik on 5/4/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP
#define LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP

#include "results/LoopInformation.hpp"
#include <io/SCEVAnalyzer.hpp>
#include <results/LoopIV.hpp>

#include <tuple>
#include <ostream>

class LoopCounters;

namespace llvm {
    class Loop;
    class BasicBlock;
}

using namespace llvm;

class LoopClassification
{
    SCEVAnalyzer & scev;
    LoopCounters & counters;
    loopprofiler::LoopIVFinder iv_finder;
    std::ostream & os;
    bool verbose;
  loopprofiler::LoopIV analyzeExit(Loop * l, BasicBlock * block);
public:
    LoopClassification(SCEVAnalyzer & _scev, LoopCounters & _counters, std::ostream & _os):
        scev(_scev),
        counters(_counters),
        iv_finder(_scev.getSE(), _os),
        os(_os),
        verbose(true)
    {}

    void silence();

    results::LoopInformation classify(Loop * l);
};

#endif //LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP
