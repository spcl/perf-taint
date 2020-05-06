#ifndef __PARAMETER_FINDER_HPP__
#define __PARAMETER_FINDER_HPP__

#include <vector>
#include <utility>
#include <string>
#include <unordered_map>

#include <llvm/ADT/SmallSet.h>
#include <llvm/ADT/SmallVector.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/Operator.h>

namespace llvm {
    class GlobalVariable;
    class Module;
    class Value;
    class Function;
    class StructType;
}

namespace extrap {

    struct Parameters
    {
        typedef int32_t id_t;
        // TODO: this is not optimal since operator== is slower
        // than just having a SmallVector which we sort and remove duplicates
        // (unique + erase). however, we need comparison only when adding new callsites
        typedef llvm::SmallSet<id_t, 5> vec_t;
        typedef llvm::SmallVector<id_t, 5> svec_t;
        static id_t GLOBAL_THRESHOLD; 
        static id_t INVALID_ID;
        static bool IS_GLOBAL(id_t);

        struct StructType
        {
            const llvm::StructType * type;
            // field number -> variable id, global variable id
            // -1 if never used
            llvm::SmallVector< std::pair<id_t, id_t>, 10> fields;
            StructType(const llvm::StructType * _type):
                type(_type),
                fields(type->getNumElements(), std::make_pair(INVALID_ID, INVALID_ID))
            {}
            id_t & get_field(int idx, bool is_global)
            {
                return is_global ? fields[idx].second : fields[idx].first;
            }
        };
        // Store annotated structure and the corresponding ID
        static std::vector<StructType> annotated_structs;
        static std::vector<const llvm::GlobalVariable * > globals;
        // Global variables
        static std::vector< std::string > globals_names;
        // Locally defined variables and accessed struct fields
        static std::vector< std::string > local_names;

        typedef std::vector<std::string>::const_iterator names_it;
        typedef std::pair<names_it, names_it> names_range;
        static names_range get_parameters();
        static names_range get_globals();
        static size_t parameters_count();
        static std::string get_name(id_t id);
        static id_t find_id(const llvm::GlobalVariable *);
        static id_t find_id(const llvm::GEPOperator * gep);
        static id_t process_param(std::string name, const llvm::Value *);
        static id_t process_param(std::string name, const llvm::GlobalVariable *);
        
    private:
        static StructType * find_struct(const llvm::StructType *);
        static StructType & insert_struct(const llvm::StructType *);
        // is_global when a field struct is loaded to a global variable
        static id_t process_struct_load(const llvm::Value * val, bool is_global = false);
        static id_t found_struct_field(StructType &, int field, bool is_global = false);
        static id_t add_param(std::string name, bool is_global = false);
    };
    
    struct FunctionParameters : Parameters
    {
        // the most important part
        // llvm::Value * -> arg_id lookup
        // for main it's anything -> single id
        // for any other function it's an llvm::Argument instance -> ids of params from callsite
        // globals stay the same
        std::unordered_map< const llvm::Value*, vec_t> arguments;
        // locally annotated variables
        llvm::SmallVector< std::tuple<const llvm::Value *, Parameters::id_t>, 5> locals;

        // create an instance for a new function from the callsite
        // empty arguments
        FunctionParameters();

        const vec_t * find(const llvm::Value *) const;
        void add(const llvm::Value *, id_t id);
    };

    struct ParameterFinder
    {
        //llvm::Module & m;
        llvm::Function & f;

        ParameterFinder(/*llvm::Module & _m, */llvm::Function & _main_function):
            //m(_m),
            f(_main_function)
        {}

        static void nop(const llvm::Value*, Parameters::id_t) {} 
        FunctionParameters find_args();//const std::function<void(const llvm::Value*, Parameters::id_t)> & op = nop);
        void analyze_load(const llvm::LoadInst * load, const llvm::Value * found_val);
    };

}

#endif
