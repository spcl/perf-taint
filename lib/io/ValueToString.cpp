
#include "io/ValueToString.hpp"
#include "io/SCEVAnalyzer.hpp"

#include "llvm/IR/Value.h"
#include "llvm/Analysis/ScalarEvolution.h"

std::string ValueToString::toString(const Constant * val)
{
    if(const ConstantInt * integer = dyn_cast<ConstantInt>(val)) {
        return std::to_string(integer->getSExtValue());
    } else {
        assert(!"Unknown type!");
    }
}

std::string ValueToString::toString(const Argument * arg)
{
    const Function * f = arg->getParent();
    if(f->hasName()) {
        return f->getName().str() + "(" + std::to_string(arg->getArgNo()) + ")";
    } else {
        return "unknown_function(" + std::to_string(arg->getArgNo()) + ")";
    }
}

std::string ValueToString::toString(Value * value)
{
    assert(value);
    if(const Constant * val = dyn_cast<Constant>(value)) {
        return toString(val);
    } else if(const Argument * arg = dyn_cast<Argument>(value)) {
        return toString(arg);
    } else if(const SCEV * scev = SE.getSCEV(value)) {
        return scevPrinter.toString(scev);
    } else if(const Instruction * instr = dyn_cast<Instruction>(val)) {
        return toString(instr);
    }
    else {
        if(value->hasName()) {
            return value->getName();
        } else {
            dbgs() << "Unknown name: " << *value << " " << value->getValueID() << "\n";
            // report lack of name
            assert(!"Name unknown!");
        }
    }
}

std::string ValueToString::toString(const Instruction * instr)
{
    const ICmpInst * integer_comparison = dyn_cast<ICmpInst>(instr);
    assert(integer_comparison && "Unknown comparison type!");

    std::string val = toString(integer_comparison->getOperand(0));
    switch(integer_comparison->getPredicate())
    {
        case CmpInst::ICMP_EQ:
            val += " == ";
            break;
        case CmpInst::ICMP_NE:
            val += " != ";
            break;
        case CmpInst::ICMP_UGT:
        case CmpInst::ICMP_SGT:
            val += " < ";
            break;
        case CmpInst::ICMP_UGE:
        case CmpInst::ICMP_SGE:
            val += " <= ";
            break;
        case CmpInst::ICMP_ULT:
        case CmpInst::ICMP_SLT:
            val += " > ";
            break;
        case CmpInst::ICMP_ULE:
        case CmpInst::ICMP_SLE:
            val += " >= ";
            break;
    }
    val += toString(integer_comparison->getOperand(1));
    return val;
}
