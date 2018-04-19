
#ifndef LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
#define LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP

#include "llvm/Pass.h"

using namespace llvm;

namespace {

    struct LoopExtractor : public FunctionPass {
        static char ID;
        LoopExtractor() : FunctionPass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage & AU) const;

        bool runOnFunction(Function & f) override;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
