#ifndef __DEBUG_INFO_HPP__
#define __DEBUG_INFO_HPP__  

#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/IntrinsicInst.h>
    
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

#endif
