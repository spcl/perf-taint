#ifndef __EXTRAP_INSTRUMENTER_H__
#define __EXTRAP_INSTRUMENTER_H__

#include <stdint.h>

void __dfsw_EXTRAP_STORE_LABEL(int8_t *, int32_t, int32_t,const char*);
int32_t __dfsw_EXTRAP_VAR_ID();

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var

void register_variable(void * ptr, size_t size, const char * name)
{
    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
    __dfsw_EXTRAP_STORE_LABEL((int8_t*) ptr, size, param_id++, name);
}

#endif
