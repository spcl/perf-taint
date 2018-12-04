#include <stdio.h>

#include <sanitizer/dfsan_interface.h>

extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;

void __dfsw_EXTRAP_AT_EXIT()
{
    int vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
        for(int j = 0; j < vars_count; ++j) {
            printf("f %d var %d status %d \n", i, j, __EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j]);
        }
    }
}

void __dfsw_EXTRAP_CHECK_LABEL(int8_t * addr, size_t size, int32_t function_idx)
{
    dfsan_label temp = dfsan_read_label(addr, size);
}

void __dfsw_EXTRAP_STORE_LABEL(int8_t * addr, int32_t param_idx)
{
}


