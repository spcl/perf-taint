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
        if(!cf_params.empty())
            out["functions"][i]["control_flow_params"] = cf_params;
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
    json_t functions; 
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
        json_t function;
        function["name"] = __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i];
        function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i];
        int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i + 1];
        function["file"] = __EXTRAP_INSTRUMENTATION_FILES[file_idx]; 

        //function["callsites"]

        functions.push_back(function);
    }
    std::cout << functions.dump(2) << std::endl;
    out["functions"] = functions;
}
