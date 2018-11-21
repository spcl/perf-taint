#ifndef __PARAMETER_FINDER_HPP__
#define __PARAMETER_FINDER_HPP__

#include <vector>
#include <utility>
#include <string>
#include <unordered_map>

#include <llvm/ADT/SmallSet.h>

namespace llvm {
    class GlobalVariable;
    class Module;
    class Value;
    class Function;
}

namespace extrap {

    class CallSite;

    struct Parameters
    {
        typedef int32_t id_t;
        // TODO: this is not optimal since operator== is slower
        // than just having a SmallVector which we sort and remove duplicates
        // (unique + erase). however, we need comparison only when adding new callsites
        typedef llvm::SmallSet<id_t, 5> vec_t;
        static id_t GLOBAL_THRESHOLD; 
        static bool IS_GLOBAL(id_t);

        static std::vector< const llvm::GlobalVariable * > globals;
        static std::vector< std::string > globals_names;
        static std::vector< std::string > arg_names;

        typedef std::vector<std::string>::const_iterator names_it;
        typedef std::pair<names_it, names_it> names_range;

        static void find_globals(llvm::Module & m, std::vector<std::string> & globals);
        static id_t add_param(std::string name);
        static std::string get_param(id_t id);
        static id_t find_global(const llvm::GlobalVariable *);

        names_range get_parameters() const;
        names_range get_globals() const;
    };
    
    struct FunctionParameters : Parameters
    {
        // the most important part
        // llvm::Value * -> arg_id lookup
        // for main it's anything -> single id
        // for any other function it's an llvm::Argument instance -> ids of params from callsite
        // globals stay the same
        std::unordered_map< const llvm::Value*, vec_t> arguments;

        // create an instance for a new function from the callsite
        FunctionParameters(llvm::Function & f, CallSite &);
        // empty arguments
        FunctionParameters();

        const vec_t * find(const llvm::Value *) const;
        void add(const llvm::Value *, id_t id);
    };

    struct ParameterFinder
    {
        llvm::Module & m;
        llvm::Function & f;

        ParameterFinder(llvm::Module & _m, llvm::Function & _main_function):
            m(_m),
            f(_main_function)
        {}

        FunctionParameters find_args(std::vector<std::string> & names);
    };

}

#endif
