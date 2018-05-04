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

    enum class UpdateType {
        NOT_FOUND,
        INCREMENT,
        ADD,
        MULTIPLY,
        AFFINE
    };

    struct LoopInformation
    {
        std::vector<LoopInformation> nestedLoops;
        UpdateType type;
        std::string name;

        // Counter
        Value * counterVariable;
        Value * counterInit;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
