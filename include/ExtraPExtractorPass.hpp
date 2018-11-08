

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
    class PollyVisitor;
    class DependencyFinder;
    class Parameters;
}

namespace {

    struct Statistics
    {
        uint32_t functions_count;
        uint32_t understood_functions;

        Statistics() : functions_count(0), understood_functions(0) {}
        void processed_function(bool undef);

        template<typename OS>
        void dump(OS & os) const
        {
            os << "results " << functions_count << ' ' << understood_functions << '\n';
        }
    };

    struct ExtraPExtractorPass : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        Statistics stats;
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


        void findGlobals(const llvm::Module & m, std::vector<std::string> & globals, extrap::Parameters & params);
        bool compute_scev(llvm::Loop * l, extrap::ScalarEvolutionVisitor & vis, nlohmann::json & result);
        bool compute_polly_scev(llvm::Loop * l, llvm::Function & f, llvm::ModuleSlotTracker & MST,
                extrap::PollyVisitor & vis, nlohmann::json & result);
        bool manual_dependencies(llvm::Loop * l, extrap::DependencyFinder &, nlohmann::json &);
    };

}

#endif
