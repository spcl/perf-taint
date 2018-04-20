//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
#define LOOP_EXTRACTOR_CPP_LOOPINFO_HPP

#include <vector>
#include <string>

namespace llvm {
    class Instruction;
    class Value;
};

using namespace llvm;

namespace results {

    struct LoopInformation
    {
        std::vector<LoopInformation> nestedLoops;
        std::vector<Instruction*> counterUpdate;
        std::string name;

        // Counter
        Value * counterVariable;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
