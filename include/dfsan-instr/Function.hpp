
#ifndef DFSAN_INSTR_FUNCTION_HPP
#define DFSAN_INSTR_FUNCTION_HPP

#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Value.h>

#include <string>
#include <vector>

namespace perf_taint {

  struct Function
  {
    int idx;
    llvm::StringRef name;
    bool overriden;
    llvm::SmallVector<llvm::Value*, 10> callsites;
    // # of entries = loop_depths.size()
    std::vector<int> loops_structures;
    std::vector<int> loops_sizes;
    // call + index of parameter
    std::vector<std::tuple<llvm::Instruction*, std::string, int>> implicit_loops;
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

