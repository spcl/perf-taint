#ifndef __FUNCTION_BODY_ANALYZER_HPP__
#define __FUNCTION_BODY_ANALYZER_HPP__

#include <set>

#include <llvm/ADT/SmallSet.h>
#include <llvm/IR/InstVisitor.h>

namespace llvm {
    class Argument;
    class Instruction;
    class Value;
    class PHINode;
    class GlobalVariable;
    class GetElementPtrInst;
    class Function;
    class LoopInfo;
}

namespace extrap {

    class AnalyzedFunction;
    class FunctionParameters;

    struct FunctionBodyAnalyzer
    {
        typedef llvm::SmallSet<int32_t, 5> vec_t;
        typedef void RetType;
        std::set<const llvm::PHINode*> phi_nodes;
        const FunctionParameters & params;
        const llvm::LoopInfo & linfo;
        vec_t acc_globals;
        vec_t used_globals;
        vec_t used_args;

        FunctionBodyAnalyzer(const llvm::LoopInfo & _linfo,
                const FunctionParameters & _params):
            linfo(_linfo),
            params(_params)
        {}

        bool analyze(llvm::Function & f);
        void find_globals(llvm::Function & f);
        void find_used_args(llvm::Function &f);
        bool analyze_users(const llvm::Instruction & i);
        bool found_used_globals() const;
        bool found_globals() const;
        bool found_args() const;
        vec_t & accessed_global_ids();
        vec_t & used_global_ids();
        vec_t & used_arg_positions();
    };
}


#endif
