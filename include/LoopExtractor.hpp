
#ifndef LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
#define LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP


#include "LoopCounters.hpp"

#include "llvm/Pass.h"


using namespace llvm;


namespace llvm {
    class Loop;
    class ScalarEvolution;
}

namespace {

    struct LoopExtractor : public FunctionPass {
        static char ID;
        LoopCounters counters;
        LoopExtractor() : FunctionPass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage & AU) const;

        bool runOnFunction(Function & f) override;

        bool analyzeNestedLoop(Loop * l, ScalarEvolution & SE, int offset = 0);
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
