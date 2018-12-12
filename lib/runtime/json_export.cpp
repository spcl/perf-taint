#include <iostream>
#include <tuple>

#include <nlohmann/json.hpp>

#include "runtime.h"

typedef nlohmann::json json_t;

void __dfsw_dump_json_output()
{
    nlohmann::json out;
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
   
    json_t functions; 
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_FUNCS_COUNT; ++i) {
        json_t function;
        function["name"] = __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i];
        function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i];
        int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*i + 1];
        function["file"] = __EXTRAP_INSTRUMENTATION_FILES[file_idx]; 

        json_t cf_params;
        for(int j = 0; j < vars_count; ++j) {
            if(__EXTRAP_INSTRUMENTATION_RESULTS[i*vars_count + j])
                cf_params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[j]);
        }
        if(!cf_params.empty())
            function["control_flow_params"] = cf_params;
        functions.push_back(function);
    }
    out["functions"] = functions;
    
    std::cout << out.dump(2) << std::endl;
}
