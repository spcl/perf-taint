
#ifndef __FUNCTION_ANALYSIS__
#define __FUNCTION_ANALYSIS__


#include <llvm/ADT/Optional.h>
#include <llvm/ADT/SmallVector.h>

#include <vector>
#include <fstream>
#include <set>
#include <tuple>
#include <unordered_map>


namespace llvm {

    class DebugLoc;
    class Function;
    class Value;
    class Module;
    class CallGraph;
    class GlobalVariable;
}

namespace extrap {

    class JSONExporter;

    struct Parameters
    {
        typedef int32_t id_t;
        typedef llvm::SmallVector<id_t, 5> vec_t;
        static id_t GLOBAL_THRESHOLD; 

        static std::vector< const llvm::GlobalVariable * > globals;
        static std::vector< std::string > globals_names;
        static std::vector< std::string > arg_names;

        static void find_globals(llvm::Module & m, std::vector<std::string> & globals);
        static id_t add_param(std::string name);
        static std::string get_param(id_t id);
        static id_t find_global(const llvm::GlobalVariable *);
    };
   
    struct CallSite;

    struct FunctionParameters : Parameters
    {
        // the most important part
        // llvm::Value * -> arg_id lookup
        // for main it's anything -> single id
        // for any other function it's an llvm::Argument instance -> ids of params from callsite
        // globals stay the same
        std::unordered_map< const llvm::Value*, vec_t> arguments;

        // create an instance for a new function from the callsite
        FunctionParameters(CallSite &);
        // empty arguments
        FunctionParameters();

        const vec_t * find(const llvm::Value *) const;
        void add(llvm::Value *, id_t id);
    };
    
    static FunctionParameters find_args(llvm::Function * f, std::vector<std::string> &);

    struct CallSite
    {
        // mapping position -> involved parameters
        typedef std::tuple<int, FunctionParameters::vec_t> call_arg_t;
        std::vector<call_arg_t> parameters;
        const llvm::DebugLoc * dbg_loc;

        CallSite(const llvm::DebugLoc & _dbg_loc) : dbg_loc(&_dbg_loc) {}

        void called(int pos, const FunctionParameters::vec_t & args);
    };

    struct FunctionAnalysis
    {
        llvm::CallGraph & cg;
        llvm::Module & m;
        extrap::JSONExporter & exporter;
        std::ofstream unknown;
        std::ofstream blacklist;
        std::ofstream whitelist;
        // Functions that are already analyzed
        std::set< llvm::Function* > verified;

        std::unordered_map<llvm::Function *, std::vector<CallSite>> callsites;
        
        FunctionAnalysis(llvm::CallGraph & _cg, llvm::Module & _m, extrap::JSONExporter & exp) :
            cg(_cg),
            m(_m),
            exporter(exp),
            unknown("unknown_functions", std::ios::out),
            blacklist("unknown_functions", std::ios::out),
            whitelist("unknown_functions", std::ios::out)
        {}

        ~FunctionAnalysis()
        {
            unknown.close();
            blacklist.close();
            whitelist.close();
        }

        void analyze_main(Parameters &, std::vector<std::string> &);
        bool is_analyzable(llvm::Function * f);
        void analyze(llvm::Function * f, const Parameters &);
        llvm::Optional<CallSite> analyze_call(llvm::Value *, const FunctionParameters &);

        void export_functions();
    };

}


#endif
