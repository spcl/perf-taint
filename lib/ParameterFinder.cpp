#include "ParameterFinder.hpp"
// callsite
#include "FunctionAnalysis.hpp"

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


namespace llvm {
    template<typename OS, typename T, unsigned int N>
    OS & operator<<(OS & os, const llvm::SmallSet<T, N> & obj)
    {
        for(auto it = obj.begin(); it != obj.end(); ++it)
            os << *it << ' ';
        return os;
    }
}

namespace extrap {

    std::vector< const llvm::GlobalVariable * > Parameters::globals;
    std::vector< std::string > Parameters::globals_names;
    std::vector< std::string > Parameters::arg_names;
    std::vector<Parameters::StructType> Parameters::annotated_structs;
    Parameters::id_t Parameters::GLOBAL_THRESHOLD = 100;
    
    llvm::Optional<std::string> findDebugName(const llvm::Function & f, const llvm::Value * value)
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

    bool string_compare(const std::string & str)
    {
        //ignore terminator at the endwhitespace
        return std::equal(str.begin(), str.end(), "extrap",
                [](char a, char b) {
                    return a == b || !isprint(a); 
                });
    }

    bool Parameters::IS_GLOBAL(id_t id)
    {
        return id >= GLOBAL_THRESHOLD;
    }

    std::string Parameters::get_param(id_t id)
    {
        if(id >= GLOBAL_THRESHOLD)
            return globals_names[id - GLOBAL_THRESHOLD];
        else
            return arg_names[id];
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
                llvm::ConstantArray *CA =
                    llvm::dyn_cast<llvm::ConstantArray>(global_var.getInitializer());
                for(auto OI = CA->op_begin(); OI != CA->op_end(); ++OI){
                    llvm::ConstantStruct *CS = llvm::dyn_cast<llvm::ConstantStruct>(OI->get());
                    // second operator is a GEP
                    // find the source of load which is global variable with annotation
                    llvm::GlobalVariable *annotation =
                        llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(1)->getOperand(0));
                    llvm::ConstantDataArray * annotation_val =
                        llvm::dyn_cast<llvm::ConstantDataArray>(annotation->getInitializer());
                    if(string_compare(annotation_val->getAsString())) {
                        llvm::GlobalVariable * var =
                            llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(0)->getOperand(0));
                        var = llvm::dyn_cast<llvm::GlobalVariable>(var->stripPointerCasts());
                        globals.push_back(var);
                        globals_names.push_back(var->getName());
                    }
                }
            }

            // TODO: do I need to compare against dbg info? is global name preserved?
            for(auto it = global_names.begin(); it != global_names.end(); ++it) {
                if(global_var.getName() == (*it)) {
                    globals.push_back(&global_var);
                    globals_names.push_back((*it));
                    global_names.erase(it);
                    break;
                }
            }
        }
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
    
    Parameters::id_t Parameters::add_param(std::string name, bool is_global)
    {
        if(is_global) {
            globals_names.push_back(name);
            //llvm::outs() << "Add global field: " << name << '\n';
            return globals_names.size() - 1 + GLOBAL_THRESHOLD;
        } else {
            arg_names.push_back(name);
            //llvm::outs() << "Add field: " << name << '\n';
            return arg_names.size() - 1;
        }
    }

    Parameters::id_t Parameters::add_param(std::string name, const llvm::Value * val)
    {
        // push annotated structure
        if(const llvm::StructType * struct_val = llvm::dyn_cast<llvm::StructType>(val->getType())) {
            //TODO: do we need to store for each struct its instances?
            //auto ids = find_struct(struct_val);
            //if(ids) {
            //    ids->push_back(arg_names.size() - 1);
            //} else {
            //    svec_t vec;
            //    vec.push_back(arg_names.size() - 1);
            //    annotated_structs.emplace_back(struct_val);
            //}
            find_struct(struct_val);
        }
        if(llvm::isa<llvm::GlobalVariable>(val)) {
            globals_names.push_back(name);
            return globals_names.size() - 1 + GLOBAL_THRESHOLD;
        } else {
            arg_names.push_back(name);
            return arg_names.size() - 1;
        }
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
        typedef typename decltype(annotated_structs)::value_type val_t;
        auto it = std::find_if(annotated_structs.begin(), annotated_structs.end(),
                [struct_val](const val_t & x) {
                    return x.type == struct_val;
                });
        if(it == annotated_structs.end()) {
            annotated_structs.emplace_back(struct_val);
            return annotated_structs.back();
        } else
            return (*it);
    }
    
    Parameters::id_t Parameters::found_struct_field(StructType & s, int field, bool is_global)
    {
        //TODO: debug module - struct fields
        //llvm::outs() << "Add field: " << field << " to global? " << is_global << " id " << s.get_field(field, is_global) << '\n';
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
        // from pos -> ids
        // llvm::Value-> ids
        //llvm::errs() << "Function: " << f.getName() << " arguments: ";
        for(const CallSite::call_arg_t & call : callsite.parameters)
        {
            int position = std::get<0>(call);
            auto it = f.arg_begin();
            std::advance(it, position);
            llvm::errs() << "(" << position << ", " << std::get<1>(call) << ") " << '\n';
            arguments[ &*it ] = std::get<1>(call);
        }
        llvm::errs() << '\n';
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
    
    FunctionParameters ParameterFinder::find_args(std::vector<std::string> & names)
    {
        //TOOD: this can get messy with phi-nodes and missing declarations
        //maybe we need to check by debug names?
        //for(llvm::BasicBlock & bb : *f) {
        //    for(llvm::Instruction & instr : bb.instructionsWithoutDebug()) {        
        //        instr.
        //    }
        //}
        FunctionParameters params;
        llvm::DISubprogram * prog = f.getSubprogram();
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
                        Parameters::id_t id = Parameters::add_param(name, DbgDeclare->getAddress());
                        params.add(DbgDeclare->getAddress(), id);
                    }
                }
            } else if (const llvm::DbgValueInst* DbgValue = llvm::dyn_cast<llvm::DbgValueInst>(I)) {
                llvm::StringRef name = DbgValue->getVariable()->getName();
                //llvm::outs() << name << '\n';
                for(std::string & param_name : names) {
                    if(param_name == name) {
                        Parameters::id_t id = Parameters::add_param(name, DbgValue->getValue());
                        params.add(DbgValue->getValue(), id);
                    }
                }
            } else if(const llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(I)) {
                if(call->getCalledFunction() &&
                        call->getCalledFunction()->getName().equals("llvm.var.annotation")) {
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
                                    Parameters::id_t id = Parameters::add_param(value_name.getValue(), value);
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

    llvm::Type * remove_pointer(llvm::Type * type)
    {
        if(type->isPointerTy())
            return remove_pointer(type->getPointerElementType());
        else
            return type;
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
