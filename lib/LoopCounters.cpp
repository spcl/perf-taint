//
// Created by mcopik on 5/3/18.
//

#include "LoopCounters.hpp"

#include "llvm/Analysis/LoopInfo.h"

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

void LoopCounters::enterNested(Loop * l, int multipathID)
{
    nestedLevels.push_back(std::to_string(multipathID));
    std::string current_level = std::accumulate(nestedLevels.begin(), nestedLevels.end(), std::string(),
                                                [](const std::string & val1, const std::string & val2) -> std::string {
                                                    return val1 + val2;
                                                });
    loops.emplace_back(l, current_level, nullptr);
}

void LoopCounters::leaveNested()
{
    nestedLevels.pop_back();
}

void LoopCounters::clear()
{
    loops.clear();
}

void LoopCounters::addIV(const Loop * l, const SCEV * scev)
{
    assert(l);
    auto it = std::find_if(loops.begin(), loops.end(),
                           [l, scev](std::tuple<Loop *, std::string, const SCEV *> & obj) {
                                if(l == std::get<0>(obj)) {
                                    std::get<2>(obj) = scev;
                                    dbgs() << "Insert: " << scev << " " << std::get<1>(obj) << "\n";
                                    return true;
                                }
                                return false;
                           }
    );
    assert(it != loops.end());
}

std::tuple<std::string, const SCEV *> LoopCounters::getIV(const Loop * l)
{
    assert(l);
    auto it = std::find_if(loops.begin(), loops.end(),
                           [l](const std::tuple<Loop *, std::string, const SCEV *> & obj) {
                               return l == std::get<0>(obj);
                           }
    );
    if(it != loops.end()) {
        //dbgs() << "Find " << scev << " " << std::get<1>(*it) << "\n";
        return std::make_tuple("x" + std::get<1>(*it), std::get<2>(*it));
    } else {
        return std::make_tuple("", nullptr);
    }
}