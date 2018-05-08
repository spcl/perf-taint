//
// Created by mcopik on 5/3/18.
//

#include "LoopCounters.hpp"

#include <numeric>
#include <algorithm>
#include <cassert>
#include <iostream>

std::string LoopCounters::getCounterName(const Loop * l)
{
    assert(l);
    auto it = std::find_if(loops.begin(), loops.end(),
        [l](const std::tuple<Loop *, std::string, const SCEV *> & obj) {
            return l == std::get<0>(obj);
        }
    );
    if(it != loops.end()) {
        return "x" + std::get<1>(*it);
    } else {
        return "";
    }
}

void LoopCounters::enterNested(int multipathID)
{
    nestedLevels.push_back(std::to_string(multipathID));
}

void LoopCounters::leaveNested()
{
    nestedLevels.pop_back();
}

void LoopCounters::addLoop(Loop * l, const SCEV * val, int depth, int multipathId)
{
    std::string current_level = std::accumulate(nestedLevels.begin(), nestedLevels.end(), std::string(),
        [](const std::string & val1, const std::string & val2) -> std::string {
            return val1 + val2;
        });
    loops.emplace_back(l, current_level, val);
}

void LoopCounters::clear()
{
    loops.clear();
}