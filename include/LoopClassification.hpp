//
// Created by mcopik on 5/4/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP
#define LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP

#include "results/LoopInformation.hpp"

class LoopClassification
{
    Loop * loop;
public:
    LoopClassification(Loop * l):
        loop(l)
    {}

    LoopInformation classify();
};

#endif //LOOP_EXTRACTOR_CPP_LOOPCLASSIFICATION_HPP
