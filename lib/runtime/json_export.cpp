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

void __dfsw_json_init_func(json_t & function, int func_idx, bool important)
{
    json_t & out = *__dfsw_json_get();
    function["dbg_name"] = __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[func_idx];
    const char * name = __EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES[func_idx];
    //function["name"] = name;
    function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx];
    int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx + 1];
    if(file_idx != -1)
        function["file"] = __EXTRAP_INSTRUMENTATION_FILES[file_idx];
    if(important)
        out["functions"][name] = function;
    else
        out["unimportant_functions"][name] = function;
}

// ignore initialization when accessing ptrs for cleaning
json_t & __dfsw_json_get(int func_idx, bool init = true)
{
    static json_t * funcs = new json_t[__EXTRAP_INSTRUMENTATION_FUNCS_COUNT]();
    return funcs[func_idx];
}

void __dfsw_json_write_callsites(json_t & out, int func_idx)
{
    json_t callsites;

    //int begin = __EXTRAP_CALLSITES_OFFSET[func_idx];
    //int end = __EXTRAP_CALLSITES_OFFSET[func_idx];


    out["callsites"] = callsites;
}

//bool __dfsw_json_write_loop(int function_idx, int loop_idx, int loop_depth,
//int deps_offset);

//void __dfsw_json_write_loop(int function_idx, int loop_idx)
//{
//    //int32_t loops_depths_begin = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[function_idx];
//    //int32_t loops_depths_end = loops_depths_begin + loop_idx;
//    //int32_t deps_offset = __EXTRAP_LOOPS_DEPS_OFFSETS[function_idx];
//    //int loop_depth = 0;
//    //for(int j = loops_depths_begin; j <= loops_depths_end; ++j) {
//    //    loop_depth = __EXTRAP_LOOPS_DEPTHS_PER_FUNC[j];
//    //    deps_offset += loop_depth;
//    //}
//    //// one accumulation of deps_offset too far
//    //deps_offset -= loop_depth;
//
//    //fprintf(stderr, "WriteLoop Func: %s Loop %d Depth %d DepsOffset %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], loop_idx, loop_depth, deps_offset);
//    __dfsw_json_write_loop(function_idx, loop_idx, loop_depth, deps_offset);
//
//    //dependencies * deps = &__EXTRAP_LOOP_DEPENDENCIES[deps_offset - loop_depth];
//    //// we need to clean it since the subset detection in __dfsw_add_dep
//    //// might use old results
//    //for(int i = 0; i < deps->len; ++i)
//    //    deps->deps[i] = 0;
//    //deps->len = 0;
//}
//

json_t __dfsw_json_write_single_loop(dependencies * deps)
{
    json_t params;
    for(int jj = 0; jj < deps->len; ++jj) {
        json_t dependency;
        uint16_t val = deps->deps[jj];
        //fprintf(stderr, "Func: %s Level %d Loop %d Value %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], level, loop, val);
        for(int kk = 0; kk < 16; ++kk)
            if(val & (1 << kk)) {
                dependency.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[kk]);
                //filled = true;
            }
        deps->deps[jj] = 0;
        if(!dependency.empty()) {
            params.push_back(std::move(dependency));
        }
    }
    deps->len = 0;
    return params;
}

json_t __dfsw_json_write_loop(int function_idx, int32_t * loop_data,
        int32_t * loop_structure, dependencies * deps)
{
    json_t loop;
    int depth = *loop_data;

    json_t params = __dfsw_json_write_single_loop(deps++);
    loop["params"] = params;
    loop["level"] = 0;
    int level_size = *loop_structure, next_level_size = 0;
    //loop["nested_loops"] = level_size;

    json_t ** prev_iteration = new json_t*[1]();
    prev_iteration[0] = &loop;
    for(int level = 1; level < depth; ++level) {


        //int loop = 0;
        // number of loops on this level
        int parent_idx = 0, loop_idx = 0, processed_loops = 0;
        json_t ** cur_iteration = new json_t*[level_size];
        for(int loop = 0; loop < level_size; ++loop) {

            fprintf(stderr, "Function %d Level %d LevelSize %d Loop %d ParentIdx %d\n", function_idx, level, level_size, loop, parent_idx);
            // skip parent when all loops are already processed
            while(loop_idx >= *loop_structure) {

                parent_idx++;
                loop_structure++;
                //next_level_size += *loop_structure;
                loop_idx = 0;
                processed_loops = 0;
            }
            json_t loop_level;
            loop_level["level"] = level;
            json_t params = __dfsw_json_write_single_loop(deps++);
            if(!params.empty())
                loop_level["params"] = params;
            //loop_level["nested_loops"] = level_size;
            (*prev_iteration[parent_idx])["subloops"][std::to_string(loop_idx)] = loop_level;
            cur_iteration[loop] = &(*prev_iteration[parent_idx])["subloops"][std::to_string(loop_idx)];
            loop_idx++;
            //int nested_loop = 0;
            //for(; nested_loop < *loop_structure; ++nested_loop) {

            //    //json_t params = __dfsw_json_write_single_loop(deps++);
            //    //if(!params.empty()) {
            //    //    loop_level["loops"][std::to_string(loop)] = params;
            //    //}
            //}
            //loop += *loop_structure;
            //fprintf(stderr, "Func: %s Level %d NumberOfLoops %d Loop %d Value %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], level, level_size, loop, val);
            //std::cout << level << " " << *loop_structure << std::endl;
            //next_level_size += *loop_structure++;
            //(*cur_iteration)
            //auto & prev_loops = (*prev_iteration)["loops"];
            //auto it = prev_loops.find( std::to_string(
        }
        loop_structure++;
        for(int i = 0; i < level_size; ++i)
            next_level_size += *(loop_structure + i);
        std::swap(level_size, next_level_size);
        std::swap(prev_iteration, cur_iteration);
        //prev_iteration = &(*prev_iteration)["subloops"];
        next_level_size = 0;
        delete[] cur_iteration;
    }

    delete[] prev_iteration;

    //for(int loop = 0; loop < level_size; ++loop) {
    //    fprintf(stderr, "Func: %s Level %d NumberOfLoops %d Loop %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], level, level_size, loop);
    //    json_t deps_json;
    //    bool filled = false;
    //    loop_level["params"].push_back(std::move(dependency));
    //    int32_t next_level_size = *(loop_structure + loop);
    //    int32_t * subloops = loop_structure + level_size + loop;
    //    dependencies * sub_data = deps + number_of_loops + loop;
    //    json_t subloops_data = __dfsw_json_write_loop(function_idx, level + 1,
    //            next_level_size, subloops, sub_data);
    //    if(!subloops_data.empty()) {
    //        loop_level["subloops"] = subloops_data;
    //    }
    //    //loop_level["loops"][ std::to_string(loop) ] = loop_data;
    //    //if(!filled) {
    //    //    json_t loop_data;
    //    //    loop_data["params"] = deps_json;
    //    //    int32_t * subloops = loop_structure + number_of_loops + loop;
    //    //    dependencies * sub_data = deps + number_of_loops + loop;
    //    //    json_t subloops_data = __dfsw_json_write_loop(function_idx, level + 1, subloops,
    //    //            sub_data);
    //    //    if(!subloops_data.empty()) {
    //    //        loop_data["loops"] = subloops_data;
    //    //    }
    //    //    loop_level["loops"][ std::to_string(loop) ] = loop_data;
    //    //}
    //    deps++;
    //}
    return loop;
}

bool __dfsw_json_write_loop(int function_idx, int loop_idx)
{
    std::vector<json_t> params;
    //printf("Func: %d Dep %d Offset %d\n", i, loop_depth, deps_offset);

    bool non_empty = false;

    int32_t * loop_data = &__EXTRAP_LOOPS_SIZES_PER_FUNC[
        __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx]
    ];
    int deps_offset = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    size_t structure_offset =
        __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    // Accumulate offsets and skip data related to previous loops
    for(int i = 0; i < loop_idx; ++i) {
        int32_t structure_entries = loop_data[1];
        int32_t number_of_loops = loop_data[2];
        structure_offset += structure_entries;
        deps_offset += number_of_loops;
        loop_data += 3;
    }
    int32_t loop_depth = loop_data[0];
    int32_t structure_entries = loop_data[1];
    //fprintf(stderr, "LoopIdx %d Offset deps %d Offset struct %d\n", loop_idx, deps_offset, structure_offset);
    int32_t * loop_structure = &__EXTRAP_LOOPS_STRUCTURE_PER_FUNC[
        structure_offset
    ];
    //std::cout << __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx] << " " <<  __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx] << '\n';
    dependencies * deps = &__EXTRAP_LOOP_DEPENDENCIES[deps_offset];
    json_t loop = __dfsw_json_write_loop(function_idx, loop_data, loop_structure, deps);
    if(!loop.empty()) {
        json_t * func = &__dfsw_json_get(function_idx);
        json_t & prev_loops = (*func)["loops"][std::to_string(loop_idx)];
        //std::cout << dependency << '\n';
        bool found = false;
        for(json_t & prev : prev_loops) {
            //std::cout << prev << '\n';
            if(prev == loop) {
                found = true;
                break;
            }
        }
        if(!found)
            prev_loops.push_back(loop);
    }
    return non_empty;
    //if(filled > 1) {
    //    cf_params.push_back(std::move(params));
    //    important_function = true;
    //    //std::cout << "Add params: " << params << std::endl;
    //} else if(filled) {
    //    cf_params.push_back(params[1]);
    //    important_function = true;
    //    //std::cout << "Add params: " << params[1] << std::endl;
    //}
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

        //json_t cf_params;
        //int32_t loops_depths_begin = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[i];
        //int32_t loops_depths_end = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[i + 1];
        //bool important_function = false;
        //int32_t deps_offset = __EXTRAP_LOOPS_DEPS_OFFSETS[i];
        ////fprintf(stderr,"Func: %s Dep %d Dep %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i], loops_depths_begin, loops_depths_end);
        //for(int j = loops_depths_begin; j < loops_depths_end; ++j) {

        //    bool empty = true;
        //    int loop_depth = __EXTRAP_LOOPS_DEPTHS_PER_FUNC[j];
        //    int loop_idx = j - loops_depths_begin;
        //    important_function |= __dfsw_json_write_loop(i, loop_idx, loop_depth, deps_offset);
        //    deps_offset += loop_depth;
        //}
        json_t & function = __dfsw_json_get(i);
        bool important_function = !function.empty();
        __dfsw_json_init_func(function, i, important_function);
            //out["functions"].back()["loops"] = cf_params;

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
    delete[] &__dfsw_json_get(0);
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
