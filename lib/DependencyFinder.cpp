#include "DependencyFinder.hpp"
#include "FunctionBodyAnalyzer.hpp"
#include "FunctionAnalysis.hpp"
#include "util/util.hpp"

#include <llvm/IR/Function.h>
#include <llvm/IR/Operator.h>
#include <llvm/ADT/SmallVector.h>

#include <algorithm>
#include <stdexcept>
#include <iostream>

#include <nlohmann/json.hpp>


llvm::Type * remove_pointer(llvm::Type * type)
{
    if(type->isPointerTy())
        return remove_pointer(type->getPointerElementType());
    else
        return type;
}

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
        auto id = Parameters::find_global(global_var);
        if(id != -1) {
            ids.insert(id);
        }
        return true;
    }

    bool DependencyFinder::find(const llvm::Value * v, const AnalyzedFunction * f_analysis, const FunctionParameters & params, vec_t & ids)
    {
        if( const vec_t * found_ids = params.find(v) ) {
            ids.insert(found_ids->begin(), found_ids->end());
            return true;
        }
        //llvm::outs() << "Value: " << *v << " fields_count: " << (f_analysis ? f_analysis->located_fields.size() : 0) << '\n';
        //if(f_analysis) {
        //    for(auto & x : f_analysis->located_fields) {
        //        if(v == std::get<0>(x) ) {
        //            ids.insert(std::get<1>(x));
        //            return true;
        //        }
        //    }
        //}
        if(const llvm::BasicBlock * bb = llvm::dyn_cast<llvm::BasicBlock>(v)) {
            for(const llvm::Instruction & instr : bb->instructionsWithoutDebug())
                return find(&instr, f_analysis, params, ids);
        } else if(const llvm::Instruction * instr = llvm::dyn_cast<llvm::Instruction>(v)) {
            return find(instr, f_analysis, params, ids);
        } else if(const llvm::Argument * a = llvm::dyn_cast<llvm::Argument>(v)) {
            //find(a);
            //return true;
            return find(a, params, ids);
        } else if(const llvm::GlobalVariable * glob = llvm::dyn_cast<llvm::GlobalVariable>(v)) {
            //return find(glob);
            //return true;
            return find(glob, params, ids);
        } else if(const llvm::Constant * cons = llvm::dyn_cast<llvm::Constant>(v)) {
            // constant is always known
            return true; 
        }
        llvm::errs() << "Unknown type: " << *v << '\n';
        // We didn't understand the value
        assert(false);
        return false;
    }

    //void DependencyFinder::find(const llvm::GetElementPtrInst * instr)
    //{
    //    llvm::outs() << *instr << '\n';
    //    find(instr->getPointerOperand());
    //}
    
    bool DependencyFinder::find(const llvm::Instruction * instr, const AnalyzedFunction * f_analysis, const FunctionParameters & params, vec_t & ids)
    {
        bool understood = true;
        for(int i = 0; i < instr->getNumOperands(); ++i) {
            llvm::Value * val = instr->getOperand(i);
            llvm::PHINode * phi = llvm::dyn_cast<llvm::PHINode>(val);
            if(phi) {
                if(phi_nodes.find(phi) != phi_nodes.end()) {
                   continue;
                }
                phi_nodes.insert(phi);
            }
            if(const llvm::LoadInst * load = llvm::dyn_cast<llvm::LoadInst>(instr)) {
                bool found = find(load->getPointerOperand(), f_analysis, params, ids);
                if(!found) {
                    llvm::errs() << "Unable to understand the instruction: " << *load << '\n';
                    understood = false;
                }
            }
            // results of a load instruction
            else if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(instr)) {

                llvm::Type * type = remove_pointer(gep->getPointerOperand()->getType());
                if(const llvm::StructType * struct_val = llvm::dyn_cast<llvm::StructType>(type)) {
                    // loading from struct, check for fields
                    for(auto & x : f_analysis->located_fields) {
                        if(instr == std::get<0>(x) ) {
                            ids.insert(std::get<1>(x));
                            break;
                        }
                    }
                    //unknown field - skip, assume no dependency between non-marked and marked fields 
                } else {
                    understood &= find(gep->getPointerOperand(), f_analysis, params, ids);
                }
            } else {
                understood &= find(val, f_analysis, params, ids);
            }
            //if(llvm::Instruction * child_instr = llvm::dyn_cast<llvm::Instruction>(val)) {
            //found |= find(child_instr, params);
            //} else {
            //std::cout << found << '\n';
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
