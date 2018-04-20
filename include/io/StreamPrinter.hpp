//
// Created by mcopik on 4/20/18.
//

#ifndef LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP
#define LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP

#include "results/LoopInformation.hpp"

#include "llvm/IR/Value.h"

struct StreamPrinter
{
    template<typename StreamType>
    static void print(StreamType && stream, const results::LoopInformation & loop)
    {
        stream << "Loop: " << loop.name << '\n';
        stream << "Counter variable: " << loop.counterVariable->getName() << "\n";
        stream << "Counter update: \n";
        int i = 0;
        for(Instruction * instr : loop.counterUpdate)
        {
            stream << i++ << ' ' << *instr << '\n';
        }
    }
};

#endif //LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP
