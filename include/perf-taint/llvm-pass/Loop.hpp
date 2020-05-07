
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

  struct Loop {

    const llvm::Loop& loop;
    const llvm::SCEV* backedge_count;
    LoopState loop_state;
    // we can't use SmallVector because of recursive definition
    // (SmallVector needs a complete type)
    std::vector<Loop> subloops;
    // subloops statistics
    size_t subloops_count; 
    size_t scev_analyzed_constant;
    size_t scev_analyzed_nonconstant;
    // loop is constant
    bool _is_constant;
    // debug information
    std::string file_name, function_name;
    size_t line;

    Loop(llvm::Function &, llvm::Loop *l);

    void analyzeSCEV(llvm::ScalarEvolution & scev);

    size_t loops_count() const;
    bool is_constant() const;
  };


}

#endif

