#include <iostream>
#include <tuple>

#include <nlohmann/json.hpp>

#include "runtime.h"

typedef nlohmann::json json_t;

json_t * __dfsw_json_get()
{
    static json_t * out = new json_t;
    return out;
}

void __dfsw_json_init_func(int func_idx)
{
    json_t & out = *__dfsw_json_get();
    json_t function;
    function["name"] = __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[func_idx];
    function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx];
    int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx + 1];
    if(file_idx != -1)
        function["file"] = __EXTRAP_INSTRUMENTATION_FILES[file_idx];
    out["functions"].push_back(function);
}

void __dfsw_json_write_callsites(json_t & out, int func_idx)
{
    json_t callsites;

    //int begin = __EXTRAP_CALLSITES_OFFSET[func_idx];
    //int end = __EXTRAP_CALLSITES_OFFSET[func_idx];


    out["callsites"] = callsites;
}

void __dfsw_dump_json_output()
{
    json_t & out = *__dfsw_json_get();
    int vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
    json_t params;
    for(int i = 0; i < vars_count; ++i) {
        // Fix for an old problem where legacy code detected params through
        // annotations and the new code registered params at runtime through
        // a call to store_label. Thus, it is possible that in case
        // of a mismatch we have more storage than we actually use.
        // Ensure that a name was written!
        if(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i])
            params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i] );
    }
    out["parameters"] = params;

    //for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
    //    json_t cf_params;
    //    for(int j = 0; j < vars_count; ++j) {
    //        if(__EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j])
    //            cf_params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[j]);
    //    }
    //    dependencies *deps = __dfsw_EXTRAP_DEPS_FUNC(i);
    //    for(int j = 0; j < deps->len; ++j) {
    //        uint16_t val = deps->deps[j];
    //        json_t multiples;
    //        for(int k = 0; k < 16; ++k)
    //            if(val & (1 << k))
    //                multiples.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[k]);
    //        cf_params.push_back(multiples);
    //    }
    //    if(!cf_params.empty()) {
    //        __dfsw_json_init_func(i);
    //        out["functions"].back()["control_flow_params"] = cf_params; 
    //    }
    //    //else
    //    //   out.erase( out.find("functions") );
    //}
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {

        json_t cf_params;
        int32_t loops_depths_begin = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[i];
        int32_t loops_depths_end = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[i + 1];
        int32_t deps_offset = __EXTRAP_LOOPS_DEPS_OFFSETS[i];
        bool important_function = false;
        //printf("Func: %d Dep %d Dep %d\n", i, loops_depths_begin, loops_depths_end);
        for(int j = loops_depths_begin; j < loops_depths_end; ++j) {

            bool empty = true;
            int loop_depth = __EXTRAP_LOOPS_DEPTHS_PER_FUNC[j];
            std::vector<json_t> params;
            params.push_back("*");
            int filled = 0;
            //printf("Func: %d Dep %d Offset %d\n", i, loop_depth, deps_offset);
            for(int k = 0; k < loop_depth; ++k) {
                dependencies * deps = &__EXTRAP_LOOP_DEPENDENCIES[deps_offset + k];
                json_t deps_json;
                for(int j = 0; j < deps->len; ++j) {
                    json_t dependency;
                    uint16_t val = deps->deps[j];
                    //printf("Func: %d Dep %d Value %d\n", i, loop_depth, val);
                    for(int k = 0; k < 16; ++k)
                        if(val & (1 << k)) {
                            dependency.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[k]);
                        }
                    if(dependency.size() > 1)
                        deps_json.push_back(std::move(dependency));
                    else
                        deps_json.push_back(dependency[0]);
                }
                if(!deps_json.empty()) {
                    filled++;
                    params.push_back( std::move(deps_json) );
                }
            }
            deps_offset += loop_depth;
            if(filled > 1) {
                cf_params.push_back(std::move(params));
                important_function = true;
            } else if(filled) {
                cf_params.push_back(params[1]);
                important_function = true;
            }
        }
        if(important_function) {
            __dfsw_json_init_func(i);
            out["functions"].back()["control_flow_params"] = cf_params;
        }


        //dependencies *deps = __dfsw_EXTRAP_DEPS_FUNC(i);
        //for(int j = 0; j < deps->len; ++j) {
        //    uint16_t val = deps->deps[j];
        //    json_t multiples;
        //    for(int k = 0; k < 16; ++k)
        //        if(val & (1 << k))
        //            multiples.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[k]);
        //    cf_params.push_back(multiples);
        //}
        //if(!cf_params.empty()) {
        //    __dfsw_json_init_func(i);
        //    out["functions"].back()["control_flow_params"] = cf_params; 
        //}
        //else
        //   out.erase( out.find("functions") );
    }

    std::cout << out.dump(2) << std::endl;
    delete &out;
}

void __dfsw_json_callsite(int f_idx, int site_idx, int arg_idx, bool * params)
{ 
    json_t & out = *__dfsw_json_get();
    //out["functions"][f_idx]["callsites"][site_idx]
}

void __dfsw_json_initialize()
{
    json_t & out = *__dfsw_json_get();
    //json_t functions; 
    //for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
    //    json_t function;
    //    function["name"] = __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i];
    //    function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i];
    //    int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i + 1];
    //    function["file"] = file_idx;// __EXTRAP_INSTRUMENTATION_FILES[file_idx]; 

    //    //function["callsites"]

    //    functions.push_back(function);
    //}
    ////std::cout << functions.dump(2) << std::endl;
    //out["functions"] = functions;
}
