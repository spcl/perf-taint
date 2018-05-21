//
// Created by mcopik on 4/20/18.
//

#ifndef LOOP_EXTRACTOR_CPP_VARIABLE_HPP
#define LOOP_EXTRACTOR_CPP_VARIABLE_HPP

#include <string>

namespace llvm {
    class Value;
}

namespace results {

    struct Value
    {
        virtual ~Value() = 0;
    };

    struct Constant : Value
    {
        //FIXME: can the constant be non-integer?
        int value;
        std::string name;

        template<typename StreamType>
        friend StreamType & operator<<(StreamType & os, const Constant & val);
    };

    struct Variable : Value
    {
        Variable(llvm::Value * val) :
            name(val->getName()),
            sourceInstruction(val) {}
        std::string name;
        // Now only allocation instruction - what letter?
        llvm::Value * sourceInstruction;

        template<typename StreamType>
        friend StreamType & operator<<(StreamType & os, const Variable & val);
    };
}

#endif //LOOP_EXTRACTOR_CPP_VARIABLE_HPP
