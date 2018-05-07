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

    enum class UpdateType : int
    {
        NOT_FOUND,
        UNKNOWN,
        INCREMENT,
        ADD,
        MULTIPLY,
        AFFINE,
        END_ENUM
    };

    inline int operator*(UpdateType val)
    {
        return static_cast<int>(val);
    }

    struct LoopInformation
    {

        LoopInformation()
        {
            std::memset(countUpdates, 0, sizeof(int)* *UpdateType::END_ENUM);
        }

        std::vector<LoopInformation> nestedLoops;
        std::vector< std::tuple<const SCEV *, UpdateType, const Instruction *> > loopExits;
        std::string name;

        // count how many nested loops can be computed with SE
        int countComputableBySE;
        // Each nested loop is computableBySE, requires counting
        bool isComputableBySE;
        // How many lops are: no nested loops and computable.
        int countCountableBySE;
        // Is this loop countable?
        bool isCountableBySE;

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

        // Number of IV update types in each nested loop, including all loop exits.
        int countUpdates[ static_cast<int>(UpdateType::END_ENUM) ];
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
