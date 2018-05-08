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
        // How many loops are: no nested loops and computable.
        int countCountableBySE;
        // Is this loop countable?
        bool isCountableBySE;
        // Is this loop countable by polyhedra? Only increments and
        bool isCountableByPolyhedra;
        // How many loops can be count with polyhedra.
        int countCountableByPolyhedra;
        bool isUncountableByPolyhedraMultipath;
        int countUncountableByPolyhedraMultipath;
        int isUncountableByPolyhedraUpdate;
        int countUncountableByPolyhedraUpdate;

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

        inline void clear();

        template<typename Iter>
        static LoopInformation summarize(Iter begin, Iter end);

        template<typename Iter>
        static LoopInformation summarize_nested(Iter begin, Iter end);
    };


    template<typename Iter>
    LoopInformation LoopInformation::summarize_nested(Iter begin, Iter end)
    {
        LoopInformation new_result;
        new_result.clear();
        int iter_bound = static_cast<int>(results::UpdateType::END_ENUM);
        for(; begin != end; ++begin) {
            new_result.countLoops += begin->countLoops;
            new_result.nestedDepth = std::max(new_result.nestedDepth, begin->nestedDepth);
            new_result.countComputableBySE += begin->countComputableBySE;
            new_result.countCountableBySE += begin->countCountableBySE;
            new_result.countCountableByPolyhedra += begin->countCountableByPolyhedra;
            new_result.countUncountableByPolyhedraMultipath += begin->countUncountableByPolyhedraMultipath;
            new_result.countUncountableByPolyhedraUpdate += begin->countUncountableByPolyhedraUpdate;
            new_result.countMultipath += begin->countMultipath;
            new_result.countNested += begin->countNested;
            new_result.countMultipleExits += begin->countMultipleExits;
            for(int i = 0; i < iter_bound; ++i) {
                new_result.countUpdates[i] += begin->countUpdates[i];
            }
        }
        return new_result;
    }

    template<typename Iter>
    LoopInformation LoopInformation::summarize(Iter begin, Iter end)
    {
        LoopInformation new_result;
        new_result.clear();
        int iter_bound = static_cast<int>(results::UpdateType::END_ENUM);
        for(; begin != end; ++begin) {
            new_result.countLoops++;
            new_result.nestedDepth = std::max(new_result.nestedDepth, begin->nestedDepth);
            new_result.countComputableBySE += begin->isComputableBySE;
            new_result.countCountableBySE += begin->isCountableBySE;
            new_result.countCountableByPolyhedra += begin->isCountableByPolyhedra;
            new_result.countUncountableByPolyhedraMultipath += begin->isUncountableByPolyhedraMultipath;
            new_result.countUncountableByPolyhedraUpdate += begin->isUncountableByPolyhedraUpdate;
            new_result.countMultipath += begin->includesMultipath;
            new_result.countNested += begin->isNested;
            new_result.countMultipleExits += begin->includesMultipleExits;
            for(int i = 0; i < iter_bound; ++i) {
                new_result.countUpdates[i] += begin->countUpdates[i];
            }
        }
        return new_result;
    }

    void LoopInformation::clear()
    {
        countComputableBySE = 0;
        isComputableBySE = 0;
        countCountableBySE = 0;
        isCountableBySE = 0;
        countCountableByPolyhedra = 0;
        isCountableByPolyhedra = 0;
        countUncountableByPolyhedraMultipath = 0;
        countUncountableByPolyhedraUpdate = 0;
        isUncountableByPolyhedraMultipath = 0;
        isUncountableByPolyhedraUpdate = 0;
        countLoops = 0;
        nestedDepth = 0;
        countMultipath = 0;
        includesMultipath = 0;
        countNested = 0;
        isNested = 0;
        includesMultipleExits = 0;
        countMultipleExits = 0;
        int iter_bound = static_cast<int>(results::UpdateType::END_ENUM);
        for(int i = 0; i < iter_bound; ++i) {
            countUpdates[i] = 0;
        }
    }

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
