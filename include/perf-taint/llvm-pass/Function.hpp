
#ifndef __PERF_TAINT_FUNCTION_HPP__
#define __PERF_TAINT_FUNCTION_HPP__

#include <perf-taint/llvm-pass/Loop.hpp>

#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Value.h>

#include <string>
#include <vector>
#include <variant>

namespace llvm {
  class CallBase;
}

namespace perf_taint {

  struct ImplicitCall
  {
    llvm::CallBase * call;  
    std::string called_function;
    // value > 0 -> index of implicit parameter
    // value < 0 -> arg_position + 1
    llvm::SmallVector<int, 10> args;

    ImplicitCall(llvm::CallBase * _call, const std::string & _func):
      call(_call), called_function(_func)
      {}
  };

  struct Function
  {
    int idx;
    llvm::StringRef name;
    bool overriden;
    llvm::SmallVector<llvm::Value*, 10> callsites;
    // # of entries = loop_depths.size()
    std::vector<int> loops_structures;
    std::vector<int> loops_sizes;
    // natural loops in the function
    std::vector<Loop> loops;
    // call + index of parameter
    llvm::SmallVector<ImplicitCall, 10> implicit_loops;
    typedef std::vector< std::vector<int> > vec_t;

    Function(int _idx, llvm::StringRef _name, bool _overriden = false):
      idx(_idx),
      name(_name),
      overriden(_overriden)
    {}

    int function_idx()
    {
      return idx;
    }

    void add_callsite(llvm::Value* val)
    {
      callsites.push_back(val);
    }

    size_t callsites_size()
    {
      return callsites.size();
    }

    bool is_overriden()
    {
      return overriden;
    }

    void addImplicitLoop(llvm::Value * call, vec_t & loop) {}
  };

}

#endif

