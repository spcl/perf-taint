

#ifndef EXTRAP_EXTRACTOR_PASS_HPP
#define EXTRAP_EXTRACTOR_PASS_HPP

#include <llvm/ADT/Optional.h>
#include <llvm/Pass.h>

#include <fstream>

#include <nlohmann/json.hpp>

class isl_printer;

namespace llvm {
    class ScalarEvolution;
    class AnalysisUsage;
    class Function;
    class ModuleSlotTracker;
    class Loop;
}

namespace polly {
    class PolySCEV;
}

namespace extrap {
    class ScalarEvolutionVisitor;
    class DependencyFinder;
}

namespace {

    struct ExtraPExtractorPass : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        ExtraPExtractorPass():
            ModulePass(ID),
            SE(nullptr),
            SCEV(nullptr),
            isl_print(nullptr)
        {}

        ~ExtraPExtractorPass();

        virtual void getAnalysisUsage(llvm::AnalysisUsage & AU) const;

        llvm::Optional<nlohmann::json> runOnFunction(llvm::Function & f);
        bool runOnModule(llvm::Module & f) override;
    private:
        llvm::ScalarEvolution * SE;
        polly::PolySCEV * SCEV;
        isl_printer * isl_print;

        bool compute_scev(llvm::Loop * l, extrap::ScalarEvolutionVisitor & vis, nlohmann::json & result);
        bool compute_polly_scev(llvm::Loop * l, llvm::Function & f, llvm::ModuleSlotTracker & MST,
                nlohmann::json & result);
    };

}

#endif
