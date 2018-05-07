//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
#define LOOP_EXTRACTOR_CPP_LOOPINFO_HPP


#include "llvm/IR/Instructions.h"

#include <vector>
#include <string>

namespace llvm {
    class SCEV;
    class Instruction;
};

using namespace llvm;

namespace results {

    enum class UpdateType {
        NOT_FOUND,
        UNKNOWN,
        INCREMENT,
        ADD,
        MULTIPLY,
        AFFINE
    };

    struct LoopInformation
    {
        std::vector<LoopInformation> nestedLoops;
        std::vector< std::tuple<const SCEV *, UpdateType, const Instruction *> > loopExits;
        std::string name;

        bool computableBySE;
        bool countableBySE;
        bool computableByPolyhedra;
        bool isNested;
        int nestedDepth;
        int maxMultipath;

        // Number of nested and multipath loops.
        int countLoops;
        int countLoopsNotNested;
        int countLoopsMultipath;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
