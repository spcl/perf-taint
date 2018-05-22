//
// Created by mcopik on 5/3/18.
//

#include "io/SCEVAnalyzer.hpp"
#include "io/ValueToString.hpp"
#include "LoopCounters.hpp"
#include "results/LoopInformation.hpp"

results::UpdateType SCEVAnalyzer::classify(const SCEV * val)
{
    switch(val->getSCEVType())
    {
        case scAddRecExpr:
            return classify(dyn_cast<SCEVAddRecExpr>(val));
        case scAddMulExpr:
            return classify(dyn_cast<SCEVAddMulExpr>(val));
        case scMulExpr:
            return classify(dyn_cast<SCEVMulExpr>(val));
        default:
            break;
    }
    if(verbose) {
        std::string output;
        raw_string_ostream string_os(output);
        string_os << *val;
        log << "Unrecognized SCEV type: " << val->getSCEVType() << " "
            << string_os.str() << '\n';
    }
    return results::UpdateType::UNKNOWN;
}

results::UpdateType SCEVAnalyzer::classify(const SCEVAddRecExpr *val)
{
    // represents a closed-form function of type A + B*x
    // i.e. an update of type x = A; x += B;
    if(val->isAffine()) {
        if(val->getOperand(1)->isOne()) {
            return results::UpdateType::INCREMENT;
        } else {
            return results::UpdateType::ADD;
        }
    } else {
        return results::UpdateType::UNKNOWN;
    }
}

results::UpdateType SCEVAnalyzer::classify(const SCEVAddMulExpr *val)
{
//    std::string output;
//    raw_string_ostream string_os(output);
//    string_os << *val;
//    log << "Recognized SCEV type: " << val->getSCEVType() << " " << string_os.str() << '\n';
    if(val->representsAffineUpdate())
        return results::UpdateType::AFFINE;
    else
        return results::UpdateType::MULTIPLY;
}

results::UpdateType SCEVAnalyzer::classify(const SCEVMulExpr *val)
{
    //look for a multiplication with a constant
    if(val->getOperand(0)->getSCEVType() == scConstant)
        return classify(val->getOperand(1));
    else if(val->getOperand(1)->getSCEVType() == scConstant)
        return classify(val->getOperand(0));
    //FIXME: something smarter
    std::string output;
    raw_string_ostream string_os(output);
    string_os << *val;
    log << "Unrecognized multiplication SCEV: " << string_os.str() << '\n';
    return results::UpdateType::UNKNOWN;
}

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
            if(valuePrinter)
                return valuePrinter->toString(dyn_cast<SCEVUnknown>(val)->getValue());
            return "unknown";//toString(val->getValue(), SE);
        default:
            errs() << "Unknown SCEV type: " << val->getSCEVType() << "\n";
            assert(!"Unknown SCEV type!");
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
    //return "signext(" + toString(expr->getOperand()) + ", " + os.str() + ")";
    return toString(expr->getOperand());
}

std::string SCEVAnalyzer::toString(const SCEVAddExpr * expr, bool)
{
    std::string str;
    dbgs() << *expr->getOperand(0) << " " << *expr->getOperand(1) << "\n";
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
        assert(std::get<1>(name));
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

const SCEV * SCEVAnalyzer::get(Value * val)
{
    return SE.getSCEV(val);
}

ScalarEvolution & SCEVAnalyzer::getSE()
{
    return SE;
}

void SCEVAnalyzer::silence()
{
    verbose = false;
}

const SCEV * SCEVAnalyzer::findSCEV(const SCEV * val, Loop * l)
{

}

bool SCEVAnalyzer::isLoopInvariant(const SCEV * scev, Loop * l)
{
    if (isa<SCEVCastExpr>(scev)) {
        //dbgs() << "CastInv " << SE.isLoopInvariant(dyn_cast<SCEVCastExpr>(scev)->getOperand(), l);
        return SE.isLoopInvariant(dyn_cast<SCEVCastExpr>(scev)->getOperand(), l);
    } else {
        //dbgs() << "NonCastInv " << SE.isLoopInvariant(scev, l);
        return SE.isLoopInvariant(scev, l);
    }
}

bool isMultiplication(BinaryOperator * op)
{
    return op->getOpcode() == Instruction::Mul || op->getOpcode() == Instruction::FMul || op->getOpcode() == Instruction::Shl;
}

bool isAddition(BinaryOperator * op)
{
    return op->getOpcode() == Instruction::Add || op->getOpcode() == Instruction::FAdd || op->getOpcode() == Instruction::Or;
}

bool SCEVAnalyzer::isUnknown(const SCEV * scev)
{
    //dbgs() << *scev << " " << isa<SCEVCastExpr>(scev) << "\n";
    if(scev->getSCEVType() == scUnknown || scev->getSCEVType() == scCouldNotCompute) {
        return true;
    } else if(isa<SCEVCastExpr>(scev)) {
        return isUnknown(dyn_cast<SCEVCastExpr>(scev)->getOperand());
    }
    return false;
}

bool SCEVAnalyzer::couldBeIV(const SCEV * scev)
{
    return scev->getSCEVType() == scAddRecExpr || scev->getSCEVType() == scAddMulExpr;
}

const SCEV * SCEVAnalyzer::findSCEV(Value * val, Loop * l)
{
    if(Instruction * tmp = dyn_cast<Instruction>(val)) {
        //dbgs () << "Cast: " << tmp->isCast() << " " << tmp->isBinaryOp() << "\n";
        //dbgs() << *val << "\n";

        if(tmp->isBinaryOp()) {
            BinaryOperator * op = dyn_cast<BinaryOperator>(tmp);
            const SCEV * first_op = findSCEV(op->getOperand(0), l);
            const SCEV * second_op = findSCEV(op->getOperand(1), l);
            if(isMultiplication(op)) {
                bool first_inv = first_op ? isLoopInvariant(first_op, l) || isUnknown(first_op) : true;
                bool second_inv = second_op ? isLoopInvariant(second_op, l) || isUnknown(second_op) : true;
                if(first_inv) {
                    return second_inv ? nullptr : second_op;
                } else {
                    return second_inv ? first_op : nullptr;
                }
            } else if(isAddition(op)) {
                bool first_inv = first_op ? isLoopInvariant(first_op, l) || isUnknown(first_op) : true;
                bool second_inv = second_op ? isLoopInvariant(second_op, l) || isUnknown(second_op) : true;
//                dbgs() << "First_inv: " << first_inv << " ";
//                if(first_op)
//                    dbgs() << *first_op;
//                else
//                    dbgs() << 0;
//                dbgs() << "\n" << " Second_inv: " << second_inv << " ";
//                if(second_op)
//                    dbgs() << *second_op;
//                else
//                    dbgs() << 0;
//                dbgs() << "\n";
                if(first_inv) {
                    return second_inv ? nullptr : second_op;
                } else {
                    return second_inv ? first_op : nullptr;
                }
            }
            //dbgs() << "Binar Op " << isAddition(op) << " " << isMultiplication(op) << " " << op->getOpcode() << " " << op->getNumOperands() << "\n";
        } else if(tmp->isCast()) {
            return findSCEV( tmp->getOperand(0), l);
        } else {
            const SCEV * var = get(tmp);
            if(var && !isLoopInvariant(var, l)) {
                //dbgs() << "Found: " << *var << '\n';
                return var;
            }
        }
    }
    return nullptr;
//    const SCEV * scev = dyn_cast<SCEV>(val);
//    if(!scev)
//        scev = get(val);
//    if(!scev)
//        return nullptr;
//    if(SE.isLoopInvariant(scev, l))
//        return nullptr;
//    if (isa<SCEVCastExpr>(scev)) {
//        return findSCEV(dyn_cast<SCEVCastExpr>(scev)->getOperand(), l);
//    }



//    if(Instruction * tmp = dyn_cast<Instruction>(condition->getOperand(0))) {
//        dbgs() << "0 : " << *tmp << " " << tmp->isBinaryOp() <<'\n';
//        if(tmp->isCast()) {
//            dbgs() << *tmp->getOperand(0) << *scev.get(dyn_cast<Instruction>(tmp->getOperand(0))->getOperand(0)) << "\n";
//        }
//    }
//    if(Instruction * tmp = dyn_cast<Instruction>(condition->getOperand(1))) {
//        dbgs() << "1 : " << *tmp << " " << tmp->isBinaryOp() <<'\n';
//    }
//
//    const SCEV *first_op = scev.get(condition->getOperand(0)),
//        *second_op = scev.get(condition->getOperand(1));
//    if (scev.getSE().isLoopInvariant(first_op, loop)) {
//        induction_variable = second_op;
//    } else if (scev.getSE().isLoopInvariant(second_op, loop)) {
//        induction_variable = first_op;
//    }
//
//    // So, according to SE none of operands is loop invariant.
//    // One case might be a casting SCEV which does not involve
//    if (isa<SCEVCastExpr>(first_op)) {
//        induction_variable = second_op;
//    } else {
//        induction_variable = first_op;
//    }
}