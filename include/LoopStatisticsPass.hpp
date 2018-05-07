
#ifndef LOOP_EXTRACTOR_CPP_LOOPSTATISTICS_HPP
#define LOOP_EXTRACTOR_CPP_LOOPSTATISTICS_HPP

#include "results/LoopInformation.hpp"

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
        std::vector<results::LoopInformation> loops;

        LoopStatistics() : ModulePass(ID) {}

        virtual void getAnalysisUsage(AnalysisUsage & AU) const;

        bool runOnModule(Module & m) override;
        void print(std::ostream & os, const results::LoopInformation & info) const;
    private:
        void runOnFunction(Function & f);
        void printResults(const std::string & cur_date) const;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPEXTRACTOR_HPP
