
#ifndef LOOP_EXTRACTOR_CPP_LOOPSTATISTICS_HPP
#define LOOP_EXTRACTOR_CPP_LOOPSTATISTICS_HPP

#include "llvm/Pass.h"
#include "llvm/IR/PassManager.h"

#include <fstream>

using namespace llvm;

namespace llvm {
    //class Module;
    //class AnalysisUsage;
}

namespace {

    struct LoopStatistics : public ModulePass {

        static char ID;
        std::fstream unrecognized_log;

        LoopStatistics() : ModulePass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage & AU) const;

        bool runOnModule(Module & m) override;
    private:
        void runOnFunction(Function & f);
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
