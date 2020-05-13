
#include <perf-taint/llvm-pass/Loop.hpp>

#include <perf-taint/llvm-pass/DebugInfo.hpp>

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpander.h>
#include <llvm/IR/Function.h>

namespace perf_taint {

  Loop::Loop(llvm::Function & f, llvm::Loop *l):
    _loop(*l),
    _backedge_count(nullptr),
    _backedge_count_value(nullptr),
    _loop_state(LoopState::NOT_PROCESSED),
    subloops_count(0),
    scev_analyzed_constant(0),
    scev_analyzed_nonconstant(0)
  {
    std::copy(l->block_begin(), l->block_end(), std::back_inserter(_blocks));
    l->getExitingBlocks(_exit_blocks);
    // Running loop-simplify pass ensures the existence of a preheader
    _preheader = l->getLoopPreheader();
    assert(_preheader);

    for(llvm::Loop * subloop : l->getSubLoops()) {
      _subloops.emplace_back(f, subloop);
      subloops_count += _subloops.back().loops_count();
    }

    DebugInfo dinfo;
    auto debug_loc = dinfo.getFunctionLocation(f);
    assert(debug_loc.hasValue());
    file_name = std::get<0>(debug_loc.getValue());
    function_name = dinfo.getFunctionName(f);
    line = dinfo.getLoopLocation(_loop);
  }

  LoopStructure Loop::analyze() const
  {
    LoopStructure ret;
    ret.structure.push_back(subloops().size());
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
    for(const Loop & subloop : subloops()) {
      loop_structure.structure.push_back(subloop.subloops().size());
    }
    for(const Loop & subloop : subloops()) {
      subloop.analyze(loop_structure, depth + 1);
    }
    loop_structure.loops_count += subloops().size();
    loop_structure.depth = std::max(loop_structure.depth, depth);
  }

  void Loop::analyzeSCEV(llvm::ScalarEvolution & scev)
  {
    if(scev.hasLoopInvariantBackedgeTakenCount(&_loop)) {
      const llvm::SCEV * backedge_count = scev.getBackedgeTakenCount(&_loop);
      // Unknown count? SCEV failed, loop has inefficient instrumentation
      if(llvm::isa<llvm::SCEVCouldNotCompute>(backedge_count)) {
        _loop_state = LoopState::PROCESSED_NONCONSTANT;
      // Non-constant count? SCEV succeeded, loop has improved instrumentation
      } else if(!llvm::isa<llvm::SCEVConstant>(backedge_count)) {
        scev_analyzed_nonconstant = 1;
        _loop_state = LoopState::PROCESSED_NONCONSTANT;
        this->_backedge_count = backedge_count;
      // Constant count? SCEV succeeded, loop is not instrumented
      } else {
        _loop_state = LoopState::PROCESSED_CONSTANT;
        scev_analyzed_constant = 1;
        this->_backedge_count = backedge_count;
      }
    }
    // if any of loops is non-constant, then the entire object is non constant
    for(Loop & subloop : subloops()) {
      subloop.analyzeSCEV(scev);
      scev_analyzed_nonconstant += subloop.scev_analyzed_nonconstant;
      scev_analyzed_constant += subloop.scev_analyzed_constant;
    }
  }

  void Loop::generateSCEV(llvm::SCEVExpander & scev_expander)
  {
    // TODO: disable until LLVM problem is fixed
    //if(_backedge_count) {
    //  llvm::Type * type = _backedge_count->getType();
    //  llvm::Instruction * insert_point = preheader()->getFirstNonPHI();
    //  _backedge_count_value = scev_expander.expandCodeFor(
    //    _backedge_count, type, preheader()->getFirstNonPHIOrDbg()
    //  );
    //}
    for(Loop & subloop : subloops())
      subloop.generateSCEV(scev_expander);
  }

  LoopState Loop::loop_state() const
  {
    return _loop_state;
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

  const std::vector<Loop> & Loop::subloops() const
  {
    return _subloops;
  }

  std::vector<Loop> & Loop::subloops()
  {
    return _subloops;
  }

  const std::vector<llvm::BasicBlock*> & Loop::blocks() const
  {
    return _blocks;
  }

  const llvm::SmallVector<llvm::BasicBlock*, 5> & Loop::exit_blocks() const
  {
    return _exit_blocks;
  }

  llvm::Value* Loop::backedge_count() const
  {
    return _backedge_count_value;
  }

  llvm::BasicBlock* Loop::preheader() const
  {
    return _preheader;
  }
}
