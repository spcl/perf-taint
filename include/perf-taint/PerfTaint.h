#ifndef __PERF_TAINT_H__
#define __PERF_TAINT_H__

// int8_t
#include <stdint.h>
// va_list
#include <stdarg.h>
// size_t
#include <stddef.h>
// bool
#include <stdbool.h>

void __dfsw_EXTRAP_WRITE_LABEL(int8_t *, int32_t, const char*);
void __dfsw_EXTRAP_WRITE_LABELS(const char *, size_t, va_list);
bool __dfsw_perf_taint_has_label(int8_t *, int32_t, const char*);

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var

void register_variable(void * ptr, size_t size, const char * name)
{
#if defined(DEBUG)
  fprintf(stderr, "Register variable %s of size %zu at %p\n", name, size, ptr);
#endif
  __dfsw_EXTRAP_WRITE_LABEL((int8_t*) ptr, size, name);
}

// Provide variadic arg
// But make it work with dfsan
void register_variables(const char * name, size_t count, ...)
{
  va_list args;
  va_start(args, count);
#if defined(DEBUG)
  fprintf(stderr, "Register %zu variables with name %s\n", count, ptr);
#endif
  __dfsw_EXTRAP_WRITE_LABELS(name, count, args);
}

bool perf_taint_has_label(void * ptr, size_t size, const char * label)
{
  return __dfsw_perf_taint_has_label((int8_t*) ptr, size, label);
}

#endif
