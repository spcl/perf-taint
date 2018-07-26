//
// Created by mcopik on 5/7/18.
//

#ifndef LOOP_EXTRACTOR_CPP_UTIL_HPP
#define LOOP_EXTRACTOR_CPP_UTIL_HPP

#include <string>
#include <cstring>
#include <memory>
#include <type_traits>

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/IR/DebugLoc.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/Support/raw_os_ostream.h>

namespace {

  const char * to_str(std::string && t)
  {
    return t.c_str();
  }

  const char * to_str(const std::string & t)
  {
    return t.c_str();
  }

  // result_of won't work since it requires function to be a type
  template<typename T>
  auto to_str(const llvm::Optional<T> & t) -> decltype( to_str(std::declval<T&>()) )
  {
    return to_str(t.getValue());
  }

  // universal reference here would be always selected, including std::string
  template<typename T>
  T to_str(const T & t)
  {
    return t;
  }

  template<typename T>
  bool has_value(const T & t)
  {
    return true;
  }

  template<typename T>
  bool has_value(const llvm::Optional<T> & t)
  {
    return t.hasValue();
  }

  //FIXME: C++17 fold expressions
  bool all_true()
  {
    return true;
  }

  template<typename Arg, typename... Args>
  bool all_true(const Arg & a, Args &&... args)
  {
   return has_value(a) && all_true(args...);
  }

  // https://stackoverflow.com/questions/38630445/stdis-same-equivalent-for-unspecialised-template-types
  template <template <typename...> class, template<typename...> class>
  struct is_same_template : std::false_type{};

  template <template <typename...> class T>
  struct is_same_template<T,T> : std::true_type{};

  // Is an object of type A
  template <typename T, template<typename...> class B>
  struct is_instance : std::false_type{};

  template <template <typename...> class A, typename... T, template<typename...> class B>
  struct is_instance<A<T...>, B> : is_same_template<A, B> {};

  template<typename Arg, typename... Args>
  struct contains_optional
  {
    static constexpr bool value =
        is_instance<Arg, llvm::Optional>::value &&
        contains_optional<Args...>::value;
  };

  template<typename Arg>
  struct contains_optional<Arg>
  {
    static constexpr bool value = is_instance<Arg, llvm::Optional>::value;
  };
}

// FIXME: single function with C++17
// if(!all_true(args...))
// return llvm::Optional<std::string>();
template<typename ... Args>
auto cppsprintf(const std::string& format, Args ... args)
  -> typename std::enable_if< contains_optional<Args...>::value, llvm::Optional<std::string>>::type
{
  if(!all_true(args...))
    return llvm::Optional<std::string>();
  size_t size = snprintf( nullptr, 0, format.c_str(), to_str(args)...) + 1; // Extra space for '\0'
  std::unique_ptr<char[]> buf( new char[ size ] );
  snprintf( buf.get(), size, format.c_str(), to_str(args)...);
  return std::string(buf.get(), buf.get() + size - 1); // We don't want the '\0' inside
}

template<typename ... Args>
auto cppsprintf(const std::string& format, Args ... args)
-> typename std::enable_if< !contains_optional<Args...>::value, std::string >::type
{
  size_t size = snprintf( nullptr, 0, format.c_str(), to_str(args)...) + 1; // Extra space for '\0'
  std::unique_ptr<char[]> buf( new char[ size ] );
  snprintf( buf.get(), size, format.c_str(), to_str(args)...);
  return std::string(buf.get(), buf.get() + size - 1); // We don't want the '\0' inside
}

template<typename T>
std::string llvm_to_str(T * obj)
{
    std::string output;
    llvm::raw_string_ostream string_os(output);
    string_os << *obj;
    return string_os.str();
}

std::string debug_info(llvm::Loop * l);

#endif //LOOP_EXTRACTOR_CPP_UTIL_HPP
