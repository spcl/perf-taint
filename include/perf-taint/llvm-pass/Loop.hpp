
#ifndef __PERF_TAINT_LOOP_HPP__
#define __PERF_TAINT_LOOP_HPP__

#include <string>
#include <vector>

namespace llvm {
  class Loop;
  class Function;
  class SCEV;
  class ScalarEvolution;
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
    const llvm::Loop& _loop;
    const llvm::SCEV* backedge_count;
    LoopState loop_state;
    // we can't use SmallVector because of recursive definition
    // (SmallVector needs a complete type)
    std::vector<Loop> subloops;
    // subloops statistics
    size_t subloops_count; 
    size_t scev_analyzed_constant;
    size_t scev_analyzed_nonconstant;
    // debug information
    std::string file_name, function_name;
    size_t line;

    void analyze(LoopStructure &, int) const;
  public:
    Loop(llvm::Function &, llvm::Loop *l);

    LoopStructure analyze() const;
    void analyzeSCEV(llvm::ScalarEvolution & scev);

    size_t loops_count() const;
    bool is_constant() const;
    int scev_constant() const;
    int scev_nonconstant() const;
    const llvm::Loop & loop() const;
  };


}

#endif

