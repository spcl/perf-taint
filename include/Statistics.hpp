#ifndef __STATISTICS_HPP__
#define __STATISTICS_HPP__

#include <unordered_set>

#include <nlohmann/json_fwd.hpp>

namespace llvm {
    class Function;
    class DebugLoc;
}

namespace extrap {

    struct Statistics {

        std::unordered_set<const llvm::DebugLoc *> distinct_callsites;
        std::unordered_set<const llvm::Function*> distinct_functions;
        int callsites_count;
        int functions_count;

        Statistics():
            callsites_count(0),
            functions_count(0)
        {}

        void found_callsite(llvm::Function * f, const llvm::DebugLoc *, bool has_callsite);
    };

}

#endif
