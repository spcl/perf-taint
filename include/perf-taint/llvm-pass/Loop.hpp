
#ifndef __PERF_TAINT_LOOP_HPP__
#define __PERF_TAINT_LOOP_HPP__

#include <llvm/ADT/SmallVector.h>

#include <string>
#include <vector>

namespace llvm {
  class BasicBlock;
  class Loop;
  class Function;
  class SCEV;
  class ScalarEvolution;
  class SCEVExpander;
  class Value;
}

namespace perf_taint {

  enum class LoopState {
    NOT_PROCESSED,
    PROCESSED_CONSTANT,
    PROCESSED_NONCONSTANT
  };

  struct LoopStructure {
    std::vector<int> structure;
    int loops_count;
    int depth;

    LoopStructure(): loops_count(0), depth(0) {}
  };

  struct Loop {
  private:
    // These references are not valid after the first pass over loop.
    // LoopInfo and SCEV pass memory is reallocated
    const llvm::Loop& _loop;
    const llvm::SCEV* _backedge_count;
    // When SCEV is enabled and loop is understood, store the generated
    // SCEV number of loop iterations.
    llvm::Value* _backedge_count_value;
    LoopState _loop_state;
    // we can't use SmallVector because of recursive definition
    // (SmallVector needs a complete type)
    std::vector<Loop> _subloops;
    // subloops statistics
    size_t subloops_count; 
    size_t scev_analyzed_constant;
    size_t scev_analyzed_nonconstant;
    // debug information
    std::string file_name, function_name;
    size_t line;

    // LLVM Loop Information
    // We gather that information from LoopInfo pass in the analysis and
    // use it later in the instrumentation. LoopInfo is going to clear its
    // internal memory between running on different next function.
    // This is easier then running LoopInfo seperately for the instrumentation
    // and trying to figure out which loop from pass corresponds to which one
    // from the previous run.
    std::vector<llvm::BasicBlock *> _blocks;
    llvm::SmallVector<llvm::BasicBlock*, 5> _exit_blocks;
    llvm::BasicBlock * _preheader;

    void analyze(LoopStructure &, int) const;
  public:
    Loop(llvm::Function &, llvm::Loop *l);

    LoopStructure analyze() const;
    void analyzeSCEV(llvm::ScalarEvolution & scev);
    void generateSCEV(llvm::SCEVExpander&);

    size_t loops_count() const;
    bool is_constant() const;
    LoopState loop_state() const;
    int scev_constant() const;
    int scev_nonconstant() const;
    const std::vector<Loop> & subloops() const;
    std::vector<Loop> & subloops();
    const std::vector<llvm::BasicBlock*> & blocks() const;
    const llvm::SmallVector<llvm::BasicBlock*, 5> & exit_blocks() const;
    llvm::Value* backedge_count() const;
    llvm::BasicBlock * preheader() const;
  };

}

#endif

