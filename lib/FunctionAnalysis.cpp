
#include "FunctionAnalysis.hpp"
#include "FunctionBodyAnalyzer.hpp"
#include "DependencyFinder.hpp"
#include "JSONExporter.hpp"
#include "ExtraPExtractorPass.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Operator.h>


namespace llvm {
    // TODO: this is far from from optimal...
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

    FunctionAnalysis::~FunctionAnalysis()
    {
        unknown.close();
        blacklist.close();
        whitelist.close();
        std::for_each(functions.begin(), functions.end(),
                [](std::pair<llvm::Function *, AnalyzedFunction*> p) {
                    delete p.second;
                });
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

    void FunctionAnalysis::insert_callsite(llvm::Function & f, AnalyzedFunction * f_analysis, CallSite && site)
    {
        //nullptr means this function is processed but not important
        //just store callsites since we found the callsite to be important
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
        if(f_analysis->cf_args && !f_analysis->called_with_used_args) {
            auto begin = f_analysis->cf_args->begin(),
                 end = f_analysis->cf_args->end();
            //llvm::outs() << "Args: "; 
            //for(auto it = begin; it != end;++it)
            //    llvm::outs() << (*it) << ' ';
            //llvm::outs() << '\n'; 
            //llvm::outs() << "Called: "; 
            for(auto & arg : site.parameters) {
                //llvm::outs() << std::get<0>(arg) << ' ';
                if(std::find(begin, end, std::get<0>(arg)) != end) {
                    f_analysis->called_with_used_args = true;
                    break;
                }
            }
            //llvm::outs() << '\n'; 
        }
        f_analysis->callsites.push_back(site);
    }

    void FunctionAnalysis::analyze_main(Parameters & params, std::vector<std::string> & param_names)
    {
        llvm::Function * main = m.getFunction("main");
        llvm::CallGraphNode * main_node = cg[main];
        ParameterFinder finder(m, *main);
        FunctionParameters main_params = finder.find_args(param_names);
        AnalyzedFunction * f_analyzed = analyze_function(*main);
        analyze_function(*main, f_analyzed, main_params);
        exporter.export_parameters(params);
        int found_callsites = 0, found_functions = 0;

        // The Function->Analysis map sorts by default by the pointer value
        // That might create different function orders in the LLVM
        // We want to have this list generated always in the same order.
        // Solution: copy to vector, sort. Assume at most few hundreds functions
        //
        // An alternative would be a map which either sorts deterministically
        // or preserves the input order.
        std::vector< std::pair<llvm::Function*, AnalyzedFunction*> > sorted;
        sorted.reserve(this->functions.size());
        for(auto & f : this->functions) {
            found_functions += f.second->matters();
            if(f.second->matters()) {
                sorted.push_back(f);
                found_callsites += f.second->callsites.size();
            }
        }

        // Compare: -1 for less, 0 equal, 1 for greater
        // Lambdar return: 0 for less, 1 for greater or equal
        std::sort(sorted.begin(), sorted.end(),
                [](auto a, auto b) {
                    return a.first->getName().compare(b.first->getName()) == -1;
                });
        for(auto & f : sorted) {
            if(f.second && f.second->matters())
                exporter.export_function(*f.first, *f.second);
        }
        if(stats) {
            exporter.export_statistics_found(found_callsites, found_functions);
            exporter.export_statistics_total(stats->callsites_count, stats->functions_count);
        }
            
    }
    
    void FunctionAnalysis::analyze_function(llvm::Function & f, AnalyzedFunction * f_analyzed, const FunctionParameters & params)
    {
        llvm::CallGraphNode * node = cg[&f];
        for(auto callsite : *node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            if(!called_f) {
                unknown << "External function call in: " << f.getName().str() << '\n';
                continue;
            }
            assert(call);

            if(phi_nodes.find(called_f) != phi_nodes.end()) {
               continue;
            }
            phi_nodes.insert(called_f);
            llvm::outs() << f.getName() << " calls: " << called_f->getName() << '\n';

            if( is_analyzable(called_f) ) {

                assert(called_f);
                FunctionParameters call_parameters;
                //non-NULL when the f is already known to access globals and call with params
                AnalyzedFunction * f_analysis = analyze_function(*called_f);
                llvm::Optional<CallSite> callsite = analyze_call(call, f_analyzed, f_analysis, params); 
                if(stats) 
                    stats->found_callsite(called_f, get_call_loc(call), callsite.hasValue());
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
                    call_parameters = FunctionParameters(*called_f, callsite.getValue());
                    insert_callsite(*called_f, f_analysis, std::move(callsite.getValue()));
                }
                // Call with empty call_parameters (only globals) if callsite is unimportant
                analyze_function(*called_f, f_analysis, call_parameters);
            }
            phi_nodes.erase(called_f);
        }
    }

    AnalyzedFunction * FunctionAnalysis::analyze_function(llvm::Function & f)
    {
        //Caching
        auto it = functions.find(&f);
        if(it != functions.end()) {
            //already here, just return ref
            return (*it).second; 
        } else { 
            AnalyzedFunction * func = analyze_body(f);
            functions[&f] = func;
            return func;
        }
    }

    AnalyzedFunction * FunctionAnalysis::analyze_body(llvm::Function & f)
    {
        if(is_analyzable(&f)) {
            // maybe just global lookup?
            FunctionParameters empty;
            //DependencyFinder dep;
            //FunctionParameters::vec_t ids;
            FunctionBodyAnalyzer analyzer(pass.getLoopInfo(f), empty);
            //for(llvm::BasicBlock & bb : f) { 
            //    for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {
            //        dep.find(&instr, empty, ids);
            //    }
            //}
            return analyzer.analyze(f);
        }
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

    template<typename Inst>
    const llvm::DebugLoc * FunctionAnalysis::get_call_loc(llvm::CallBase<Inst> * call)
    {
        return &call->getDebugLoc();
    }

    const llvm::DebugLoc * FunctionAnalysis::get_call_loc(llvm::Value * v)
    {
        if(llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(v)) {
            return get_call_loc(call);
        } else if(llvm::InvokeInst * call = llvm::dyn_cast<llvm::InvokeInst>(v)) {
            return get_call_loc(call);
        }
        assert(false);
    }

    template<typename T>
    llvm::Optional<CallSite> FunctionAnalysis::analyze_call(llvm::CallBase<T> * call, AnalyzedFunction * caller_an, AnalyzedFunction * called_an, const FunctionParameters & params)
    {
        llvm::Optional<CallSite> site;
        FunctionParameters::vec_t ids;
        DependencyFinder dep;
        bool has_globals = called_an->globals.hasValue();
        if(has_globals)
            site = CallSite(call->getDebugLoc());
        for(int i = 0; i < call->getNumArgOperands(); ++i) {
            dep.find(call->getArgOperand(i), caller_an, params, ids);
            if(!ids.empty()) {
                if(!site)
                    site = CallSite(call->getDebugLoc());
                site->called(i, ids);
                ids.clear();
            }
        }
        return site;
    }

    llvm::Optional<CallSite> FunctionAnalysis::analyze_call(llvm::Value * v, AnalyzedFunction * caller_an, AnalyzedFunction * called_an, const FunctionParameters & params)
    {
        if(llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(v)) {
            return analyze_call(call, caller_an, called_an, params);
        } else if(llvm::InvokeInst * call = llvm::dyn_cast<llvm::InvokeInst>(v)) {
            return analyze_call(call, caller_an, called_an, params);
        }
        assert(false);
    }
}
