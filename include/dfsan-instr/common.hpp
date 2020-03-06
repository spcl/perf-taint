
#ifndef COMMON_HPP
#define COMMON_HPP

#include <llvm/Support/Debug.h>

#include <nlohmann/json.hpp>

#define DEBUG_TYPE "perf-taint"
using llvm::dbgs;

namespace perf_taint {

  using json_t = nlohmann::json;

}

#endif

