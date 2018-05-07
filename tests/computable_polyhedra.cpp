//
// Created by mcopik on 5/7/18.
//

//
// Created by mcopik on 5/7/18.
//

#include <iostream>
#include <tuple>
#include <utility>
#include <cmath>

#include <util/print_tuple.hpp>

// Simple loops at the same level
//std::tuple<int, int, int>
double simple_loop(int len, int pam)
{
    double sum = 0.0;

    // countable: 1
    // isCountable: 1
    for(int i = 0; i <= len; i++) {
        sum += 2.0;
    }

    // countable: 0
    // isCountable: 0
    for(int i = 0; i <= len; i += 2) {
        sum += 2.0;
    }

    // countable: 1
    // isCountable: 0
    for(int i = 0; i <= len; i += 2) {
        for(int j = i; j < len; j++)
            sum += 2.0;
    }

    // countable: 3
    // isCountable: 1
    for(int i = 0; i <= len; i++) {
        for (int j = i; j < len; j++) {
            for(int k = i; k < len; k++)
                sum++;
        }
    }

    // countable: 1
    // isCountable: 0
    for(int i = 0; i <= len; i++) {
        for (int j = i; j < len; j *= 2) {
            for(int k = i; k < len; k++)
                sum++;
        }
    }

    // countable: 2
    // isCountable: 0
    for(int i = 1; i <= len; i++) {
        for(int j = i; j < len; j++)
            sum += 1.5 * i *j;
        // only this one is computable
        for(int k = i; k < len; k++)
            sum += k*i*0.2;
    }

    return sum;
}