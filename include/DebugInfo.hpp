#ifndef __DEBUG_INFO_HPP__
#define __DEBUG_INFO_HPP__  

#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/IntrinsicInst.h>

struct DebugInfo
{
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

    llvm::StringRef getFunctionName(llvm::MDNode & scope)
    {
        if(const llvm::DISubprogram* subprogram =
                llvm::dyn_cast<llvm::DISubprogram>(&scope)) {
            return subprogram->getName();
        } else if(const llvm::DILexicalBlockBase * lexblock =
                llvm::dyn_cast<llvm::DILexicalBlockBase>(&scope)) {
            return lexblock->getSubprogram()->getName();
        }
        assert(false);
    }

    llvm::StringRef getFunctionName(llvm::Function & f)
    {
        const llvm::DISubprogram* subprogram = f.getSubprogram();
        return subprogram->getName();
        assert(false);
    }
};

#endif
