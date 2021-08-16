#ifndef __DEBUG_INFO_HPP__
#define __DEBUG_INFO_HPP__  

#include <perf-taint/util/util.hpp>

#include <llvm/ADT/Optional.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/IR/Module.h>

namespace perf_taint {

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
      // Not all functions have a debug information
      if(subprogram)
        return subprogram->getName();
      else
        return f.getName();
    }
      
    llvm::Optional<std::tuple<std::string, int>>
        getFunctionLocation(llvm::Function & f)
    {
      typedef llvm::Optional<std::tuple<std::string, int>> opt_t;
      const llvm::DISubprogram* subprogram = f.getSubprogram();
      // Not all functions have a debug information
      if(subprogram)
        return opt_t(std::make_tuple(
                    path_join(subprogram->getDirectory(), subprogram->getFilename()),
                    subprogram->getLine()
                ));
      else
        return opt_t();
    }

    template<typename F>
    void getTranslationUnits(llvm::Module & m, F && f)
    {
      // extract file information
      auto it = m.debug_compile_units_begin(),
           end = m.debug_compile_units_end();
      for(;it != end; ++it) {
        llvm::DICompileUnit * unit = *it;
        f(unit->getDirectory(), unit->getFilename());
      }
    }
  };

}

#endif
