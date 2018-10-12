

#ifndef EXTRAP_EXTRACTOR_PASS_HPP
#define EXTRAP_EXTRACTOR_PASS_HPP

#include <llvm/ADT/Optional.h>
#include <llvm/Pass.h>

#include <fstream>

#include <nlohmann/json.hpp>

namespace llvm {
    class ScalarEvolution;
    class AnalysisUsage;
    class Function;
}

namespace {

    struct ExtraPExtractorPass : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        std::fstream result;
        ExtraPExtractorPass() : ModulePass(ID) {}

        virtual void getAnalysisUsage(llvm::AnalysisUsage & AU) const;

        llvm::Optional<nlohmann::json> runOnFunction(llvm::Function & f);
        bool runOnModule(llvm::Module & f) override;
    };

}

#endif
