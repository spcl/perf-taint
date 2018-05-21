//
// Created by mcopik on 5/3/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP
#define LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP

#include <string>
#include <vector>
#include <tuple>

namespace llvm {
    class Loop;
    class SCEV;
}

using namespace llvm;

struct LoopCounters
{
    std::vector<std::string> nestedLevels;
    std::vector< std::tuple<Loop*, std::string, const SCEV *> > loops;

    void enterNested(Loop * l, int multipathID);
    void leaveNested();
    void addLoop(Loop *, const SCEV *, int, int);
    std::string getCounterName(const Loop *);
    void addIV(const Loop *, const SCEV *);
    std::tuple<std::string, const SCEV *> getIV(const Loop * l);
    void clear();
};

#endif //LOOP_EXTRACTOR_CPP_LOOPCOUNTERS_HPP
