

#ifndef LOOP_EXTRACTOR_CPP_PRINT_TUPLE_HPP
#define LOOP_EXTRACTOR_CPP_PRINT_TUPLE_HPP

#include <iostream>
#include <type_traits>
#include <tuple>


namespace {

    template<int val>
    using int_const = std::integral_constant<int, val>;

    // One could implement it with universal reference but I don't see an obvious usage case
    // Implementation of operator<< overload would require proper typing to detect when the universal ref is a tuple
    template<typename Tuple>
    std::ostream & print_tuple(std::ostream &out, const Tuple & t, int_const<1>) {
      out << std::get< std::tuple_size<Tuple>::value - 1 >(t);
      return out;
    }

    template<typename Tuple, int Pos>
    std::ostream & print_tuple(std::ostream &out, const Tuple & t, int_const<Pos>) {
      out << std::get< std::tuple_size<Tuple>::value - Pos >(t) << ' ';
      return print_tuple(out, t, int_const<Pos - 1>{});
    }

}

template<typename... Args>
std::ostream & operator<<(std::ostream & out, const std::tuple<Args...> & t)
{
  return print_tuple(out, t, int_const< sizeof...(Args) >{});
}

#endif //LOOP_EXTRACTOR_CPP_PRINT_TUPLE_HPP
