
#include "ScalarEvolutionVisitor.hpp"
#include "DependencyFinder.hpp"

#include <llvm/Analysis/ScalarEvolutionExpressions.h>

namespace extrap {

    void ScalarEvolutionVisitor::call(const llvm::SCEVNAryExpr * scev)
    {
        for(int i = 0; i < scev->getNumOperands(); ++i)
           call( scev->getOperand(i) ); 
    }
    
    void ScalarEvolutionVisitor::call(const llvm::SCEVUDivExpr * scev)
    {
        call(scev->getLHS());
        call(scev->getRHS());
    }

    void ScalarEvolutionVisitor::call(const llvm::SCEV * scev)
    {
        switch(scev->getSCEVType()) {
            case llvm::scConstant:
                break;
            case llvm::scTruncate:
            case llvm::scZeroExtend:
            case llvm::scSignExtend:
                call(llvm::cast<llvm::SCEVCastExpr>(scev)->getOperand());
                break;
            case llvm::scAddRecExpr:
            case llvm::scMulExpr:
            case llvm::scAddExpr:
            case llvm::scSMaxExpr:
            case llvm::scUMaxExpr:
                call(llvm::cast<llvm::SCEVNAryExpr>(scev));
                break;
            case llvm::scUDivExpr:
                call(llvm::cast<llvm::SCEVUDivExpr>(scev));
                break;
            case llvm::scUnknown:
                dep.find(llvm::cast<llvm::SCEVUnknown>(scev)->getValue());
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
