

#ifndef __PERF_TAINT_PASS_HPP__
#define __PERF_TAINT_PASS_HPP__

#include <perf-taint/llvm-pass/ParameterFinder.hpp>
#include <perf-taint/llvm-pass/DebugInfo.hpp>
#include <perf-taint/llvm-pass/FunctionDatabase.hpp>
#include <perf-taint/llvm-pass/common.hpp>
#include <perf-taint/llvm-pass/Statistics.hpp>

#include <llvm/ADT/Optional.h>
#include <llvm/Pass.h>

#include <fstream>
#include <unordered_map>


namespace llvm {
    class Function;
    class CallGraph;
    class CallGraphNode;
    class LoopInfo;
    class Loop;
    class ScalarEvolution;
}

namespace perf_taint {

  struct Function;
  struct ImplicitCall;


    struct DfsanInstr : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        llvm::Module * m;
        llvm::CallGraph * cgraph;
        llvm::LoopInfo * linfo;
        FunctionParameters parameters;
        FunctionDatabase database;

        // Insert null value when function is not importan
        // Important function:
        // a) has non-const loops
        // b) has call to OpenMP fork-call
        // c) has MPI call?
        //
        std::unordered_map<llvm::Function *, llvm::Optional<Function>> instrumented_functions;
        std::vector<llvm::Function *> notinstrumented_functions;
        std::unordered_map<std::string, int> implicit_functions;
        //std::vector<int> loops_depths;
        //std::vector<int> loops_counts;
        std::vector<llvm::Function *> parent_functions;
        int instrumented_functions_counter;
        std::ofstream unknown;
        Statistics stats;
        // TODO: something smarter here
        // first traversal of functions cannot 
        std::vector< std::tuple<const llvm::Value*, Parameters::id_t>> found_params;

        std::unordered_map<llvm::Function*, bool> calls_important;

        std::set<llvm::Function*> recursive_functions;

        DfsanInstr():
            ModulePass(ID),
            m(nullptr),
            cgraph(nullptr),
            linfo(nullptr),
            instrumented_functions_counter(0),
            unknown(std::ofstream("unknown", std::ios::out))
        {
        }

        ~DfsanInstr()
        {
            unknown.close();
        }

        void getAnalysisUsage(llvm::AnalysisUsage & AU) const override;
        bool runOnFunction(llvm::Function & f, int override_counter = -1);
        void modifyFunction(llvm::Function & f, Function & func, Instrumenter &);

        bool callsImportantFunction(const llvm::CallBase * call);
        bool callsImportantFunction(llvm::Function *, std::set<llvm::Function*> & recursive_calls);
        bool analyzeFunction(llvm::Function & f, llvm::CallGraphNode * cg_node,
                int override_counter = -1);
        bool runOnModule(llvm::Module & f) override;
        bool is_analyzable(llvm::Module & m, llvm::Function & f);
        bool handleOpenMP(llvm::Function &f, int override_counter = -1);
        void foundFunction(llvm::Function &f, bool important, int counter = -1);
        void insertCallsite(llvm::Function & f, llvm::Value * val);
    };

}

#endif

