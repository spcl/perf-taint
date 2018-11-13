
#include "FunctionAnalysis.hpp"
#include "DependencyFinder.hpp"
#include "JSONExporter.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Operator.h>


namespace llvm {
    template<typename T, unsigned int N>
    bool operator==(const llvm::SmallSet<T, N> & obj1, const llvm::SmallSet<T, N> & obj2)
    {
        if(obj1.size() == obj2.size()) {
            auto end = obj1.end();
            for(auto it = obj1.begin(); it != end; ++it)
                if(!obj2.count(*it))
                    return false;
            return true;
        }
        return false;
    }
}

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

    bool string_compare(const std::string & str)
    {
        //ignore terminator at the endwhitespace
        return std::equal(str.begin(), str.end(), "extrap",
                [](char a, char b) {
                    return a == b || !isprint(a); 
                });
    }

    Parameters::names_range Parameters::get_parameters() const
    {
        return std::make_pair(arg_names.cbegin(), arg_names.cend());
    }

    Parameters::names_range Parameters::get_globals() const
    {
        return std::make_pair(globals_names.cbegin(), globals_names.cend());
    }

    void Parameters::find_globals(llvm::Module & m, std::vector<std::string> & global_names)
    {
        for(auto & global_var : m.getGlobalList())
        {
            if(global_var.getName().equals("llvm.global.annotations")) {
                llvm::ConstantArray *CA = llvm::dyn_cast<llvm::ConstantArray>(global_var.getInitializer());
                for(auto OI = CA->op_begin(); OI != CA->op_end(); ++OI){
                    llvm::ConstantStruct *CS = llvm::dyn_cast<llvm::ConstantStruct>(OI->get());
                    // second operator is a GEP - find the source of load which is global variable with annotation
                    llvm::GlobalVariable *annotation = llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(1)->getOperand(0));
                    llvm::ConstantDataArray * annotation_val = llvm::dyn_cast<llvm::ConstantDataArray>(
                                annotation->getInitializer()
                            );
                    if(string_compare(annotation_val->getAsString())) {
                        llvm::GlobalVariable * var = llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(0)->getOperand(0));
                        var = llvm::dyn_cast<llvm::GlobalVariable>(var->stripPointerCasts());
                        globals.push_back(var);
                        globals_names.push_back(var->getName());
                    }
                }
            }

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

    
    llvm::Optional<std::string> findDebugName(const llvm::Function * f, const llvm::Value * value)
    {
        for (auto Iter = llvm::inst_begin(f), End = llvm::inst_end(f); Iter != End; ++Iter) {
            const llvm::Instruction* instr = &*Iter;
            if (const llvm::DbgDeclareInst* DbgDeclare = llvm::dyn_cast<llvm::DbgDeclareInst>(instr)) {
                if(DbgDeclare->getAddress() == value)
                    return DbgDeclare->getVariable()->getName().str();
            } else if (const llvm::DbgValueInst* DbgValue = llvm::dyn_cast<llvm::DbgValueInst>(instr)) {
                if(DbgValue->getValue() == value)
                    return DbgValue->getVariable()->getName().str();
            }
        }
        return llvm::Optional<std::string>();
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
                //llvm::outs() << name << '\n';
                for(std::string & param_name : names) {
                    if(param_name == name) {
                        Parameters::id_t id = Parameters::add_param(name);
                        params.add(DbgDeclare->getAddress(), id);
                    }
                }
            } else if (const llvm::DbgValueInst* DbgValue = llvm::dyn_cast<llvm::DbgValueInst>(I)) {
                llvm::StringRef name = DbgValue->getVariable()->getName();
                //llvm::outs() << name << '\n';
                for(std::string & param_name : names) {
                    if(param_name == name) {
                        Parameters::id_t id = Parameters::add_param(name);
                        params.add(DbgValue->getValue(), id);
                    }
                }
            } else if(const llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(I)) {
                if(call->getCalledFunction()->getName().equals("llvm.var.annotation")) {
                    if(const llvm::GEPOperator * inst =
                            llvm::dyn_cast<llvm::GEPOperator>(call->getOperand(1))) {
                        const llvm::Value* operand = inst->getPointerOperand();
                        if(const llvm::GlobalVariable * data
                                = llvm::dyn_cast<llvm::GlobalVariable>(inst->getPointerOperand())) {
                            if(const llvm::ConstantDataArray * initializer
                                = llvm::dyn_cast<llvm::ConstantDataArray>(data->getInitializer())) {
                                std::string str = initializer->getAsString().str();
                                if(string_compare(str)) {
                                    //now read the value
                                    const llvm::Value * value = call->getOperand(0)->stripPointerCasts();
                                    auto value_name = findDebugName(f, value);
                                    assert(value_name.hasValue());
                                    Parameters::id_t id = Parameters::add_param(value_name.getValue());
                                    params.add(value, id);
                                }
                            }
                        }
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
    
    FunctionParameters::FunctionParameters(llvm::Function & f, CallSite & callsite)
    {
        // from pos -> ids
        // llvm::Value-> ids
        for(const CallSite::call_arg_t & call : callsite.parameters)
        {
            int position = std::get<0>(call);
            auto it = f.arg_begin();
            std::advance(it, position);
            arguments[ &*it ] = std::get<1>(call);
        }
    }

    FunctionParameters::FunctionParameters() {}

    void FunctionParameters::add(const llvm::Value * val, id_t id)
    {
        auto it = arguments.find(val);
        if(it == arguments.end()) {
            vec_t vec;
            vec.insert(id);
            arguments[val] = vec;
        } else
            (*it).second.insert(id); 
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

    bool CallSite::operator==(const CallSite & site) const
    {
        // same code location, same number of parameters
        // params should be in the same order since we process them always from the first arg
        return site.dbg_loc == dbg_loc && site.parameters == parameters;
    }

    void FunctionAnalysis::analyze_main(Parameters & params, std::vector<std::string> & param_names)
    {
        llvm::Function * main = m.getFunction("main");
        llvm::CallGraphNode * main_node = cg[main];
        FunctionParameters main_params = find_args(main, param_names);
        //for(auto & x : main_params.arguments)
        //    llvm::outs() << x.first << ' ' << x.second.size() << '\n';
        for(auto callsite : *main_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Value * call = callsite.first;
            llvm::Function * f = node->getFunction();
            AnalyzedFunction * f_analysis = analyze_function(*f);
            if( is_analyzable(f) ) {
                //llvm::outs() << "Main calls: " << f->getName() << " at: " << *call << '\n';
 
                // does it use parameters?
                llvm::Optional<CallSite> callsite = analyze_call(call, 
                        f_analysis ? f_analysis->globals.hasValue() : false, main_params);
               
                analyze_body(*f);

                if(callsite) {
                    //llvm::outs() << "Found pos: "; 
                    //for(auto & pos : callsite.getValue().parameters) {
                    //    llvm::outs() << std::get<0>(pos)<< ", ";
                    //    llvm::outs() << " size: " << std::get<1>(pos).size() << ' ';
                    //    for(auto & x : std::get<1>(pos))
                    //        llvm::outs() << x << ' ';
                    //    llvm::outs() << '\n';
                    //}
                    //llvm::outs() << '\n';
                    FunctionParameters call_parameters(*f, callsite.getValue());
                    insert_callsite(*f, f_analysis, callsite.getValue());
                    analyze_function(*f, call_parameters);
                }
            }
        }
        exporter.export_parameters(params);
        for(auto & f : this->functions)
            if(f.second)
                exporter.export_function(*f.first, *f.second);
    }

    void FunctionAnalysis::insert_callsite(llvm::Function & f, AnalyzedFunction * f_analysis, CallSite & site)
    {
        if(!f_analysis) {
            f_analysis = new AnalyzedFunction;
            functions[&f] = f_analysis;
        } else {
            // don't place a callsite that is already there
            // coming from a nested function call f->g->h
            // h is called at the same place, same args when f is invoked
            for(const CallSite & obj : f_analysis->callsites)
                if(site == obj)
                    return;
        }
        f_analysis->callsites.push_back( std::move(site) );
    }
    
    void FunctionAnalysis::analyze_function(llvm::Function & f, const FunctionParameters & params)
    {
        llvm::CallGraphNode * node = cg[&f];
        //for(auto & x : params.arguments)
        //llvm::outs() << x.first << ' ' << x.second.size() << '\n';
        for(auto callsite : *node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Value * call = callsite.first;
            llvm::Function * f = node->getFunction();
            AnalyzedFunction * f_analysis = analyze_function(*f);
            if( is_analyzable(f) ) {
                //llvm::outs() << "calls: " << f->getName() << " at: " << *call << '\n';
 
                // does it use parameters?
                llvm::Optional<CallSite> callsite = analyze_call(call,
                        f_analysis ? f_analysis->globals.hasValue() : false, params);
                
                if(callsite) {
                    //llvm::outs() << "Found pos: "; 
                    //for(auto & pos : callsite.getValue().parameters) {
                    //    llvm::outs() << std::get<0>(pos)<< ", ";
                    //    llvm::outs() << " size: " << std::get<1>(pos).size() << ' ';
                    //    for(auto & x : std::get<1>(pos))
                    //        llvm::outs() << x << ' ';
                    //    llvm::outs() << '\n';
                    //}
                    //llvm::outs() << '\n';
                    analyze_body(*f);
                    insert_callsite(*f, f_analysis, callsite.getValue());
                    FunctionParameters call_parameters(*f, callsite.getValue());
                    analyze_function(*f, call_parameters);
                }
            }
        }
    }

    AnalyzedFunction * FunctionAnalysis::analyze_function(llvm::Function & f)
    {
        //Caching
        auto it = functions.find(&f);
        if(it != functions.end()) {
            //already here, just return ref
            return (*it).second; 
            //(*it).second.globals = std::move(ids);
        } else { 
            AnalyzedFunction * func = analyze_body(f);
            functions[&f] = func;
            return func;
        }
    }

    AnalyzedFunction * FunctionAnalysis::analyze_body(llvm::Function & f)
    {
        // maybe just global lookup?
        FunctionParameters empty;
        DependencyFinder dep;
        FunctionParameters::vec_t ids;
        for(llvm::BasicBlock & bb : f) { 
            for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {
                dep.find(&instr, empty, ids);
            }
        }
        if(!ids.empty()) {
            AnalyzedFunction * res = new AnalyzedFunction;
            res->globals = std::move(ids);
            return res;
        } else
            return nullptr;
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

    llvm::Optional<CallSite> FunctionAnalysis::analyze_call(llvm::Value * v, bool has_globals, const FunctionParameters & params)
    {
        llvm::Optional<CallSite> site;
        FunctionParameters::vec_t ids;
        if(llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(v)) {
            DependencyFinder dep;
            if(has_globals)
                site = CallSite(call->getDebugLoc());
            llvm::errs() << call->getFunction()->getName() << " " << call->getCalledFunction()->getName() << '\n';
            llvm::errs() << "Arguments: ";
            for(auto & x : params.arguments)
                llvm::errs() << "(" << x.first << ',' << x.second.size() << ')';
            llvm::errs() << "\n";
            // last operand is the function name
            for(int i = 0; i < call->getNumOperands() - 1; ++i) {
                llvm::errs() << "Look in operand: " << *call->getOperand(i) << ' ' << ids.size() << '\n';
                dep.find(call->getOperand(i), params, ids);
                if(!ids.empty()) {
                    if(!site)
                        site = CallSite(call->getDebugLoc());
                    llvm::errs() << "Called: " << i << " with ids_size: " << ids.size() << '\n';
                    site->called(i, ids);
                    ids.clear();
                }
            }
            return site;
        }
        assert(false);
    }
}
