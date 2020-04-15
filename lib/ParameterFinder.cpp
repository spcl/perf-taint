#include "AnnotationAnalyzer.hpp"
#include "DebugInfo.hpp"
#include "ParameterFinder.hpp"
// callsite
#include "static-extractor/FunctionAnalysis.hpp"

#include <tuple>

#include <llvm/ADT/Optional.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/DerivedTypes.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Operator.h>
#include <llvm/Support/Casting.h>
#include <llvm/Support/raw_ostream.h>


namespace llvm {
    template<typename OS, typename T, unsigned int N>
    OS & operator<<(OS & os, const llvm::SmallSet<T, N> & obj)
    {
        for(auto it = obj.begin(); it != obj.end(); ++it)
            os << *it << ' ';
        return os;
    }
    
    Type * remove_pointer(Type * type)
    {
        if(type->isPointerTy())
            return remove_pointer(type->getPointerElementType());
        else
            return type;
    }
    
    int get_field_index(const llvm::GEPOperator * inst)
    {
        auto it = inst->idx_begin();
        // second operand - struct idx
        std::advance(it, 1);
        llvm::ConstantInt * c = llvm::dyn_cast<llvm::ConstantInt>( (*it) );
        return c->getZExtValue();
    }
}

namespace extrap {

    std::vector< const llvm::GlobalVariable * > Parameters::globals;
    std::vector< std::string > Parameters::globals_names;
    std::vector< std::string > Parameters::local_names;
    std::vector<Parameters::StructType> Parameters::annotated_structs;
    Parameters::id_t Parameters::GLOBAL_THRESHOLD = 100;
    Parameters::id_t Parameters::INVALID_ID = -1;

    //bool string_compare(const std::string & str)
    //{
    //    //ignore terminator at the endwhitespace
    //    return std::equal(str.begin(), str.end(), "extrap",
    //            [](char a, char b) {
    //                return a == b || !isprint(a); 
    //            });
    //}

    bool Parameters::IS_GLOBAL(id_t id)
    {
        return id >= GLOBAL_THRESHOLD;
    }

    std::string Parameters::get_name(id_t id)
    {
        if(id >= GLOBAL_THRESHOLD)
            return globals_names[id - GLOBAL_THRESHOLD];
        else
            return local_names[id];
    }

    Parameters::names_range Parameters::get_parameters()
    {
        return std::make_pair(local_names.cbegin(), local_names.cend());
    }

    Parameters::names_range Parameters::get_globals()
    {
        return std::make_pair(globals_names.cbegin(), globals_names.cend());
    }

    size_t Parameters::parameters_count()
    {
        return local_names.size() + globals_names.size();
    }

    Parameters::id_t Parameters::find_id(const llvm::GlobalVariable * gvar)
    {
        typedef std::vector<const llvm::GlobalVariable*>::iterator iterator;
        iterator it = std::find(globals.begin(), globals.end(), gvar);
        return it != globals.end() ? std::distance(globals.begin(), it) + GLOBAL_THRESHOLD : INVALID_ID;
    }
    
    Parameters::id_t Parameters::find_id(const llvm::GEPOperator * gep)
    {
        // TODO: do I need it for non gvars?
        // structures are not added as globals, but their fields
        if(const llvm::GlobalVariable * gvar = llvm::dyn_cast<llvm::GlobalVariable>(gep->getPointerOperand())) {
            llvm::Type * type = remove_pointer(gvar->getType());
            if(const llvm::StructType * struct_type = llvm::dyn_cast<llvm::StructType>(type)) {
                // if it is a global variable with annotated struct, we verify if this field is known
                // if this is a load from global struct that we don't know, then it doesn't matter
                if(StructType * type = find_struct(struct_type)) {
                    return type->get_field(get_field_index(gep), true);
                }
            }
        }
        return INVALID_ID;
    }
    
    Parameters::id_t Parameters::add_param(std::string name, bool is_global)
    {
        if(is_global) {
            globals_names.push_back(name);
            return globals_names.size() - 1 + GLOBAL_THRESHOLD;
        } else {
            local_names.push_back(name);
            return local_names.size() - 1;
        }
    }
    
    Parameters::id_t Parameters::process_param(std::string name, const llvm::Value * val)
    {
        // push annotated structure
        //if(const llvm::StructType * struct_val = llvm::dyn_cast<llvm::StructType>(val->getType())) {
        //    //TODO: do we need to store for each struct its instances?
        //    //auto ids = find_struct(struct_val);
        //    //if(ids) {
        //    //    ids->push_back(arg_names.size() - 1);
        //    //} else {
        //    //    svec_t vec;
        //    //    vec.push_back(arg_names.size() - 1);
        //    //    annotated_structs.emplace_back(struct_val);
        //    //}
        //    //find_struct(struct_val);
        //}
        bool is_global = false;
        id_t struct_field_id = process_struct_load(val, is_global);
        return struct_field_id == INVALID_ID ? add_param(name, is_global) : struct_field_id;
    }
    
    Parameters::id_t Parameters::process_param(std::string name, const llvm::GlobalVariable * val)
    {
        bool is_global = true;
        id_t struct_field_id = process_struct_load(val, is_global);
        if(struct_field_id == INVALID_ID) {
            globals.push_back(val);
            return add_param(name, is_global);
        } else
            return struct_field_id;
    }
 
    Parameters::id_t Parameters::process_struct_load(const llvm::Value * val, bool is_global)
    {
        if(const llvm::GEPOperator * inst =
                llvm::dyn_cast<llvm::GEPOperator>(val)) {
            const llvm::Value * operand = inst->getPointerOperand();
            // we should expect a pointer to struct_type coming from an arg or alloca
            if(const llvm::StructType * type =
                    llvm::dyn_cast<llvm::StructType>(operand->getType()->getPointerElementType())) {
                // access always the zero element and the n-th fields where n is integer constant
                assert(inst->hasAllConstantIndices());
                auto it = inst->idx_begin();
                // second operand - struct idx
                std::advance(it, 1); 
                llvm::ConstantInt * c = llvm::dyn_cast<llvm::ConstantInt>( (*it) );
                Parameters::StructType & struct_type = Parameters::insert_struct(type);
                // if struct is global, the loaded field is marked as global
                // if loaded field is global, the struct must be global
                id_t id = found_struct_field(
                            struct_type,
                            c->getValue().getZExtValue(),
                            is_global || llvm::isa<llvm::GlobalVariable>(operand)
                        );
                //located_fields.push_back( std::make_tuple(val, id) );
                return id;
            }
        }
        return INVALID_ID;
    }

    Parameters::StructType * Parameters::find_struct(const llvm::StructType * struct_val)
    {
        typedef typename decltype(annotated_structs)::value_type val_t;
        auto it = std::find_if(annotated_structs.begin(), annotated_structs.end(),
                [struct_val](const val_t & x) {
                    return x.type == struct_val;
                });
        return it == annotated_structs.end() ? nullptr : &*it;
    }
 
    Parameters::StructType & Parameters::insert_struct(const llvm::StructType * struct_val)
    {
        StructType * struct_ptr = find_struct(struct_val);
        if(!struct_ptr) {
            annotated_structs.emplace_back(struct_val);
            return annotated_structs.back();
        } else
            return *struct_ptr;
    }
    
    Parameters::id_t Parameters::found_struct_field(StructType & s, int field, bool is_global)
    {
        //TODO: debug module - struct fields
        assert(field < s.fields.size());
        if(s.get_field(field, is_global) == -1) {
            id_t id = add_param(s.type->getName().str() + "_field_" + std::to_string(field), is_global);
            s.get_field(field, is_global) = id;
            return id;
        } else
            return s.get_field(field, is_global);
    }
    
    FunctionParameters::FunctionParameters(llvm::Function & f, CallSite & callsite)
    {
        // from call pos -> ids
        // to llvm::Value-> ids
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
        locals.emplace_back( std::forward_as_tuple(val, id) );
    }

    const FunctionParameters::vec_t * FunctionParameters::find(const llvm::Value * v) const
    {
        auto it = arguments.find(v);
        return it != arguments.end() ? &(*it).second : nullptr;
    }
    
    FunctionParameters ParameterFinder::find_args()
    {
        //TOOD: this can get messy with phi-nodes and missing declarations
        //maybe we need to check by debug names?
        //for(llvm::BasicBlock & bb : *f) {
        //    for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {        
        //        instr.
        //    }
        //}
        llvm::DISubprogram * prog = f.getSubprogram();
        //for(llvm::DINode * dbg_info : prog->getRetainedNodes()){
        //    if(llvm::DILocalVariable * var = llvm::dyn_cast<llvm::DILocalVariable>(dbg_info)) {
        //        llvm::StringRef name = var->getName();
        //        for(std::string & param_name : names) {
        //            if(param_name == name) {
        //                args.push_back(
        //    }
        //}
        FunctionParameters params;
        AnnotationAnalyzer annotations("extrap");
        DebugInfo info;
        annotations.findAnnotations(f,
            [this, &info, &params](const llvm::Value * value) {
                auto value_name = info.findDebugName(f, value);
                //assert(value_name.hasValue());
                std::string name =
                    value_name.hasValue() ? value_name.getValue() : "";
                Parameters::id_t id = Parameters::process_param(name, value);
                params.add(value, id);
            });
        //for (auto Iter = llvm::inst_begin(f), End = llvm::inst_end(f); Iter != End; ++Iter) {
        //    const llvm::Instruction* I = &*Iter;
        //    //if (const llvm::DbgDeclareInst* DbgDeclare = llvm::dyn_cast<llvm::DbgDeclareInst>(I)) {
        //    //    llvm::StringRef name = DbgDeclare->getVariable()->getName();
        //    //    //llvm::outs() << name << '\n';
        //    //    for(std::string & param_name : names) {
        //    //        if(param_name == name) {
        //    //            Parameters::id_t id = Parameters::add_param(name, DbgDeclare->getAddress());
        //    //            params.add(DbgDeclare->getAddress(), id);
        //    //        }
        //    //    }
        //    //} else if (const llvm::DbgValueInst* DbgValue = llvm::dyn_cast<llvm::DbgValueInst>(I)) {
        //    //    llvm::StringRef name = DbgValue->getVariable()->getName();
        //    //    //llvm::outs() << name << '\n';
        //    //    for(std::string & param_name : names) {
        //    //        if(param_name == name) {
        //    //            Parameters::id_t id = Parameters::add_param(name, DbgValue->getValue());
        //    //            params.add(DbgValue->getValue(), id);
        //    //        }
        //    //    }
        //    //} else
        //    if(const llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(I)) {
        //        if(call->getCalledFunction() &&
        //                call->getCalledFunction()->getName().equals("llvm.var.annotation")) {
        //            if(const llvm::GEPOperator * inst =
        //                    llvm::dyn_cast<llvm::GEPOperator>(call->getOperand(1))) {
        //                const llvm::Value* operand = inst->getPointerOperand();
        //                if(const llvm::GlobalVariable * data
        //                        = llvm::dyn_cast<llvm::GlobalVariable>(inst->getPointerOperand())) {
        //                    if(const llvm::ConstantDataArray * initializer
        //                        = llvm::dyn_cast<llvm::ConstantDataArray>(data->getInitializer())) {
        //                        std::string str = initializer->getAsString().str();
        //                        if(string_compare(str)) {
        //                            //now read the value
        //                            const llvm::Value * value = call->getOperand(0)->stripPointerCasts();
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //    }
        //    
        //}
        return params;
    }
    //void ParameterFinder::analyze_load(const llvm::LoadInst * load, const llvm::Value * found_val)
    //{
    //    // annotated structure - find if the variable inside is annotated
    //    llvm::Type * type = remove_pointer(found_val->getType());
    //    if(const llvm::StructType * struct_val = llvm::dyn_cast<llvm::StructType>(type)) {
    //        llvm::outs() << *load << '\n';
    //        // find out 
    //    }
    //}
}
