
#include <perf-taint/util/util.hpp>

#include <filesystem>

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

// While this function exists in LLVM as llvm::sys::path::append,
// it requires initializing a SmallVector, filling the data, and properly
// null-terminating the string, before we can return a std::string to the user.
std::string path_join(const llvm::StringRef & prefix, const llvm::StringRef & suffix)
{
  return std::filesystem::path{prefix} / suffix.data();
}

std::string path_relative(const llvm::StringRef & path, const llvm::StringRef & prefix)
{
  return std::filesystem::relative(path.data(), prefix.data());
}

