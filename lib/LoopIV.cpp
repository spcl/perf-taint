
#include <results/LoopIV.hpp>

namespace loopprofiler {

  LoopIV LoopIVFinder::findIV(llvm::Loop *l, llvm::BasicBlock *exit_block) {

    llvm::Instruction *block_term = exit_block->getTerminator();
    if (!block_term) {
      if (verbose) {
        os << debug_info(l)
           << " unrecognized exit block - no terminator expression: "
           << llvm_to_str(exit_block) << '\n';
      }
      return LoopIV(UpdateType::NOT_FOUND);
    }
    llvm::BranchInst *branch = llvm::dyn_cast<llvm::BranchInst>(block_term);
    if (!branch) {
      if (verbose) {
        os << debug_info(l) << "unrecognized exit block - not BranchInst: "
           << llvm_to_str(block_term) << '\n';
      }
      return LoopIV(UpdateType::NOT_FOUND);
    }
    llvm::Instruction *condition = llvm::dyn_cast<llvm::Instruction>(
      branch->getCondition());
    if (condition) {
      const llvm::SCEV *induction_variable = nullptr;
      if (condition->getNumOperands() == 1) {
        auto x = findSCEV(condition->getOperand(0), l);
        induction_variable = x;
      } else {
        auto x = findSCEV(condition->getOperand(0), l);
        auto y = findSCEV(condition->getOperand(1), l);
        induction_variable = x ? (!y ? x : nullptr) : y;
        //            if(x)
        //                dbgs() << "First: " << *x << "\n";
        //            else
        //                dbgs() << "First: " << 0 << "\n";
        //            if(y)
        //                dbgs() << "First2: " << *y << "\n";
        //            else
        //                dbgs() << "First2: " << 0 << "\n";

        //            if(Instruction * tmp = dyn_cast<Instruction>(condition->getOperand(0))) {
        //                dbgs() << "0 : " << *tmp << " " << tmp->isBinaryOp() <<'\n';
        //                if(tmp->isCast()) {
        //                    dbgs() << *tmp->getOperand(0) << *scev.get(dyn_cast<Instruction>(tmp->getOperand(0))->getOperand(0)) << "\n";
        //                }
        //            }
        //            if(Instruction * tmp = dyn_cast<Instruction>(condition->getOperand(1))) {
        //                dbgs() << "1 : " << *tmp << " " << tmp->isBinaryOp() <<'\n';
        //            }

        //            const SCEV *first_op = scev.get(condition->getOperand(0)),
        //                *second_op = scev.get(condition->getOperand(1));
        //            if (scev.getSE().isLoopInvariant(first_op, loop)) {
        //                induction_variable = second_op;
        //            } else if (scev.getSE().isLoopInvariant(second_op, loop)) {
        //                induction_variable = first_op;
        //            }
        //
        //            // So, according to SE none of operands is loop invariant.
        //            // One case might be a casting SCEV which does not involve
        //            if (isa<SCEVCastExpr>(first_op)) {
        //                induction_variable = second_op;
        //            } else {
        //                induction_variable = first_op;
        //            }
      }

      if (induction_variable) {
        return LoopIV(classify(induction_variable), induction_variable, condition);
      } else {
        if (verbose) {
          os << debug_info(l) << " unrecognized induction variable in: "
             << llvm_to_str(condition)
             << '\n';
        }
        return LoopIV(UpdateType::NOT_FOUND);
      }
    } else {
      if (verbose) {
        os << debug_info(l) << " unrecognized condition: "
           << llvm_to_str(branch->getCondition()) << '\n';
      }
      return LoopIV(UpdateType::NOT_FOUND);
    }

  }

  bool LoopIVFinder::isLoopInvariant(const llvm::SCEV *scev, llvm::Loop *l)
  {
    if (llvm::isa<llvm::SCEVCastExpr>(scev)) {
      return SE.isLoopInvariant(
        llvm::dyn_cast<llvm::SCEVCastExpr>(scev)->getOperand(),
        l
      );
    } else {
      return SE.isLoopInvariant(scev, l);
    }
  }

  bool LoopIVFinder::isUnknown(const llvm::SCEV *scev)
  {
    if (scev->getSCEVType() == llvm::scUnknown ||
        scev->getSCEVType() == llvm::scCouldNotCompute) {
      return true;
    } else if (llvm::isa<llvm::SCEVCastExpr>(scev)) {
      return isUnknown(llvm::dyn_cast<llvm::SCEVCastExpr>(scev)->getOperand());
    }
    return false;
  }

  bool LoopIVFinder::isMultiplication(llvm::BinaryOperator *op)
  {
    return op->getOpcode() == llvm::Instruction::Mul ||
           op->getOpcode() == llvm::Instruction::FMul ||
           op->getOpcode() == llvm::Instruction::Shl;
  }

  bool LoopIVFinder::isAddition(llvm::BinaryOperator *op)
  {
    return op->getOpcode() == llvm::Instruction::Add ||
           op->getOpcode() == llvm::Instruction::FAdd ||
           op->getOpcode() == llvm::Instruction::Or;
  }

  const llvm::SCEV * LoopIVFinder::findSCEV(llvm::Value *val, llvm::Loop *l)
  {
    if (llvm::Instruction *tmp = llvm::dyn_cast<llvm::Instruction>(val)) {

      if (tmp->isBinaryOp()) {
        llvm::BinaryOperator *op = llvm::dyn_cast<llvm::BinaryOperator>(tmp);
        const llvm::SCEV *first_op = findSCEV(op->getOperand(0), l);
        const llvm::SCEV *second_op = findSCEV(op->getOperand(1), l);
        if (isMultiplication(op)) {
          bool first_inv = first_op ? isLoopInvariant(first_op, l) ||
                                      isUnknown(first_op) : true;
          bool second_inv = second_op ? isLoopInvariant(second_op, l) ||
                                        isUnknown(second_op) : true;
          if (first_inv) {
            return second_inv ? nullptr : second_op;
          } else {
            return second_inv ? first_op : nullptr;
          }
        } else if (isAddition(op)) {
          bool first_inv = first_op ? isLoopInvariant(first_op, l) ||
                                      isUnknown(first_op) : true;
          bool second_inv = second_op ? isLoopInvariant(second_op, l) ||
                                        isUnknown(second_op) : true;
          if (first_inv) {
            return second_inv ? nullptr : second_op;
          } else {
            return second_inv ? first_op : nullptr;
          }
        }
      } else if (tmp->isCast()) {
        return findSCEV(tmp->getOperand(0), l);
      } else {
        const llvm::SCEV * var = get(tmp);
        if (var && !isLoopInvariant(var, l)) {
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

  UpdateType LoopIVFinder::classify(const llvm::SCEV *val)
  {
    switch (val->getSCEVType()) {
      case llvm::scAddRecExpr:
        return classify(llvm::dyn_cast<llvm::SCEVAddRecExpr>(val));
      case llvm::scAddMulExpr:
        return classify(llvm::dyn_cast<llvm::SCEVAddMulExpr>(val));
      case llvm::scMulExpr:
        return classify(llvm::dyn_cast<llvm::SCEVMulExpr>(val));
      default:
        break;
    }
    if (verbose) {
      os << "Unrecognized SCEV type: " << val->getSCEVType() << " "
          << llvm_to_str(val) << '\n';
    }
    return UpdateType::UNKNOWN;
  }

  UpdateType LoopIVFinder::classify(const llvm::SCEVAddRecExpr *val)
  {
    // represents a closed-form function of type A + B*x
    // i.e. an update of type x = A; x += B;
    if (val->isAffine()) {
      if (val->getOperand(1)->isOne()) {
        return UpdateType::INCREMENT;
      } else {
        return UpdateType::ADD;
      }
    } else {
      return UpdateType::UNKNOWN;
    }
  }

  UpdateType LoopIVFinder::classify(const llvm::SCEVAddMulExpr *val)
  {
    if (val->representsAffineUpdate())
      return UpdateType::AFFINE;
    else
      return UpdateType::MULTIPLY;
  }

  UpdateType LoopIVFinder::classify(const llvm::SCEVMulExpr *val)
  {
    //look for a multiplication with a constant
    if (val->getOperand(0)->getSCEVType() == llvm::scConstant)
      return classify(val->getOperand(1));
    else if (val->getOperand(1)->getSCEVType() == llvm::scConstant)
      return classify(val->getOperand(0));
    //FIXME: something smarter
    os << "Unrecognized multiplication SCEV: " << llvm_to_str(val) << '\n';
    return UpdateType::UNKNOWN;
  }
}