//
// Created by mcopik on 5/3/18.
//

#include "io/SCEVAnalyzer.hpp"
#include "io/ValueToString.hpp"
#include "LoopCounters.hpp"
#include "results/LoopInformation.hpp"


std::string SCEVAnalyzer::toString(const SCEV * val, bool printAsUpdate)
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
                    dyn_cast<SCEVUnknown>(val)->getValue());
            }
            return "unknown";//toString(val->getValue(), SE);
        default:
            errs() << "Unknown SCEV type: " << val->getSCEVType() << "\n";
            //FIXME:
            return "undef";
            //assert(!"Unknown SCEV type!");
    }
}

std::string SCEVAnalyzer::toString(const SCEVConstant * val, bool)
{
    return std::to_string(dyn_cast<SCEVConstant>(val)->getAPInt().getSExtValue());
}

std::string SCEVAnalyzer::toString(const SCEVTruncateExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    return "trunc(" + toString(expr->getOperand()) + ", " + os.str() + ")";
}

std::string SCEVAnalyzer::toString(const SCEVZeroExtendExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    return "zeroExt(" + toString(expr->getOperand()) + ", " + os.str() + ")";
}

std::string SCEVAnalyzer::toString(const SCEVSignExtendExpr * expr, bool)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    //  +7.dbgs() << *dyn_cast<LoadInst>(dyn_cast<SCEVUnknown>(expr->getOperand())->getValue())->getOperand(0) << "\n";
    //return "signext(" + toString(expr->getOperand()) + ", " + os.str() + ")";
    return toString(expr->getOperand());
}

std::string SCEVAnalyzer::toString(const SCEVAddExpr * expr, bool)
{
    std::string str;
    //dbgs() << *expr->getOperand(0) << " " << *expr->getOperand(1) << "\n";
    str = toString(expr->getOperand(0));
    str += " + ";
    str = toString(expr->getOperand(1));
    return str;
}

std::string SCEVAnalyzer::toString(const SCEVMulExpr * expr, bool)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0));
    str += " * ";
    str = toString(expr->getOperand(1));
    return str;
}

std::string SCEVAnalyzer::toString(const SCEVAddRecExpr * expr, bool printAsUpdate)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    //TODO: do we need more?
    //dbgs() << "Print: " << *expr << "\n";
    //dbgs() << "Print: " << expr << "\n";
    if(printAsUpdate) {
        std::string variable = counters.getCounterName(expr->getLoop());
        str = variable + " + " + toString(expr->getOperand(1));
    } else {
        auto name = counters.getIV(expr->getLoop());
        //FIXME:
        if(!std::get<1>(name))
            return "undef";
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

std::string SCEVAnalyzer::toString(const SCEVAddMulExpr * expr, bool printAsUpdate)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0)) + " + ";
    std::string variable = counters.getCounterName(expr->getLoop());
    str += toString(expr->getOperand(2)) + "*" + variable;
    return str;
}
