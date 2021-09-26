

#ifndef __PERF_TAINT_PASS_HPP__
#define __PERF_TAINT_PASS_HPP__

#include <llvm/ADT/Optional.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/Pass.h>

#include <fstream>
#include <unordered_set>
#include <unordered_map>


namespace perf_taint {

  struct PerfTaintPass : public llvm::ModulePass
  {
    static char ID;

    PerfTaintPass();

    llvm::StringRef getPassName() const override;
    bool runOnModule(llvm::Module & f) override;
  };

}

#endif

