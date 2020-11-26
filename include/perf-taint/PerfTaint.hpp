
#ifndef __PERF_TAINT_HPP__
#define __PERF_TAINT_HPP__

#include <cstdint>

extern "C"{
  void __dfsw_EXTRAP_WRITE_LABEL(int8_t *, int32_t, const char*);
}

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var

template<typename T>
void register_variable(T * ptr, const char * name)
{
  __dfsw_EXTRAP_WRITE_LABEL(reinterpret_cast<int8_t*>(ptr), sizeof(T), name);
}

#endif
