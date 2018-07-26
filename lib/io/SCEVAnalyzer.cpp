//
// Created by mcopik on 5/3/18.
//

#include "io/SCEVAnalyzer.hpp"
#include "io/ValueToString.hpp"
#include "LoopCounters.hpp"
#include "results/LoopInformation.hpp"


llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEV * val, bool printAsUpdate)
{
    switch(val->getSCEVType())
    {
        case scAddExpr:
            return toString(dyn_cast<SCEVAddExpr>(val), printAsUpdate);
        case scMulExpr:
            return toString(dyn_cast<SCEVMulExpr>(val), printAsUpdate);
        case scSignExtend:
            return toString(dyn_cast<SCEVSignExtendExpr>(val), printAsUpdate);
        case scAddRecExpr:
            return toString(dyn_cast<SCEVAddRecExpr>(val), printAsUpdate);
        case scAddMulExpr:
            return toString(dyn_cast<SCEVAddMulExpr>(val), printAsUpdate);
        case scConstant:
            return toString(dyn_cast<SCEVConstant>(val), printAsUpdate);
        case scTruncate:
            return toString(dyn_cast<SCEVTruncateExpr>(val), printAsUpdate);
        case scZeroExtend:
            return toString(dyn_cast<SCEVZeroExtendExpr>(val), printAsUpdate);
        case scUnknown:
            //SCEVUnknown * val = dyn_cast<SCEVUnknown>(val);
            if(valuePrinter) {
                //dbgs() <<
                //dbgs() << dyn_cast<SCEVUnknown>(val)->getValue()-><< " " << *val
                //       << "\n";
                return valuePrinter->toString(
                    dyn_cast<SCEVUnknown>(val)->getValue()).getValue();
            }
            return llvm::Optional<std::string>();//toString(val->getValue(), SE);
        default:
            errs() << "Unknown SCEV type: " << val->getSCEVType() << "\n";
            //FIXME: assert
            return llvm::Optional<std::string>();
            //assert(!"Unknown SCEV type!");
    }
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVConstant * val, bool)
{
    return std::to_string(dyn_cast<SCEVConstant>(val)->getAPInt().getSExtValue());
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVTruncateExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    return cppsprintf("trunc(%s,%s)", toString(expr->getOperand()), os.str());
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVZeroExtendExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    return cppsprintf("zeroExt(%s, %s)", expr->getOperand(), os.str());
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVSignExtendExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    //  +7.dbgs() << *dyn_cast<LoadInst>(dyn_cast<SCEVUnknown>(expr->getOperand())->getValue())->getOperand(0) << "\n";
    //return "signext(" + toString(expr->getOperand()) + ", " + os.str() + ")";
    return toString(expr->getOperand());
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVAddExpr * expr, bool)
{
    return cppsprintf("%s + %s", expr->getOperand(0), expr->getOperand(1));
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVMulExpr * expr, bool)
{
  return cppsprintf("%s * %s", expr->getOperand(0), expr->getOperand(1));
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVAddRecExpr * expr, bool printAsUpdate)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    //TODO: do we need more?
    //dbgs() << "Print: " << *expr << "\n";
    //dbgs() << "Print: " << expr << "\n";
    if(printAsUpdate) {
        std::string variable = counters.getCounterName(expr->getLoop());
        return cppsprintf("%s + %s", variable, toString(expr->getOperand(1)));
    } else {
        auto name = counters.getIV(expr->getLoop());
        //FIXME:
        if(!std::get<1>(name))
            return llvm::Optional<std::string>();
        // TODO: compute difference, if necessary - our  expr might be a variation of original IV
        str = std::get<0>(name);
    }
//    for(int i = 2; i < expr->getNumOperands(); ++i) {
//        str += " + ";
//        str += toString(expr->getOperand(i));
//        str += " *" + variable + (i > 1 ? "^" + std::to_string(i) : "");
//    }

    return str;
}

llvm::Optional<std::string> SCEVAnalyzer::toString(const SCEVAddMulExpr * expr, bool printAsUpdate)
{
    std::string str;
    // here select var name
    //expr->getLoop();
//    str = toString(expr->getOperand(0)) + " + ";
    std::string variable = counters.getCounterName(expr->getLoop());
//    str += toString(expr->getOperand(2)) + "*" + variable;
    return cppsprintf("%s + %s * %s", toString(expr->getOperand(0)), toString(expr->getOperand(2)), variable);
}

void SCEVAnalyzer::silence()
{
  verbose = false;
}

ScalarEvolution & SCEVAnalyzer::getSE()
{
  return SE;
}

bool SCEVAnalyzer::couldBeIV(const llvm::SCEV *scev)
{
    return scev->getSCEVType() == llvm::scAddRecExpr ||
           scev->getSCEVType() == llvm::scAddMulExpr;
}