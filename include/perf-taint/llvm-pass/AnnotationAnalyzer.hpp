#ifndef __ANNOTATION_ANALYZER_HPP__
#define __ANNOTATION_ANALYZER_HPP__

#include <string>

#include <llvm/IR/Constants.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IR/Instructions.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Operator.h>
    
struct AnnotationAnalyzer
{
    std::string annotation;

    AnnotationAnalyzer(std::string _annotation):
        annotation(_annotation)
    {}
    
    bool stringCompare(llvm::StringRef str)
    {
        //ignore terminator at the end(whitespace)
        //necessary since IR always stores it 
        return std::equal(str.begin(), str.end(), annotation.begin(),
                [](char a, char b) {
                    return a == b || !isprint(a); 
                });
    }

    bool isAnnotation(const llvm::CallInst * call)
    {
        const llvm::Function * called_f = call->getCalledFunction();
        if(!called_f)
            return false;
        llvm::StringRef name = called_f->getName();
        return name.equals("llvm.var.annotation")
            || name.startswith("llvm.ptr.annotation");
    }
    
    bool isAnnotation(const llvm::GlobalVariable & global_var)
    {
        return global_var.getName().equals("llvm.global.annotations");
    }

    bool checkAnnotation(const llvm::CallInst * call)
    {
        // The second arg to call should be load from global variable
        // This variables stores the annotation content
        if(const llvm::GEPOperator * inst =
                llvm::dyn_cast<llvm::GEPOperator>(call->getOperand(1))) {
            const llvm::Value* operand = inst->getPointerOperand();
            if(const llvm::GlobalVariable * data
                    = llvm::dyn_cast<llvm::GlobalVariable>(inst->getPointerOperand())) {
                if(const llvm::ConstantDataArray * initializer
                    = llvm::dyn_cast<llvm::ConstantDataArray>(data->getInitializer())) {
                    return stringCompare(initializer->getAsString());
                }
            }
        }
        return false;
    }

    // Common in global variables.
    // Second operator is a GEP which points to annotation content
    bool checkAnnotation(const llvm::ConstantStruct * CS)
    {
        llvm::GlobalVariable *annotation =
            llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(1)->getOperand(0));
        llvm::ConstantDataArray * annotation_val =
            llvm::dyn_cast<llvm::ConstantDataArray>(annotation->getInitializer());
        return stringCompare(annotation_val->getAsString());
    }

    // F type should be a function accepting a single argument: const llvm::Value*
    template<typename F>
    void findAnnotations(const llvm::Function & f, F && op)
    {
        for (auto it = llvm::inst_begin(f), end = llvm::inst_end(f); it != end; ++it) {

            const llvm::Instruction* I = &(*it);
            if(const llvm::CallInst * call = llvm::dyn_cast<llvm::CallInst>(I)) {
                if(isAnnotation(call) && checkAnnotation(call)) {
                    // the value is casted from the original type to int8*
                    // Note that the manual cast removal cannot be replaced with
                    // stripPointerCasts() since it also removes zero GEPs
                    // Such appear when accessing the first field of structure
                    // Thus, we get a value referencing the structure, not the GEP to first field
                    const llvm::Value * value = nullptr;
                    if(const llvm::BitCastInst * cast =
                        llvm::dyn_cast<llvm::BitCastInst>( call->getOperand(0) )){
                        value = cast->getOperand(0);
                    } else if(const llvm::ConstantExpr * constexp =
                            llvm::dyn_cast<llvm::ConstantExpr>(call->getOperand(0))) {
                        value = constexp->getOperand(0);
                    } else
                        assert(false);
                    op(value);
                }
            } 
        }
    }

    // F type should be a function accepting a single argument: const llvm::GlobalVariable*
    template<typename F>
    void findGlobalAnnotations(const llvm::Module & m, F && op)
    {
        for(auto & global_var : m.getGlobalList())
        {
            if(isAnnotation(global_var)) {
                const llvm::ConstantArray *CA =
                    llvm::dyn_cast<llvm::ConstantArray>(global_var.getInitializer());
                for(auto OI = CA->op_begin(); OI != CA->op_end(); ++OI){
                    llvm::ConstantStruct *CS = llvm::dyn_cast<llvm::ConstantStruct>(OI->get());
                    if(checkAnnotation(CS)) {
                        // Remove bitcast to int8* for a call to annotation function
                        llvm::GlobalVariable * var =
                            llvm::dyn_cast<llvm::GlobalVariable>(CS->getOperand(0)->getOperand(0));
                        var = llvm::dyn_cast<llvm::GlobalVariable>(var->stripPointerCasts());
                        op(var);
                    }
                }
            }
        }
    }
};

#endif
