
#ifndef LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
#define LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP

#include <io/SCEVAnalyzer.hpp>

#include <llvm/ADT/Optional.h>

#include <string>

class SCEVAnalyzer;

namespace llvm {
  class Value;
  class Constant;
  class Argument;
  class Instruction;
  class ScalarEvolution;
}

using namespace llvm;

class ValueToString
{
  ScalarEvolution & SE;
  SCEVAnalyzer & scevPrinter;
  std::ostream & log;

  llvm::Optional<std::string> toString(const Constant * arg);
  llvm::Optional<std::string> toString(const Argument * arg);
  llvm::Optional<std::string> toString(const BinaryOperator * op);
  llvm::Optional<std::string> toString(const GetElementPtrInst * get);
  llvm::Optional<std::string> toString(const ICmpInst * op, bool exitOnSuccess);
public:
  ValueToString(SCEVAnalyzer & _scevPrinter, std::ostream & os) :
      SE(_scevPrinter.getSE()),
      scevPrinter(_scevPrinter),
      log(os)
  {}

  llvm::Optional<std::string> toString(Instruction * instr, bool exitOnSuccess = false);
  llvm::Optional<std::string> toString(Value * val);
};

#endif //LOOP_EXTRACTOR_CPP_VALUETOSTRING_HPP
