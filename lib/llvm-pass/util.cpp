
#include <perf-taint/util/util.hpp>

std::string debug_info(llvm::Loop * l)
{
  llvm::DebugLoc location = l->getStartLoc();
  if (location) {
    return cppsprintf("File: %s line %d ",
                      location.get()->getFilename().str(),
                      location->getLine());
  }
  return "";
}

std::string path_join(const llvm::StringRef & prefix, const llvm::StringRef & suffix)
{
  llvm::SmallVector<char, 32> path{prefix.begin(), prefix.end()};
  llvm::sys::path::append(path, suffix);
  // Make sure that our string is properly NULL-terminated
  // It might not be when the size of the path is larger than 32 characters
  // Then, the new values won't be zero-initialized
  path.push_back('\0');
  return std::string{path.data()};
}

