#include "DependencyFinder.hpp"
#include "util/util.hpp"

#include <llvm/IR/Function.h>
#include <llvm/IR/Operator.h>
#include <llvm/ADT/SmallVector.h>

#include <algorithm>
#include <stdexcept>

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
        std::for_each(dependencies.begin(), dependencies.end(),
                [](auto & obj) { delete obj.second; });
    }
    
    void DependencyFinder::find(const llvm::Argument * arg)
    {
        bool found = false;
        std::string name;
        // loop through function args
        llvm::DISubprogram * prog = arg->getParent()->getSubprogram();
        if(prog) {
            for(llvm::DINode * dbg_info : prog->getRetainedNodes()) {
                if(llvm::DILocalVariable * var = llvm::dyn_cast<llvm::DILocalVariable>(dbg_info)) {
                    // is arg?
                    if(var->getArg() - 1 == arg->getArgNo()) {
                        name = var->getName();
                        found = true;
                        break;
                    }
                }
            }
        }
        if(!found) {
            // debug information not provided
            if(!prog) {
                name = arg->getName();
            } else {
                throw std::runtime_error(cppsprintf("Argument %s in function %s not found!\n",
                        arg->getName(), arg->getParent()->getName()));
            }
        }
        //for(auto it = llvm::inst_begin(arg->getParent()), end = llvm::inst_end(arg->getParent()); it != end; ++it) {
        //    if(const llvm::DbgDeclareInst * inst = llvm::dyn_cast<llvm::DbgDeclareInst>(&(*it))) {
        //        if(arg == inst->getAddress()) { 
        //            name = inst->getVariable()->getName();
        //        }
        //    }
        //    if(const llvm::DbgValueInst * inst = llvm::dyn_cast<llvm::DbgValueInst>(&(*it))) {
        //        if(arg == inst->getValue()) {
        //            name = inst->getVariable()->getName();
        //        }
        //    }
        //}
        name = cppsprintf("%s;arg;%u", name, arg->getArgNo());
        if(dependencies.find(name) == dependencies.end())
            dependencies[name] = new FunctionArg(arg->getArgNo());
    }
    
    void DependencyFinder::find(const llvm::GlobalVariable * global_var)
    {
        llvm::SmallVector<llvm::DIGlobalVariableExpression*, 10> debug;
        global_var->getDebugInfo(debug);
        //for(llvm::DIGlobalVariableExpression * var : debug)
        //llvm::outs() << var->getVariable()->getName() << '\n';
        std::string name = global_var->getName();
        if(dependencies.find(name) == dependencies.end())
            dependencies[name] = new GlobalArg();
    }

    bool DependencyFinder::find(const llvm::Value * v)
    {
        //llvm::outs() << *v << ' ' << llvm::dyn_cast<llvm::LoadInst>(v) << ' ' << llvm::dyn_cast<llvm::GEPOperator>(v) << '\n';
        if(const llvm::Argument * a = llvm::dyn_cast<llvm::Argument>(v)) {
            find(a);
            return true;
        } else if(const llvm::GlobalVariable * glob = llvm::dyn_cast<llvm::GlobalVariable>(v)) {
            find(glob);
            return true;
        } else if(const llvm::LoadInst * load = llvm::dyn_cast<llvm::LoadInst>(v)) {
            return find(load->getPointerOperand());
        }
        // results of a load instruction
        else if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(v)) {
            return find(gep->getPointerOperand());
        }
        // We didn't understand the value
        return false;
    }

    //void DependencyFinder::find(const llvm::GetElementPtrInst * instr)
    //{
    //    llvm::outs() << *instr << '\n';
    //    find(instr->getPointerOperand());
    //}
    
    bool DependencyFinder::find(const llvm::Instruction * instr)
    {
        bool understood = true;
        for(int i = 0; i < instr->getNumOperands(); ++i) {
            llvm::Value * val = instr->getOperand(i);
            llvm::PHINode * phi = llvm::dyn_cast<llvm::PHINode>(val);
            if(phi) {
                if(phi_nodes.find(phi) != phi_nodes.end()) {
                   return true;
                }
                phi_nodes.insert(phi);
            }
            if(llvm::Instruction * child_instr = llvm::dyn_cast<llvm::Instruction>(val)) {
                understood &= find(child_instr);
            } else {
                understood &= find(val);
            }
            if(phi)
                phi_nodes.erase(phi);
        }
    }

}
