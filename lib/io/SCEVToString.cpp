//
// Created by mcopik on 5/3/18.
//

#include "io/SCEVToString.hpp"


std::string SCEVToString::toString(const SCEV * val)
{
    switch(val->getSCEVType())
    {
        case scAddExpr:
            return toString(dyn_cast<SCEVAddExpr>(val));
        case scMulExpr:
            return toString(dyn_cast<SCEVMulExpr>(val));
        case scAddRecExpr:
            return toString(dyn_cast<SCEVAddRecExpr>(val));
        case scAddMulExpr:
            return toString(dyn_cast<SCEVAddMulExpr>(val));
        case scConstant:
            return toString(dyn_cast<SCEVConstant>(val));
        case scTruncate:
            return toString(dyn_cast<SCEVTruncateExpr>(val));
        case scUnknown:
            //SCEVUnknown * val = dyn_cast<SCEVUnknown>(val);
            return "unknown";//toString(val->getValue(), SE);
        default:
            assert(!"Unknown SCEV type!");
    }
}

std::string SCEVToString::toString(const SCEVConstant * val)
{
    return std::to_string(dyn_cast<SCEVConstant>(val)->getAPInt().getSExtValue());
}

std::string SCEVToString::toString(const SCEVTruncateExpr * expr)
{
    //FIXME: do we need that information?
    std::string type;
    raw_string_ostream os(type);
    expr->getType()->print(os);
    return "trunc(" + toString(expr->getOperand()) + ", " + os.str() + ")";
}

std::string SCEVToString::toString(const SCEVAddExpr * expr)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0));
    str += " + ";
    str = toString(expr->getOperand(1));
    return str;
}

std::string SCEVToString::toString(const SCEVMulExpr * expr)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0));
    str += " * ";
    str = toString(expr->getOperand(1));
    return str;
}

std::string SCEVToString::toString(const SCEVAddRecExpr * expr)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0));
    for(int i = 1; i < expr->getNumOperands(); ++i) {
        str += " + ";
        str += toString(expr->getOperand(i));
        std::string variable = counters.getCounterName(expr->getLoop());
        str += " *" + variable + (i > 1 ? "^" + std::to_string(i) : "");
    }
    return str;
}

std::string SCEVToString::toString(const SCEVAddMulExpr * expr)
{
    std::string str;
    // here select var name
    //expr->getLoop();
    str = toString(expr->getOperand(0)) + " + ";
    std::string variable = counters.getCounterName(expr->getLoop());
    str += toString(expr->getOperand(2)) + "*" + variable;
    return str;
}
