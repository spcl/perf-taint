//
// Created by mcopik on 5/7/18.
//

#ifndef LOOP_EXTRACTOR_CPP_UTIL_HPP
#define LOOP_EXTRACTOR_CPP_UTIL_HPP

#include <string>
#include <cstring>
#include <memory>

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

    // universal reference here would be always selected, including std::string
    template<typename T>
    T to_str(const T & t)
    {
        return t;
    }

}

template<typename ... Args>
std::string cppsprintf(const std::string& format, Args ... args)
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
