//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
#define LOOP_EXTRACTOR_CPP_LOOPINFO_HPP


#include "llvm/IR/Instructions.h"

#include <vector>
#include <string>

namespace llvm {
    class Value;
};

using namespace llvm;

namespace results {

    struct LoopInformation
    {
        std::vector<LoopInformation> nestedLoops;
        std::vector<Instruction*> counterUpdate;
        std::pair<CmpInst::Predicate, Value *> counterGuard;
        std::string name;

        // Counter
        Value * counterVariable;
        Value * counterInit;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
