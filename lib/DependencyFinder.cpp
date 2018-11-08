#include "DependencyFinder.hpp"
#include "FunctionAnalysis.hpp"
#include "util/util.hpp"

#include <llvm/IR/Function.h>
#include <llvm/IR/Operator.h>
#include <llvm/ADT/SmallVector.h>

#include <algorithm>
#include <stdexcept>
#include <iostream>

#include <nlohmann/json.hpp>


namespace extrap {

    void to_json(nlohmann::json& j, const extrap::Dependency * p)
    {
        p->json(j);
    }

    void FunctionArg::json(nlohmann::json & j) const
    {
        j = nlohmann::json{{"type", "arg"}, {"pos", pos}};
    }
    
    void GlobalArg::json(nlohmann::json & j) const
    {
        j = nlohmann::json{{"type", "global"}};
    }

    DependencyFinder::~DependencyFinder()
    {
        //std::for_each(dependencies.begin(), dependencies.end(),
                //[](auto & obj) { delete obj.second; });
    }
    
    bool DependencyFinder::find(const llvm::Argument * arg, const FunctionParameters & params, vec_t & ids)
    {
        //bool found = false;
        //std::string name;
        //// loop through function args
        //llvm::DISubprogram * prog = arg->getParent()->getSubprogram();
        //if(prog) {
        //    for(llvm::DINode * dbg_info : prog->getRetainedNodes()) {
        //        if(llvm::DILocalVariable * var = llvm::dyn_cast<llvm::DILocalVariable>(dbg_info)) {
        //            // is arg?
        //            if(var->getArg() - 1 == arg->getArgNo()) {
        //                name = var->getName();
        //                found = true;
        //                break;
        //            }
        //        }
        //    }
        //}
        //if(!found) {
        //    // debug information not provided
        //    if(!prog) {
        //        name = arg->getName();
        //    } else {
        //        name = arg->getName();
        //        llvm::errs() << cppsprintf("Argument %s in function %s not found - lack of debug information!\n",
        //                arg->getName().str(), arg->getParent()->getName().str());
        //    }
        //}
        ////for(auto it = llvm::inst_begin(arg->getParent()), end = llvm::inst_end(arg->getParent()); it != end; ++it) {
        ////    if(const llvm::DbgDeclareInst * inst = llvm::dyn_cast<llvm::DbgDeclareInst>(&(*it))) {
        ////        if(arg == inst->getAddress()) { 
        ////            name = inst->getVariable()->getName();
        ////        }
        ////    }
        ////    if(const llvm::DbgValueInst * inst = llvm::dyn_cast<llvm::DbgValueInst>(&(*it))) {
        ////        if(arg == inst->getValue()) {
        ////            name = inst->getVariable()->getName();
        ////        }
        ////    }
        ////}
        //name = cppsprintf("%s;arg;%u", name, arg->getArgNo());
        ////if(dependencies.find(name) == dependencies.end())
        ////dependencies[name] = new FunctionArg(arg->getArgNo());
        return false;
    }
    
    bool DependencyFinder::find(const llvm::GlobalVariable * global_var, const FunctionParameters & params, vec_t & ids)
    {
        //llvm::SmallVector<llvm::DIGlobalVariableExpression*, 10> debug;
        //global_var->getDebugInfo(debug);
        ////for(llvm::DIGlobalVariableExpression * var : debug)
        ////llvm::outs() << var->getVariable()->getName() << '\n';
        //std::string name = global_var->getName();
        //if(dependencies.find(name) == dependencies.end())
        //   dependencies[name] = new GlobalArg();
        return false;
    }

    bool DependencyFinder::find(const llvm::Value * v, const FunctionParameters & params, vec_t & ids)
    {
        //llvm::outs() << *v << ' ' << llvm::dyn_cast<llvm::LoadInst>(v) << ' ' << llvm::dyn_cast<llvm::GEPOperator>(v) << '\n';
        //
        //
        llvm::outs() << v << ' ' << *v << '\n';
        if( const vec_t * found_ids = params.find(v) ) {
            llvm::outs() << "Found: " << v << ' ' << found_ids->size() << '\n';
            ids.append(found_ids->begin(), found_ids->end());
            return true;
        }
        if(const llvm::Instruction * instr = llvm::dyn_cast<llvm::Instruction>(v)) {
            return find(instr, params, ids);
        } else if(const llvm::Argument * a = llvm::dyn_cast<llvm::Argument>(v)) {
            //find(a);
            //return true;
            return find(a, params, ids);
        } else if(const llvm::GlobalVariable * glob = llvm::dyn_cast<llvm::GlobalVariable>(v)) {
            //return find(glob);
            //return true;
            return find(glob, params, ids);
        } else if(const llvm::LoadInst * load = llvm::dyn_cast<llvm::LoadInst>(v)) {
            bool found = find(load->getPointerOperand(), params, ids);
            if(!found) {
                llvm::errs() << "Unable to understand the instruction: " << *load << '\n';
                return true;
            }
            return found;
        }
        // results of a load instruction
        else if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(v)) {
            return find(gep->getPointerOperand(), params, ids);
        }
        // We didn't understand the value
        assert(false);
        return false;
    }

    //void DependencyFinder::find(const llvm::GetElementPtrInst * instr)
    //{
    //    llvm::outs() << *instr << '\n';
    //    find(instr->getPointerOperand());
    //}
    
    bool DependencyFinder::find(const llvm::Instruction * instr, const FunctionParameters & params, vec_t & ids)
    {
        bool understood = true;
        for(int i = 0; i < instr->getNumOperands(); ++i) {
            llvm::Value * val = instr->getOperand(i);
            llvm::PHINode * phi = llvm::dyn_cast<llvm::PHINode>(val);
            if(phi) {
                if(phi_nodes.find(phi) != phi_nodes.end()) {
                   return false;
                }
                phi_nodes.insert(phi);
            }
            //if(llvm::Instruction * child_instr = llvm::dyn_cast<llvm::Instruction>(val)) {
            //found |= find(child_instr, params);
            //} else {
            //std::cout << found << '\n';
            understood &= find(val, params, ids);
            //llvm::outs() << *val << '\n';
            //std::cout << found << '\n';
            //llvm::outs() << "Found: " << found << '\n';
            //} 
            if(phi)
                phi_nodes.erase(phi);
        }
        // TODO: here overapproximate
        return understood;
    }

}
