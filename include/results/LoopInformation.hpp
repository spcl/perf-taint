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

        // Number of nested and multipath loops.
        int countLoops;
        int nestedDepth;

        // multipath count - # of loops inside which have multiple children
        int countMultipath;
        // only for the main loop - does it have more than one children at *ANY* level?
        bool includesMultipath;
        // # of loops inside which are nested
        int countNested;
        // only for the main loop - does it have any children?
        bool isNested;

        // only for the main loop - does it have any children with multiple exits?
        bool includesMultipleExits;
        // how many loops are there with multiple exits?
        int countMultipleExits;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
