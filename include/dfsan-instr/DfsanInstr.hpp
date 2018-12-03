

#ifndef DFSAN_INSTR_PASS_HPP
#define DFSAN_INSTR_PASS_HPP

#include "ParameterFinder.hpp"

#include <llvm/ADT/Optional.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/Pass.h>

#include <fstream>
#include <unordered_map>

#include <nlohmann/json.hpp>

namespace llvm {
    class Function;
    class CallGraph;
}

namespace extrap {


    struct Instrumenter
    {
        llvm::Module & m;
        llvm::IRBuilder<> builder;
        //std::unordered_map<Parameters::id_t, llvm::GlobalVariable> allocated;
        size_t functions_count;
        size_t params_count;
        llvm::GlobalVariable * result_array;
        static constexpr const char * result_array_name = "__EXTRAP_INSTRUMENTATION_RESULTS";

        llvm::Function * load_function;

        Instrumenter(llvm::Module & _m):
            m(_m),
            builder(m.getContext()),
            functions_count(0),
            result_array(nullptr)
        {
            declareFunctions();
        }

        // Allocated global size: (functions_count) x found_parameters
        void declareFunctions();
        void createGlobalStorage(size_t functions_count);
        void checkLabel(int function_idx, llvm::BranchInst * br);
        void checkLabel(int function_idx, llvm::Value * cast);
    };
    
    struct InstrumenterVisiter : public llvm::InstVisitor<InstrumenterVisiter, void>
    {
        Instrumenter & instr;
        int function_idx;
        // avoid duplicates
        llvm::SmallSet<llvm::LoadInst*, 10> processed_loads;
        InstrumenterVisiter(Instrumenter & _instr, int idx):
            instr(_instr),
            function_idx(idx)
            {}
        void visitLoadInst(llvm::LoadInst &);
        void visitInstruction(llvm::Instruction &);
    };

    struct DfsanInstr : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        llvm::Module * m;
        llvm::CallGraph * cgraph;
        FunctionParameters parameters;
        std::unordered_map<llvm::Function *, int> instrumented_functions;
        std::ofstream unknown;

        //Statistics stats;
        DfsanInstr():
            ModulePass(ID),
            m(nullptr),
            cgraph(nullptr),
            unknown(std::ofstream("unknown", std::ios::out))
        {}

        ~DfsanInstr()
        {
            unknown.close();
        }

        void getAnalysisUsage(llvm::AnalysisUsage & AU) const;
        void runOnFunction(llvm::Function & f );
        void modifyFunction(llvm::Function & f, Instrumenter &);
        bool runOnModule(llvm::Module & f) override;
        bool is_analyzable(llvm::Module & m, llvm::Function & f);
    };

}

#endif
