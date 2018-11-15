#ifndef __FUNCTION_BODY_ANALYZER_HPP__
#define __FUNCTION_BODY_ANALYZER_HPP__

#include <set>

#include <llvm/ADT/SmallSet.h>

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
        std::set<llvm::PHINode*> phi_nodes;
        typedef llvm::SmallSet<int32_t, 5> vec_t;

        AnalyzedFunction * analyze_body(llvm::Function & f);

        bool find(const llvm::Argument * arg, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::GlobalVariable * instr, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::Value * v, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::Instruction * instr, const FunctionParameters & params, vec_t & ids);
    };
}


#endif
