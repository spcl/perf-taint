#ifndef __EXTRAP_INSTRUMENTER_H__
#define __EXTRAP_INSTRUMENTER_H__

#include <stdint.h>
#include <stdarg.h>

extern const char * __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[];
extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;

void __dfsw_EXTRAP_STORE_LABEL(int8_t *, int32_t, int32_t,const char*);
void __dfsw_EXTRAP_STORE_LABELS(const char * name, int32_t param_idx, size_t, va_list);
int32_t __dfsw_EXTRAP_VAR_ID();

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var

void register_variable(void * ptr, size_t size, const char * name)
{
    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
    fprintf(stderr, "Register variable\n");
    __dfsw_EXTRAP_STORE_LABEL((int8_t*) ptr, size, param_id++, name);
}

//void store_variable(void * ptr, size_t size, const char * name)
//{
//    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i) {
//        if(!strcmp(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i], name)) {
//            fprintf(stderr, "Write variableb %s\n", name);
//            __dfsw_EXTRAP_WRITE_LABEL((int8_t*) ptr, size, i);
//            break;
//        }
//    }
//    fprintf(stderr, "Register variable %s\n", name);
//    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
//    __dfsw_EXTRAP_STORE_LABEL((int8_t*) ptr, size, param_id++, name);
//}

// Provide variadic arg
// But make it work with dfsan
void register_variables(const char * name, size_t count, ...)
{
    va_list args;
    //va_start(args, count);
    //for (int i = 0; i < count; ++i) {
    //    void * addr = va_arg(args, void*);
    //    size_t size = va_arg(args, size_t);
    //    fprintf(stderr, "Register %p of size %d\n", addr, size);
    //}
    va_start(args, count);
    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
    fprintf(stderr, "Register %zu variables\n", count);
    __dfsw_EXTRAP_STORE_LABELS(name, param_id, count, args);
    //va_end(args);
}
//void register_variables(const char * name, size_t count, void * ptr1, size_t size1,
//        void * ptr2, size_t size2, void * ptr3, size_t size3)
//{
//    int32_t param_id = __dfsw_EXTRAP_VAR_ID();
//    __dfsw_EXTRAP_STORE_LABELS(name, param_id, count, ptr1, size1, ptr2, size2, ptr3, size3);
//}

#endif
