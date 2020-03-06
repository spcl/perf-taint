
#ifndef DFSAN_INSTR_FUNCTION_DATABASE_HPP
#define DFSAN_INSTR_FUNCTION_DATABASE_HPP

#include <dfsan-instr/common.hpp>
#include <dfsan-instr/Function.hpp>

#include <fstream>
#include <string>
#include <unordered_map>
#include <vector>

namespace llvm {

  class GlobalVariable;
  class Function;
  class Value;

}

namespace perf_taint {

  struct FunctionDatabase
  {
    llvm::GlobalVariable * glob_indices;

    struct DataBaseEntry
    {
      json_t loops_data;
    };

    struct ImplicitParameter
    {
      std::string name;
      int param_idx;

      // TODO: 50 shades of c++
      ImplicitParameter(const std::string & _name, int _param_idx):
          name(_name), param_idx(_param_idx) {}
    };

    std::unordered_map<std::string, DataBaseEntry> functions;
    llvm::SmallVector<ImplicitParameter, 5> implicit_parameters;

    void read(std::ifstream &);
    bool contains(llvm::Function * f);
    typedef std::vector< std::vector<int> > vec_t;
    void processLoop(llvm::Function * f, llvm::Value *, Function &, vec_t &);
    size_t parameters_count() const;
    const std::string & parameter_name(size_t idx) const;
  };

}

#endif
