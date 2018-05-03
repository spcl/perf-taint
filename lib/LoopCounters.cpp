//
// Created by mcopik on 5/3/18.
//

#include "LoopCounters.hpp"

#include <algorithm>
#include <cassert>

void addLoop(Loop *, SCEV *);

std::string LoopCounters::getCounterName(const Loop * l)
{
    assert(l);
    auto it = std::find_if(loops.begin(), loops.end(),
        [l](const std::pair<Loop *, const SCEV *> & obj) {
            return l == obj.first;
        }
    );
    if(it != loops.end()) {
        int pos = std::distance(loops.begin(), it);
        return "x" + std::to_string(pos);
    } else {
        return "";
    }
}

void LoopCounters::addLoop(Loop * l, const SCEV * val)
{
    loops.push_back( std::make_pair(l, val) );
}

void LoopCounters::clear()
{
    loops.clear();
}