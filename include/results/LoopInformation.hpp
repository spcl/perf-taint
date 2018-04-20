//
// Created by mcopik on 4/19/18.
//

#ifndef LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
#define LOOP_EXTRACTOR_CPP_LOOPINFO_HPP

#include <vector>

namespace results {

    struct LoopInformation
    {
        std::vector<LoopInformation> nested_loops;
    };

}

#endif //LOOP_EXTRACTOR_CPP_LOOPINFO_HPP
