
#ifndef LOOPEXTRACTORPASS_HPP
#define LOOPEXTRACTORPASS_HPP


#include "LoopCounters.hpp"

#include "llvm/Pass.h"

#include <fstream>

using namespace llvm;


namespace llvm {
    class Loop;
    class ScalarEvolution;
}

namespace nlohmann {
    class json;
}

namespace {

    struct LoopExtractorPass : public ModulePass
    {
        static char ID;
        std::fstream log;
        std::fstream loops;
        LoopCounters counters;
        LoopExtractorPass() : ModulePass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage & AU) const;

        bool runOnFunction(Function & f, nlohmann::json &);
        bool runOnModule(Module &) override;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
