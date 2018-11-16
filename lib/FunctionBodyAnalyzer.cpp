#include "FunctionBodyAnalyzer.hpp"
#include "FunctionAnalysis.hpp"

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>

namespace extrap {

    bool FunctionBodyAnalyzer::found() const
    {
        return !global_ids.empty();
    }
    
    FunctionBodyAnalyzer::vec_t & FunctionBodyAnalyzer::ids()
    {
        return global_ids;
    }
    
    bool FunctionBodyAnalyzer::analyze_users(const llvm::Instruction & i)
    {
        bool ret_val = false;
        for(const llvm::Value * val : i.users()) {
            if(const llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(val))
                return true;
            // we don't know what's going to happen, overapproximate - we use it
            if(const llvm::StoreInst * st = llvm::dyn_cast<llvm::StoreInst>(val))
                return true;
            if(const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(val))
                ret_val |= analyze_users(*inst);
        }
        return ret_val;
    }

    // Algorithm: for every user of the global variable, analyze each children
    // If the application is not possible to determine, such as store/load, mark as used
    // If the application is conditional branch, mark as used.
    // If the application is in a loop, mark as used - possibly overapproximate.
    // TODO: use SE/SCEV when possible to check that the use determines iterations count
    void FunctionBodyAnalyzer::find_globals(llvm::Function & f)
    {
        for(const llvm::BasicBlock & bb : f)
            for(const llvm::Instruction & instr : bb.instructionsWithoutDebug())
                for(const llvm::Value * val : instr.operands())
                    if(const llvm::GlobalVariable * gvar =
                            llvm::dyn_cast<llvm::GlobalVariable>(val)) {
                        Parameters::id_t id = params.find_global(gvar);
                        if(id > -1 && analyze_users(instr))
                            global_ids.insert(id);
                    }
    }

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
//    AnalyzedFunction * FunctionBodyAnalyzer::analyze_body(llvm::Function & f)
//    {
//        // maybe just global lookup?
//        FunctionParameters empty;
//        FunctionParameters::vec_t ids;
//        for(llvm::BasicBlock & bb : f) { 
//            for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {
//                //dep.find(&instr, empty, ids);
//            }
//        }
//        if(!ids.empty()) {
//            AnalyzedFunction * res = new AnalyzedFunction;
//            res->globals = std::move(ids);
//            return res;
//        } else
//            return nullptr;
//    }

}
