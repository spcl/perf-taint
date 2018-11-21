
#ifndef __FUNCTION_ANALYSIS__
#define __FUNCTION_ANALYSIS__

#include "ParameterFinder.hpp"
#include "Statistics.hpp"

#include <llvm/ADT/Optional.h>

#include <vector>
#include <fstream>
#include <set>
#include <tuple>


namespace llvm {

    class DebugLoc;
    class Function;
    class Value;
    class Module;
    class CallGraph;
    class GlobalVariable;
    template<typename Inst>
    class CallBase;
}

namespace extrap {

    class JSONExporter;
    class ExtraPExtractorPass;

    struct CallSite
    {
        // mapping position -> involved parameters
        typedef std::tuple<int, FunctionParameters::vec_t> call_arg_t;
        std::vector<call_arg_t> parameters;
        const llvm::DebugLoc * dbg_loc;

        CallSite(const llvm::DebugLoc & _dbg_loc) : dbg_loc(&_dbg_loc) {}

        void called(int pos, const FunctionParameters::vec_t & args);

        bool operator==(const CallSite & site) const;
    };

    struct AnalyzedFunction
    {
        std::vector<CallSite> callsites;
        // accessed globals
        llvm::Optional<Parameters::vec_t> globals;
        // Contains loops
        // TODO: remove const loop
        bool contains_computation;

        // globals influencing control flow
        llvm::Optional<Parameters::vec_t> cf_globals;
        // args influencing control flow
        llvm::Optional<Parameters::vec_t> cf_args;
        bool called_with_used_args;

        AnalyzedFunction() :
            contains_computation(false)
        {}

        void call(const FunctionParameters &);
        bool matters() const;
    };

    struct FunctionAnalysis
    {
        ExtraPExtractorPass & pass;
        llvm::CallGraph & cg;
        llvm::Module & m;
        extrap::JSONExporter & exporter;
        llvm::Optional<extrap::Statistics> stats;
        std::ofstream unknown;
        std::ofstream blacklist;
        std::ofstream whitelist;
        // Functions that are already analyzed
        std::set< llvm::Function* > verified;

        // unify that into a single structure
        std::unordered_map<llvm::Function *, AnalyzedFunction*> functions;

        //TODO: remove that reference
        FunctionAnalysis(ExtraPExtractorPass & _pass, llvm::CallGraph & _cg, llvm::Module & _m,
                extrap::JSONExporter & exp, bool generate_stats) :
            pass(_pass),
            cg(_cg),
            m(_m),
            exporter(exp),
            unknown("unknown_functions", std::ios::out),
            blacklist("unknown_functions", std::ios::out),
            whitelist("unknown_functions", std::ios::out)
        {
            if(generate_stats)
                stats = Statistics();
        }

        ~FunctionAnalysis()
        {
            unknown.close();
            blacklist.close();
            whitelist.close();
            std::for_each(functions.begin(), functions.end(),
                    [](std::pair<llvm::Function *, AnalyzedFunction*> p) {
                        delete p.second;
                    });
        }

        void insert_callsite(llvm::Function & f, AnalyzedFunction * f_analysis, CallSite &&);
        void insert_func(llvm::Function & f, Parameters::vec_t & globals);
        AnalyzedFunction * analyze_body(llvm::Function & f);
        void analyze_function(llvm::Function & f, const FunctionParameters &);
        AnalyzedFunction * analyze_function(llvm::Function & f);
        void analyze_main(Parameters &, std::vector<std::string> &);
        bool is_analyzable(llvm::Function * f);
        void analyze(llvm::Function * f, const Parameters &);
        llvm::Optional<CallSite> analyze_call(llvm::Value *, bool has_globals, const FunctionParameters &);

        void export_functions();

        template<typename Inst>
        const llvm::DebugLoc * get_call_loc(llvm::CallBase<Inst> * call);
        const llvm::DebugLoc * get_call_loc(llvm::Value * call);
    private:
        template<typename T>
        llvm::Optional<CallSite> analyze_call(llvm::CallBase<T> * call, bool has_globals, const FunctionParameters & params);
    };

}


#endif
