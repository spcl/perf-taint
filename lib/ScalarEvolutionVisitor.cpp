
#include "ScalarEvolutionVisitor.hpp"
#include "DependencyFinder.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/ScalarEvolutionExpressions.h>

namespace extrap {

    bool ScalarEvolutionVisitor::call(const llvm::SCEVNAryExpr * scev)
    {
        bool understood = true;
        for(int i = 0; i < scev->getNumOperands(); ++i)
           understood &= call( scev->getOperand(i) ); 
    }
    
    bool ScalarEvolutionVisitor::call(const llvm::SCEVUDivExpr * scev)
    {
        return call(scev->getLHS()) && call(scev->getRHS());
    }

    bool ScalarEvolutionVisitor::call(const llvm::SCEV * scev)
    {
        switch(scev->getSCEVType()) {
            case llvm::scConstant:
                break;
            case llvm::scTruncate:
            case llvm::scZeroExtend:
            case llvm::scSignExtend:
                return call(llvm::cast<llvm::SCEVCastExpr>(scev)->getOperand());
                break;
            case llvm::scAddRecExpr:
            case llvm::scMulExpr:
            case llvm::scAddExpr:
            case llvm::scSMaxExpr:
            case llvm::scUMaxExpr:
                return call(llvm::cast<llvm::SCEVNAryExpr>(scev));
                break;
            case llvm::scUDivExpr:
                return call(llvm::cast<llvm::SCEVUDivExpr>(scev));
                break;
            case llvm::scUnknown:
                //TODO: revert
                //return dep.find(llvm::cast<llvm::SCEVUnknown>(scev)->getValue());
                break;
            default:
                llvm_unreachable( cppsprintf("Unhandled case %d!\n", scev->getSCEVType()).c_str() );
        }
    }
    
    bool ScalarEvolutionVisitor::is_computable(const llvm::SCEV * scev)
    {
        return scev->getSCEVType() != llvm::scCouldNotCompute &&
            scev->getSCEVType() != llvm::scUnknown;
    }

}
