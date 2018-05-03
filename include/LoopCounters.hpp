//
// Created by mcopik on 5/3/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP
#define LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP

#include <string>
#include <vector>

namespace llvm {
    class Loop;
    class SCEV;
}

using namespace llvm;

struct LoopCounters
{
    std::vector< std::pair<Loop*, const SCEV *> > loops;

    void addLoop(Loop *, const SCEV *);
    std::string getCounterName(const Loop *);
    void clear();
};

#endif //LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP
