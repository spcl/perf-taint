#ifndef __SCALAR_EVOLUTION_VISITOR_HPP__
#define __SCALAR_EVOLUTION_VISITOR_HPP__

namespace llvm {
    class SCEV;
    class SCEVNAryExpr;
    class SCEVUDivExpr;
}

namespace extrap {

    class DependencyFinder;

    struct ScalarEvolutionVisitor
    {
        DependencyFinder & dep;

        void call(const llvm::SCEVNAryExpr * scev);
        void call(const llvm::SCEVUDivExpr * scev);
        void call(const llvm::SCEV * scev);

        static bool is_computable(const llvm::SCEV * scev);
    };

}

#endif
