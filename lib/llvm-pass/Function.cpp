
#include <perf-taint/llvm-pass/Function.hpp>

namespace perf_taint {

  size_t FunctionCalls::size() const
  {
    return calls.size();
  }

  Function::Function(int _idx, llvm::StringRef _name, bool _overriden):
    idx(_idx),
    name(_name),
    overriden(_overriden)
  {}

  int Function::function_idx()
  {
    return idx;
  }

  void Function::add_callsite(llvm::Value* val)
  {
    callsites.push_back(val);
  }

  size_t Function::callsites_size()
  {
    return callsites.size();
  }

  bool Function::is_overriden()
  {
    return overriden;
  }



}
