#include <iostream>
#include <tuple>
#include <utility>
#include <cmath>

#include <util/print_tuple.hpp>

// Simple loops at the same level
std::tuple<int, int, int> simple_loop()
{
    int iter_counter = 0;
    double sum = 0.0;
    // Simple loop, constant length, simple update
    for(int i = 0; i < 100; ++i) {
        sum += 1.5 * i;
        ++iter_counter;
    }
    int iter_counter_second = 0;
    // Simple loop, const length, complex update
    for(int i = 0; i < 200; i += 2*i + 1) {
        sum += 1.5 * i;
        ++iter_counter_second;
    }
    int iter_counter_third = 0;
    // Simple loop, decrease
    for(int i = 200; i >= 0; --i) {
        sum += 1.5 * i;
        ++iter_counter_third;
    }
    return std::make_tuple(iter_counter, iter_counter_second, iter_counter_third);
}

// Simple nested loop
std::tuple<int, int, int> simple_nested_loop()
{
    int iter_counter = 0;
    double sum = 0.0;
    // Nested, simple
    for(int i = 0; i < 100; ++i) {
        for(int j = 0; j < 50; ++j) {
            sum = sum + std::pow(sum, 2.0)*0.1;
            ++iter_counter;
        }
    }
    int iter_counter_second = 0;
    // Nested, complex update
    for(int i = 30; i >= 15; --i) {
        for(int j = 0; j < 50; j += 1.5*j + 3) {
            sum = sum + std::pow(sum, 2.0)*0.1;
            ++iter_counter_second;
        }
    }
    int iter_counter_third = 0;
    // Nested triple
    for(int i = 10; i < 100; ++i) {
        for(int j = 0; j < 50; ++j) {
            for(int k = 100; k >= 10; --k) {
                sum = sum + std::pow(sum, 2.0) * 0.1;
                ++iter_counter_third;
            }
        }
    }
    return std::make_tuple(iter_counter, iter_counter_second, iter_counter_third);
}

//Nested multipath loop
std::tuple<int, int, int> nested_multipath_loop()
{
    int iter_nested = 0, iter_nested_second = 0, iter_nested_third = 0;
    double sum = 0.0;
    // Multipath on first and second level
    for(int i = 0; i < 10; ++i) {

        for(int j = 0; j < 50; j = j + 2) {
            sum -= 1.0;
            ++iter_nested;
        }

        for(int j = 0; j < 20; ++j) {

            for(int k = 100; k > 5; k = k / 2) {
                sum = sum + std::pow(sum, 2.0)*0.1;
                ++iter_nested_second;
            }

            for(int k = 1; k < 100; k *= 3) {
                sum += 1.5;
                ++iter_nested_third;
            }
        }
    }

    return std::make_tuple(iter_nested, iter_nested_second, iter_nested_third);
}

int main(int argc, char ** argv)
{
    auto res = simple_loop();
    auto res2 = simple_nested_loop();
    auto res3 = nested_multipath_loop();
    std::cout << "Iteration counters:" << '\n';
    std::cout << "Simple: " << res << '\n';
    std::cout << "Simple, nested: " << res2 << '\n';
    std::cout << "Multipath, nested: " << res3 << '\n';

    return 0;
}