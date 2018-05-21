//
// Created by mcopik on 4/20/18.
//

#ifndef LOOP_EXTRACTOR_CPP_COMPARISON_HPP
#define LOOP_EXTRACTOR_CPP_COMPARISON_HPP

#include <memory>

namespace results{

    struct Comparison
    {
        llvm::CmpInst sourceInstruction;
        std::shared_ptr<Value> comparisonVariable;
        std::shared_ptr<Value> loopCounter;
    };

}

#endif //LOOP_EXTRACTOR_CPP_COMPARISON_HPP
