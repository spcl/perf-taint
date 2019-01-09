#ifndef __EXTRAP_INSTRUMENTER_HPP__
#define __EXTRAP_INSTRUMENTER_HPP__

#include <cstdint>

extern "C"{
    void __dfsw_EXTRAP_STORE_LABEL(int8_t *, int32_t, int32_t, const char*);
    int32_t __dfsw_EXTRAP_VAR_ID();
}

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var
template<typename T>
void register_variable(T * ptr, const char * name)
{
    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
    __dfsw_EXTRAP_STORE_LABEL(reinterpret_cast<int8_t*>(ptr), sizeof(T),
            param_id++, name);
}

#endif
