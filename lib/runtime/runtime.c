#include <stdio.h>

#include <sanitizer/dfsan_interface.h>

extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
extern int8_t * __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[];
extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
extern dfsan_label __EXTRAP_LABELS[];

void __dfsw_EXTRAP_AT_EXIT()
{
    int vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
        printf("Function %s depends on: ", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i]);
        for(int j = 0; j < vars_count; ++j) {
            //printf("f %d var %d status %d \n", i, j, __EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j]);
            if(__EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j])
                printf("%d ", j);
        }
        printf("\n");
    }
}

void __dfsw_EXTRAP_CHECK_LABEL(int8_t * addr, size_t size, int32_t function_idx)
{
    dfsan_label temp = dfsan_read_label(addr, size);
    //const struct dfsan_label_info * temp_info = dfsan_get_label_info(temp);
    printf("Check label %d %p %d %d\n", function_idx, addr, size,  temp);
    //printf("Found: %p %s\n", addr, temp_info->desc); 
    //if(temp_info->desc)
    //printf("found: %p %d %d \n", addr, dfsan_has_label_with_desc(temp, "problem_size"), dfsan_has_label_with_desc(temp, "ranks"));
    //temp_info = dfsan_get_label_info(temp_info->l1);
    //if(temp_info->desc)
    //printf("left union found: %p %d %d \n", addr, dfsan_has_label_with_desc(temp, "problem_size"), dfsan_has_label_with_desc(temp, "ranks"));
    //temp_info = dfsan_get_label_info(temp_info->l2);
    //if(temp_info->desc)
    //    printf("right union found: %p %d %d \n", addr, dfsan_has_label_with_desc(temp, "problem_size"), dfsan_has_label_with_desc(temp, "ranks"));
    //if( __EXTRAP_LABELS[0] && __EXTRAP_LABELS[1] && (dfsan_has_label(temp, __EXTRAP_LABELS[0]) || dfsan_has_label(temp, __EXTRAP_LABELS[1])))
    //printf("foundl label: %d %d at %p in %d found %d %d\n", __EXTRAP_LABELS[0] , __EXTRAP_LABELS[1] ,addr, function_idx, dfsan_has_label(temp, __EXTRAP_LABELS[0]), dfsan_has_label(temp, __EXTRAP_LABELS[1]));
    int dependencies = 0;
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i)
        if(__EXTRAP_LABELS[i]) {
            //printf("foundl label: %d at %p in %d found %d\n", __EXTRAP_LABELS[i], addr, function_idx, dfsan_has_label(temp, __EXTRAP_LABELS[i]));
            __EXTRAP_INSTRUMENTATION_RESULTS[function_idx*__EXTRAP_INSTRUMENTATION_PARAMS_COUNT + i] |= dfsan_has_label(temp, __EXTRAP_LABELS[i]);
            dependencies += dfsan_has_label(temp, __EXTRAP_LABELS[i]);
        }
    if(dependencies > 1)
        printf("Multiple dependency %d in function %d\n!", dependencies, function_idx);

    //printf("Found: %p %s\n", addr, temp_info->desc); 
}

void __dfsw_EXTRAP_STORE_LABEL(int8_t * addr, size_t size, int32_t param_idx, const char * name)
{
    dfsan_label lab = dfsan_create_label(name, NULL);
    __EXTRAP_LABELS[param_idx] = lab;
    printf("Create label %d for %d at %d %p %s\n", lab, param_idx, size, addr, name);
    dfsan_set_label(lab, addr, size);
    printf("Set label %d\n", dfsan_read_label(addr, size));
}

