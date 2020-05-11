
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

  struct FunctionCalls
  {
    struct Call
    {
      llvm::CallBase* call;
      int16_t nested_loop_idx;
      uint16_t loop_idx;

      Call(llvm::CallBase * _c, int16_t n_idx, uint16_t l_idx):
        call(_c), nested_loop_idx(n_idx), loop_idx(l_idx)
      {}
    };
    llvm::SmallVector<Call, 5> calls;

    size_t size() const;
  };

  struct Function
  {
    int idx;
    llvm::StringRef name;
    bool overriden;
    llvm::SmallVector<llvm::Value*, 10> callsites;
    // natural loops in the function
    std::vector<Loop> loops;
    std::vector<LoopStructure> loop_structures;
    // # of entries = loop_depths.size()
    //std::vector<int> loops_structures;
    //std::vector<int> loops_sizes;
    // call + index of parameter
    llvm::SmallVector<ImplicitCall, 10> implicit_loops;

    Function(int _idx, llvm::StringRef _name, bool _overriden = false);

    int function_idx();
    void add_callsite(llvm::Value* val);
    size_t callsites_size();
    bool is_overriden();

  };

}

#endif

