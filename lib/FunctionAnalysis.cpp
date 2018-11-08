
#include "FunctionAnalysis.hpp"
#include "DependencyFinder.hpp"
#include "JSONExporter.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/DebugInfoMetadata.h>

namespace extrap {

    std::vector< const llvm::GlobalVariable * > Parameters::globals;
    std::vector< std::string > Parameters::globals_names;
    std::vector< std::string > Parameters::arg_names;
    Parameters::id_t Parameters::GLOBAL_THRESHOLD = 100;

    std::string Parameters::get_param(id_t id)
    {
        if(id >= GLOBAL_THRESHOLD)
            return globals_names[id - GLOBAL_THRESHOLD];
        else
            return arg_names[id];
    }

    void Parameters::find_globals(llvm::Module & m, std::vector<std::string> & global_names)
    {
        for(auto & global_var : m.getGlobalList())
        {
            // TODO: do I need to compare against dbg info?
            for(auto it = global_names.begin(); it != global_names.end(); ++it) {
                if(global_var.getName() == (*it)) {
                    globals.push_back(&global_var);
                    globals_names.push_back((*it));
                    global_names.erase(it);
                    break;
                }
            }
        }
        if(!global_names.empty())
            std::runtime_error("Some globals have not been found!\n");
    }

    Parameters::id_t Parameters::find_global(const llvm::GlobalVariable * v)
    {
        typedef std::vector<const llvm::GlobalVariable*>::iterator iterator;
        iterator it = std::find(globals.begin(), globals.end(), v);
        if(it != globals.end())
            return std::distance(globals.begin(), it) + GLOBAL_THRESHOLD;
        else
            return -1;
    }
    
    FunctionParameters find_args(llvm::Function * f, std::vector<std::string> & names)
    {
        //TOOD: this can get messy with phi-nodes and missing declarations
        //maybe we need to check by debug names?
        //for(llvm::BasicBlock & bb : *f) {
        //    for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {        
        //        instr.
        //    }
        //}
        FunctionParameters params;
        llvm::DISubprogram * prog = f->getSubprogram();
        //for(llvm::DINode * dbg_info : prog->getRetainedNodes()){
        //    if(llvm::DILocalVariable * var = llvm::dyn_cast<llvm::DILocalVariable>(dbg_info)) {
        //        llvm::StringRef name = var->getName();
        //        for(std::string & param_name : names) {
        //            if(param_name == name) {
        //                args.push_back(
        //    }
        //}
        for (auto Iter = llvm::inst_begin(f), End = llvm::inst_end(f); Iter != End; ++Iter) {
            const llvm::Instruction* I = &*Iter;
            if (const llvm::DbgDeclareInst* DbgDeclare = llvm::dyn_cast<llvm::DbgDeclareInst>(I)) {
                llvm::StringRef name = DbgDeclare->getVariable()->getName();
                llvm::outs() << name << '\n';
                for(std::string & param_name : names) {
                    if(param_name == name) {
                        Parameters::id_t id = Parameters::add_param(name);
                        params.add(DbgDeclare->getAddress(), id);
                    }
                }
            } else if (const llvm::DbgValueInst* DbgValue = llvm::dyn_cast<llvm::DbgValueInst>(I)) {
                llvm::StringRef name = DbgValue->getVariable()->getName();
                llvm::outs() << name << '\n';
                for(std::string & param_name : names) {
                    if(param_name == name) {
                        Parameters::id_t id = Parameters::add_param(name);
                        params.add(DbgValue->getValue(), id);
                    }
                }
            }
        }
        return params;
    }

    Parameters::id_t Parameters::add_param(std::string name)
    {
        arg_names.push_back(name);
        return arg_names.size() - 1;
    }
    
    FunctionParameters::FunctionParameters(CallSite & callsite)
    {
        //TODO:
    }

    FunctionParameters::FunctionParameters() {}

    void FunctionParameters::add(llvm::Value * val, id_t id)
    {
        auto it = arguments.find(val);
        if(it == arguments.end()) {
            vec_t vec;
            vec.push_back(id);
            arguments[val] = vec;
        } else
            (*it).second.push_back(id); 
    }

    const FunctionParameters::vec_t * FunctionParameters::find(const llvm::Value * v) const
    {
        auto it = arguments.find(v);
        return it != arguments.end() ? &(*it).second : nullptr;
    }

    void CallSite::called(int pos, const FunctionParameters::vec_t & args)
    {
        parameters.push_back( std::make_tuple(pos, args) );
    }

    void FunctionAnalysis::analyze_main(Parameters & params, std::vector<std::string> & param_names)
    {
        llvm::Function * main = m.getFunction("main");
        llvm::CallGraphNode * main_node = cg[main];
        FunctionParameters main_params = find_args(main, param_names);
        for(auto & x : main_params.arguments)
            llvm::outs() << x.first << ' ' << x.second.size() << '\n';
        for(auto callsite : *main_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Value * call = callsite.first;
            llvm::Function * f = node->getFunction();
            if( is_analyzable(f) ) {
                llvm::outs() << "Main calls: " << f->getName() << " at: " << *call << '\n';
 
                // does it use parameters?
                llvm::Optional<CallSite> callsite = analyze_call(call, main_params);
                
                if(callsite) {
                    llvm::outs() << "Found pos: "; 
                    for(auto & pos : callsite.getValue().parameters) {
                        llvm::outs() << std::get<0>(pos)<< ", ";
                        llvm::outs() << " size: " << std::get<1>(pos).size() << ' ';
                        for(auto & x : std::get<1>(pos))
                            llvm::outs() << x << ' ';
                        llvm::outs() << '\n';
                    }
                    llvm::outs() << '\n';
                    auto it = this->callsites.find(f);
                    if(it == this->callsites.end()) {
                        this->callsites[f] = std::vector<CallSite>{callsite.getValue()};
                    } else
                       (*it).second.push_back(callsite.getValue()); 
                }
            }
        }
        for(auto & f : this->callsites)
            exporter.export_function(*f.first, f.second.begin(), f.second.end());
    }

    bool FunctionAnalysis::is_analyzable(llvm::Function * f)
    {
        llvm::Function * in_module = m.getFunction(f->getName());
        if(f->isDeclaration() || !in_module) {
            unknown << f->getName().str() << '\n';
            return false;
        }
        return true;
    }

    llvm::Optional<CallSite> FunctionAnalysis::analyze_call(llvm::Value * v, const FunctionParameters & params)
    {
        llvm::Optional<CallSite> site;
        FunctionParameters::vec_t ids;
        if(llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(v)) {
            DependencyFinder dep;
            // last operand is the function name
            for(int i = 0; i < call->getNumOperands() - 1; ++i) {
                llvm::outs() << "Look in operand: " << *call->getOperand(i) << '\n';
                dep.find(call->getOperand(i), params, ids);
                if(!ids.empty()) {
                    if(!site)
                        site = CallSite(call->getDebugLoc());
                    llvm::outs() << "Called: " << i << " with ids_size: " << ids.size() << '\n';
                    site->called(i, ids);
                    ids.clear();
                }
            }
            return site;
        }
        assert(false);
    }
}
