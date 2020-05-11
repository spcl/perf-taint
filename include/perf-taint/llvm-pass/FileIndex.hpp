
#ifndef __PERF_TAINT_FILE_INDEX_HPP__
#define __PERF_TAINT_FILE_INDEX_HPP__

#include <perf-taint/llvm-pass/ParameterFinder.hpp>

#include <llvm/ADT/StringRef.h>
#include <llvm/IR/Module.h>

#include <map>

namespace perf_taint {

  struct DebugInfo;

  struct FileIndex
  {
    typedef std::map<llvm::StringRef,std::tuple<int, llvm::StringRef>> idx_t;
    typedef typename idx_t::iterator iterator;
    // file_name -> (idx, dir)
    idx_t index;

    void import(llvm::Module &, DebugInfo &);
    int getIdx(llvm::StringRef &);
    iterator begin();
    iterator end();
  };

}

#endif

