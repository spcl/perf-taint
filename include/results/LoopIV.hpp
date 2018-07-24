
#ifndef LOOP_EXTRACTOR_CPP_LOOPIV_HPP
#define LOOP_EXTRACTOR_CPP_LOOPIV_HPP

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>

#include <util/util.hpp>

#include <ostream>

namespace loopprofiler {

  enum class UpdateType : int {
    NOT_FOUND,
    UNKNOWN,
    INCREMENT,
    ADD,
    MULTIPLY,
    AFFINE,
    END_ENUM
  };

  inline int operator*(UpdateType val) {
    return static_cast<int>(val);
  }

  struct LoopIV
  {

    UpdateType type;
    const llvm::SCEV * iv;
    uint32_t id;

    LoopIV(UpdateType _type):
      type(_type), iv(nullptr), id(0)
    {}

    LoopIV(UpdateType _type, const llvm::SCEV * _iv):
      type(_type), iv(_iv), id(0)
    {}
  };

  struct LoopIVFinder
  {
    llvm::ScalarEvolution & SE;
    std::ostream & os;
    bool verbose;

    LoopIVFinder(llvm::ScalarEvolution & _SE, std::ostream & _os):
      SE(_SE),
      os(_os),
      verbose(true)
    {}

    LoopIV findIV(llvm::Loop * l, llvm::BasicBlock * exit_block);

  private:

    const llvm::SCEV * get(llvm::Value * val) const
    {
      return SE.isSCEVable(val->getType()) ? SE.getSCEV(val) : nullptr;
    }

    void silence()
    {
      verbose = false;
    }

    bool couldBeIV(const llvm::SCEV *scev);
    bool isMultiplication(llvm::BinaryOperator *op);
    bool isAddition(llvm::BinaryOperator *op);
    bool isUnknown(const llvm::SCEV *scev);
    bool isLoopInvariant(const llvm::SCEV *scev, llvm::Loop *l);

    const llvm::SCEV * findSCEV(llvm::Value *val, llvm::Loop *l);

    UpdateType classify(const llvm::SCEV *val);
    UpdateType classify(const llvm::SCEVAddRecExpr *val);
    UpdateType classify(const llvm::SCEVAddMulExpr *val);
    UpdateType classify(const llvm::SCEVMulExpr *val);

  };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPIV_HPP
