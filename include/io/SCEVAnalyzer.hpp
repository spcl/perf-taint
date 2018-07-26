//
// Created by mcopik on 5/3/18.
//

#ifndef LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP

#include <string>

#include "results/LoopInformation.hpp"

#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"

using namespace llvm;

class LoopCounters;
class ValueToString;
namespace loopprofiler {
  enum class UpdateType;
}

class SCEVAnalyzer
{
  ScalarEvolution & SE;
  LoopCounters & counters;
  std::ostream & log;
  bool verbose;
  ValueToString * valuePrinter;

  llvm::Optional<std::string> toString(const SCEVConstant * val, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVTruncateExpr * val, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVSignExtendExpr * va, bool printAsUpdatel);
  llvm::Optional<std::string> toString(const SCEVZeroExtendExpr * val, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVAddExpr * expr, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVMulExpr * expr, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVAddRecExpr * expr, bool printAsUpdate);
  llvm::Optional<std::string> toString(const SCEVAddMulExpr * expr, bool printAsUpdate);

public:
  SCEVAnalyzer(ScalarEvolution & _SE, LoopCounters & _counters, std::ostream & os):
    SE(_SE),
    counters(_counters),
    log(os),
    verbose(true),
    valuePrinter(nullptr)
  {}

  void setValuePrinter(ValueToString * printer)
  {
    valuePrinter = printer;
  }

  void silence();
  llvm::Optional<std::string> toString(const SCEV * val, bool printAsUpdate = false);
  const SCEV * get(Value * val);
  ScalarEvolution & getSE();
  bool couldBeIV(const SCEV * scev);
};

#endif //LOOP_EXTRACTOR_CPP_SCEVTOSTRING_HPP
