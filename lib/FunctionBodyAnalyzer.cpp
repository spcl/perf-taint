#include "FunctionBodyAnalyzer.hpp"
#include "FunctionAnalysis.hpp"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>

namespace extrap {

    // For function f, find out which global variables and which arguments
    // are used outside of a function call. We consider function callsite to be prunable
    // if it's not using any global variable or any marked argument outside of a call.
    //
    // Note: all users of an argument should be in the function.
    // It is NOT possible to query GV users by a function.
    //
    // Algorithm:
    // 1) For every instruction, analyze its operands and find out which parameters are involved
    // If it depends on a load which is not global variable, we mark it as depending on everything.
    // 2) 
    AnalyzedFunction * FunctionBodyAnalyzer::analyze_body(llvm::Function & f)
    {
        // maybe just global lookup?
        FunctionParameters empty;
        FunctionParameters::vec_t ids;
        for(llvm::BasicBlock & bb : f) { 
            for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {
                //dep.find(&instr, empty, ids);
            }
        }
        if(!ids.empty()) {
            AnalyzedFunction * res = new AnalyzedFunction;
            res->globals = std::move(ids);
            return res;
        } else
            return nullptr;
    }

}
