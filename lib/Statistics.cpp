#include "Statistics.hpp"

#include <llvm/IR/Function.h>
#include <llvm/IR/DebugInfoMetadata.h>

namespace extrap {
    
    void Statistics::found_callsite(llvm::Function * f, const llvm::DebugLoc * loc, bool has_callsite)
    {
        auto it = distinct_functions.insert(f);
        functions_count += it.second; 
        auto it_c = distinct_callsites.insert(loc);
        callsites_count += it_c.second; 
    }
}
