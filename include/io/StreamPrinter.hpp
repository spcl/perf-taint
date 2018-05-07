//
// Created by mcopik on 4/20/18.
//

#ifndef LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP
#define LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP

#include "results/LoopInformation.hpp"

#include "llvm/IR/Value.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"

struct StreamPrinter
{
    template<typename StreamType>
    static void printValue(StreamType && stream, Value * val)
    {
        if(ConstantInt * cons_int = dyn_cast<ConstantInt>(val)) {
            stream << cons_int->getValue();
        } else if(AllocaInst * allocInst = dyn_cast<AllocaInst>(val)) {
            stream << allocInst->getName();
        }
    }

    template<typename StreamType>
    static void print(StreamType && stream,
                      const results::LoopInformation & loop, int indentLen = 0)
    {
        std::string indent(indentLen, ' ');
        stream << indent << "--------------------\n";
        stream << indent << "Loop: " << loop.name << '\n';
        //stream << indent << "Counter variable: " << loop.counterVariable->getName() << " = ";
        //printValue(stream, loop.counterInit);
        stream << '\n';
        stream << indent << "Counter update: \n";
        int i = 0;
//        for(Instruction * instr : loop.counterUpdate)
//        {
//            stream << indent << i++ << ' ' << *instr << '\n';
//        }
        //stream << indent << "Counter guard: " << CmpInst::getPredicateName(loop.counterGuard.first) << ' ';
        //printValue(stream, loop.counterGuard.second);
        stream << '\n';
        stream << indent << "Nested loops: " << loop.nestedLoops.size() << '\n';
        for(results::LoopInformation nested : loop.nestedLoops)
        {
            print(stream, nested, 4 + indentLen);
        }
        stream << "--------------------\n";
    }
};

#endif //LOOP_EXTRACTOR_CPP_STREAMPRINTER_HPP
