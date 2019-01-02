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

    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
        json_t cf_params;
        for(int j = 0; j < vars_count; ++j) {
            if(__EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j])
                cf_params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[j]);
        }
        dependencies *deps = __dfsw_EXTRAP_DEPS_FUNC(i);
        for(int j = 0; j < deps->len; ++j) {
            uint16_t val = deps->deps[j];
            json_t multiples;
            for(int k = 0; k < 16; ++k)
                if(val & (1 << k))
                    multiples.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[k]);
            cf_params.push_back(multiples);
        }
        if(!cf_params.empty()) {
            __dfsw_json_init_func(i);
            out["functions"].back()["control_flow_params"] = cf_params; 
        }
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
