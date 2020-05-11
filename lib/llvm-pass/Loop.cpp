
#include <perf-taint/llvm-pass/Loop.hpp>

#include <perf-taint/llvm-pass/DebugInfo.hpp>

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/Function.h>

namespace perf_taint {

  Loop::Loop(llvm::Function & f, llvm::Loop *l):
    _loop(*l),
    backedge_count(nullptr),
    loop_state(LoopState::NOT_PROCESSED),
    subloops_count(0),
    scev_analyzed_constant(0),
    scev_analyzed_nonconstant(0)
  {
    for(llvm::Loop * subloop : loop().getSubLoops()) {
      subloops.emplace_back(f, subloop);
      subloops_count += subloops.back().loops_count();
    }

    DebugInfo dinfo;
    auto debug_loc = dinfo.getFunctionLocation(f);
    assert(debug_loc.hasValue());
    file_name = std::get<0>(debug_loc.getValue());
    function_name = dinfo.getFunctionName(f);
    line = dinfo.getLoopLocation(loop());
  }

  LoopStructure Loop::analyze() const
  {
    LoopStructure ret;
    ret.structure.push_back(subloops.size());
    ret.loops_count += 1;
    analyze(ret, 1);
    return ret;
  }

  void Loop::analyze(LoopStructure & loop_structure, int depth) const
  {
    // Loop structure data format:
    // a) one integer for each loop storing the number of subloops
    // b) integers are layouted by depth, i.e. all loops of depth 0,
    // all loops of depth 1 etc.
    for(const Loop & subloop : subloops) {
      loop_structure.structure.push_back(subloop.subloops.size());
    }
    for(const Loop & subloop : subloops) {
      subloop.analyze(loop_structure, depth + 1);
    }
    loop_structure.loops_count += subloops.size();
    loop_structure.depth = std::max(loop_structure.depth, depth);
  }

  void Loop::analyzeSCEV(llvm::ScalarEvolution & scev)
  {
    if(scev.hasLoopInvariantBackedgeTakenCount(&loop())) {
      const llvm::SCEV * backedge_count = scev.getBackedgeTakenCount(&loop());
      // Unknown count? SCEV failed, loop has inefficient instrumentation
      if(llvm::isa<llvm::SCEVCouldNotCompute>(backedge_count)) {
        loop_state = LoopState::PROCESSED_NONCONSTANT;
      // Non-constant count? SCEV succeeded, loop has improved instrumentation
      } else if(!llvm::isa<llvm::SCEVConstant>(backedge_count)) {
        scev_analyzed_nonconstant = 1;
        loop_state = LoopState::PROCESSED_NONCONSTANT;
        this->backedge_count = backedge_count;
      // Constant count? SCEV succeeded, loop is not instrumented
      } else {
        loop_state = LoopState::PROCESSED_CONSTANT;
        scev_analyzed_constant = 1;
        this->backedge_count = backedge_count;
      }
    }
    // if any of loops is non-constant, then the entire object is non constant
    for(Loop & subloop : subloops) {
      subloop.analyzeSCEV(scev);
      scev_analyzed_nonconstant += subloop.scev_analyzed_nonconstant;
      scev_analyzed_constant += subloop.scev_analyzed_constant;
    }
  }

  bool Loop::is_constant() const
  {
    return loops_count() == scev_analyzed_constant;
  }

  // Number of subloops + the current loop
  size_t Loop::loops_count() const
  {
    return 1 + subloops_count;
  }

  int Loop::scev_constant() const
  {
    return scev_analyzed_constant;
  }

  int Loop::scev_nonconstant() const
  {
    return scev_analyzed_nonconstant;
  }

  const llvm::Loop & Loop::loop() const
  {
    return _loop;
  }
}
