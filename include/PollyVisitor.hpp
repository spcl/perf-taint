#ifndef __POLLY_VISITOR_HPP__
#define __POLLY_VISITOR_HPP__

#include <isl/isl-noexceptions.h>

namespace polly {
    class PolySCEV;
}

namespace extrap {

    class DependencyFinder;

    struct PollyVisitor
    {
        DependencyFinder & dep;
        polly::PolySCEV & SCEV;

        void call(isl::set set);
        static bool is_computable(isl::set set);
    };

}

#endif
