#ifndef __FUNCTION_BODY_ANALYZER_HPP__
#define __FUNCTION_BODY_ANALYZER_HPP__

#include "ParameterFinder.hpp"

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

    class FunctionParameters;
    
    struct AnalyzedFunction
    {
        std::vector<CallSite> callsites;
        // accessed globals
        llvm::Optional<Parameters::vec_t> globals;
        // Contains loops
        // TODO: remove const loop
        bool contains_computation;

        // globals influencing control flow
        llvm::Optional<Parameters::vec_t> cf_globals;
        // args influencing control flow
        llvm::Optional<Parameters::vec_t> cf_args;
        bool called_with_used_args;

        typedef std::tuple<const llvm::Value*, Parameters::id_t> value_t;
        llvm::SmallVector<value_t, 5> located_fields;

        AnalyzedFunction() :
            contains_computation(false)
        {}

        void call(const FunctionParameters &);
        bool matters() const;
    };

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
        // Contains pairs of llvm::Value -> parameter ID
        //typedef std::tuple<const llvm::Value*, Parameters::id_t> value_t;
        //llvm::SmallVector<value_t, 5> located_fields;

        FunctionBodyAnalyzer(const llvm::LoopInfo & _linfo,
                const FunctionParameters & _params):
            linfo(_linfo),
            params(_params)
        {}

        AnalyzedFunction * analyze(llvm::Function & f);
        void find_globals(llvm::Function & f);
        void check_global(const llvm::Value * val, const llvm::Instruction & instr);
        void find_used_args(llvm::Function &f);
        bool analyze_users(const llvm::Instruction & i);
        void find_annotations(llvm::Function & f);
        void process_struct_load(const llvm::Value * val);

        bool found_used_globals() const;
        bool found_globals() const;
        bool found_args() const;
        vec_t & accessed_global_ids();
        vec_t & used_global_ids();
        vec_t & used_arg_positions();

        AnalyzedFunction * get_analysis();
    };
}


#endif
