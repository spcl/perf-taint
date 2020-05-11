
#include <perf-taint/llvm-pass/DebugInfo.hpp>
#include <perf-taint/llvm-pass/FileIndex.hpp>

namespace perf_taint {

  FileIndex::iterator FileIndex::begin()
  {
    return index.begin();
  }

  FileIndex::iterator FileIndex::end()
  {
    return index.end();
  }

  void FileIndex::import(llvm::Module & m, DebugInfo & info)
  {
    int idx = 0;
    info.getTranslationUnits(m,
      [this, &idx](const llvm::StringRef & dir,
                  const llvm::StringRef & name) {
        index[name] = std::make_tuple(idx++, dir);
      }
    );
  }

  int FileIndex::getIdx(llvm::StringRef & name)
  {
    auto it = index.find(name);
    if(it != index.end())
      return std::get<0>((*it).second);
    else
      return -1;
  }

}

