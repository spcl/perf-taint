
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
