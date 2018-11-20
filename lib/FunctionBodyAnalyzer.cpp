#include "FunctionBodyAnalyzer.hpp"
#include "FunctionAnalysis.hpp"

#include <llvm/Pass.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Operator.h>

namespace extrap {

    bool FunctionBodyAnalyzer::found_globals() const
    {
        return !acc_globals.empty();
    }

    bool FunctionBodyAnalyzer::found_used_globals() const
    {
        return !used_globals.empty();
    }

    bool FunctionBodyAnalyzer::found_args() const
    {
        return !used_args.empty();
    }

    FunctionBodyAnalyzer::vec_t & FunctionBodyAnalyzer::accessed_global_ids()
    {
        return acc_globals;
    }

    FunctionBodyAnalyzer::vec_t & FunctionBodyAnalyzer::used_global_ids()
    {
        return used_globals;
    }

    FunctionBodyAnalyzer::vec_t & FunctionBodyAnalyzer::used_arg_positions()
    {
        return used_args;
    }
    
    bool FunctionBodyAnalyzer::analyze_users(const llvm::Instruction & i)
    {
        const llvm::PHINode * phi = llvm::dyn_cast<llvm::PHINode>(&i);
        if(phi) {
            if(phi_nodes.find(phi) != phi_nodes.end()) {
               return false;
            }
            phi_nodes.insert(phi);
        }
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
        if(phi)
            phi_nodes.erase(phi);
        return ret_val;
    }

    void FunctionBodyAnalyzer::check_global(const llvm::Value * val, const llvm::Instruction & instr)
    {
        if(const llvm::GlobalVariable * gvar = llvm::dyn_cast<llvm::GlobalVariable>(val)) {
            Parameters::id_t id = params.find_global(gvar);
            if(id > -1 && analyze_users(instr))
                used_globals.insert(id);
            if(id > -1)
                acc_globals.insert(id);
        }
    }

    // Algorithm: for every user of the global variable, analyze each children
    // If the application is not possible to determine, such as store/load, mark as used
    // If the application is conditional branch, mark as used.
    // If the application is in a loop, mark as used - possibly overapproximate.
    // TODO: use SE/SCEV when possible to check that the use determines iterations count
    void FunctionBodyAnalyzer::find_globals(llvm::Function & f)
    {
        for(const llvm::BasicBlock & bb : f)
            for(const llvm::Instruction & instr : bb.instructionsWithoutDebug()) {
                for(const llvm::Value * val : instr.operands()) {
                    // Load and getelementptr are joined together
                    if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(val)) {
                        check_global(gep->getPointerOperand(), instr);
                    } else {
                        check_global(val, instr);
                    }
                }
            }
    }
    
    void FunctionBodyAnalyzer::find_used_args(llvm::Function & f)
    {
        for(const llvm::Argument & arg : f.args()) {
            for(const llvm::Value * val : arg.users())
            {
                if(const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(val)) {
                    if(analyze_users(*inst))
                        used_args.insert(arg.getArgNo());
                }
            }
        }
    }

    bool FunctionBodyAnalyzer::analyze(llvm::Function & f)
    {
        find_globals(f);
        find_used_args(f);
        // TODO: here process const loops
        return !linfo.empty();
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
