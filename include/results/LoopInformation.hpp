//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
#define LOOP_EXTRACTOR_CPP_LOOPINFO_HPP


#include "llvm/IR/Instructions.h"

#include <results/LoopIV.hpp>

#include <vector>
#include <string>

namespace llvm {
    class SCEV;
    class Instruction;
    class Loop;
};

using namespace llvm;

namespace results {

    struct LoopInformation
    {

        LoopInformation()
        {
            std::memset(countUpdates, 0, sizeof(int)* *loopprofiler::UpdateType::END_ENUM);
        }

        Loop * loop;
        std::vector<LoopInformation> nestedLoops;
        std::vector< std::tuple<const SCEV *, loopprofiler::UpdateType, Instruction *, bool> > loopExits;
        std::string name;

        // IV not known, IV not found, blocks not recognized
        bool unprocessed;
        long scalarEvolutionComputeTime;

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
        bool isCountableGreg;
        int countCountableGreg;

        // Number of nested and multipath loops.
        int countLoops;
        int countExitBlocks;
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
        int countUpdates[ static_cast<int>(loopprofiler::UpdateType::END_ENUM) ];

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
        int iter_bound = static_cast<int>(loopprofiler::UpdateType::END_ENUM);
        for(; begin != end; ++begin) {
            new_result.countLoops += begin->countLoops;
            new_result.countExitBlocks += begin->countExitBlocks;
            new_result.nestedDepth = std::max(new_result.nestedDepth, begin->nestedDepth);
            new_result.countComputableBySE += begin->countComputableBySE;
            new_result.countCountableBySE += begin->countCountableBySE;
            new_result.countCountableByPolyhedra += begin->countCountableByPolyhedra;
            new_result.countUncountableByPolyhedraMultipath += begin->countUncountableByPolyhedraMultipath;
            new_result.countUncountableByPolyhedraUpdate += begin->countUncountableByPolyhedraUpdate;
            new_result.countCountableGreg += begin->countCountableGreg;
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
        int iter_bound = static_cast<int>(loopprofiler::UpdateType::END_ENUM);
        for(; begin != end; ++begin) {
            new_result.countLoops++;
            new_result.countExitBlocks += begin->loopExits.size();
            new_result.nestedDepth = std::max(new_result.nestedDepth, begin->nestedDepth);
            new_result.countComputableBySE += begin->isComputableBySE;
            new_result.countCountableBySE += begin->isCountableBySE;
            new_result.countCountableByPolyhedra += begin->isCountableByPolyhedra;
            new_result.countUncountableByPolyhedraMultipath += begin->isUncountableByPolyhedraMultipath;
            new_result.countUncountableByPolyhedraUpdate += begin->isUncountableByPolyhedraUpdate;
            new_result.countCountableGreg += begin->isCountableGreg;
            new_result.countMultipath += begin->includesMultipath;
            new_result.countNested += begin->isNested;
            new_result.countMultipleExits += begin->includesMultipleExits;
            //for(int i = 0; i < iter_bound; ++i) {
            //    new_result.countUpdates[i] += begin->countUpdates[i];
            //}
            //if(begin->loopExits.size() > 1)
            //    new_result.countUpdates[ static_cast<int>(results::UpdateType::UNKNOWN) ]++;
            //else
            //    new_result.countUpdates[ static_cast<int>( std::get<1>(begin->loopExits[0]) ) ]++;
            for(const auto & exit : begin->loopExits) {
                new_result.countUpdates[ static_cast<int>( std::get<1>(exit) ) ]++;
            }
        }
        return new_result;
    }

    void LoopInformation::clear()
    {
        unprocessed = false;
        scalarEvolutionComputeTime = 0;
        countExitBlocks = 0;
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
        isCountableGreg = 0;
        countCountableGreg = 0;
        countLoops = 0;
        nestedDepth = 0;
        countMultipath = 0;
        includesMultipath = 0;
        countNested = 0;
        isNested = 0;
        includesMultipleExits = 0;
        countMultipleExits = 0;
        int iter_bound = static_cast<int>(loopprofiler::UpdateType::END_ENUM);
        for(int i = 0; i < iter_bound; ++i) {
            countUpdates[i] = 0;
        }
    }

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
