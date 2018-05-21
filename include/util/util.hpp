//
// Created by mcopik on 5/7/18.
//

#ifndef LOOP_EXTRACTOR_CPP_UTIL_HPP
#define LOOP_EXTRACTOR_CPP_UTIL_HPP

#include <string>
#include <cstring>
#include <memory>

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

#endif //LOOP_EXTRACTOR_CPP_UTIL_HPP
