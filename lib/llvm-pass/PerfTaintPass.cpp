
#include <perf-taint/llvm-pass/PerfTaintInstrument.hpp>
#include <perf-taint/llvm-pass/PerfTaintPass.hpp>

#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/Module.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/IPO.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

static llvm::cl::opt<bool> RemoveDuplicates("perf-taint-remove-duplicates",
                                       llvm::cl::desc("Attempts to merge identical functions."),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("boolean flag"));

namespace perf_taint {

  PerfTaintPass::PerfTaintPass():
    ModulePass(ID)
  {}

  llvm::StringRef PerfTaintPass::getPassName() const
  {
    return "PerfTaintPass";
  }

  bool PerfTaintPass::runOnModule(llvm::Module &m)
  {
    llvm::legacy::PassManager PM;
    // correlated-propagation
    PM.add(llvm::createInstructionNamerPass());
    //PM.add(llvm::createMetaRenamerPass());
    PM.add(llvm::createCorrelatedValuePropagationPass());
    // mem2reg pass
    PM.add(llvm::createPromoteMemoryToRegisterPass());
    // loop-simplify
    PM.add(llvm::createLoopSimplifyPass());
    if(RemoveDuplicates)
      PM.add(llvm::createMergeFunctionsPass());

    PM.add(createPerfTaintInstrumentationPass());

    PM.run(m);

    // Module is always modified by dfsan.
    return true;
  }

}

char perf_taint::PerfTaintPass::ID = 0;
static llvm::RegisterPass<perf_taint::PerfTaintPass> register_pass(
  "perf-taint",
  "Apply taint-based loop modeling",
  false /* Only looks at CFG */,
  false /* Analysis Pass */
);

// Allow running dynamically through frontend such as Clang
void addPerfTaint(const llvm::PassManagerBuilder &Builder,
                        llvm::legacy::PassManagerBase &PM) {
  PM.add(perf_taint::createPerfTaintInstrumentationPass());
}

// run after optimizations
llvm::RegisterStandardPasses SOpt(llvm::PassManagerBuilder::EP_OptimizerLast,
                            addPerfTaint);

