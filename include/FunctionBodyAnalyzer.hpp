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
        vec_t global_ids;

        FunctionBodyAnalyzer(const FunctionParameters & _params):
            params(_params)
        {}

        void find_globals(llvm::Function & f);
        bool analyze_users(const llvm::Instruction & i);
        bool found() const;
        vec_t & ids();
    };
}


#endif
