#include <iostream>
#include <fstream>
#include <tuple>

#include <nlohmann/json.hpp>

#include "runtime.h"

typedef nlohmann::json json_t;

//#define DEBUG

json_t * __dfsw_json_get()
{
    static json_t * out = new json_t;
    return out;
}

void __dfsw_json_init_func(json_t & function, int func_idx, bool important)
{
    json_t & out = *__dfsw_json_get();
    function["func_idx"] = func_idx;
    const char * name = __EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES[func_idx];
    //function["name"] = name;
    function["line"] = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx];
    int file_idx = __EXTRAP_INSTRUMENTATION_FUNCS_DBG[2*func_idx + 1];
    if(file_idx != -1)
        function["file"] = __EXTRAP_INSTRUMENTATION_FILES[file_idx];
    if(important)
        out["functions"][name] = function;
    else {
        function.erase("loops");
        out["unimportant_functions"][name] = function;
    }
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

bool __dfsw_json_write_loop(int function_idx, int loop_idx, int loop_depth,
int deps_offset);

//void __dfsw_json_write_loop(int function_idx, int loop_idx)
//{
//    int32_t loops_depths_begin = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[function_idx];
//    int32_t loops_depths_end = loops_depths_begin + loop_idx;
//    int32_t deps_offset = __EXTRAP_LOOPS_DEPS_OFFSETS[function_idx];
//    int loop_depth = 0;
//    for(int j = loops_depths_begin; j <= loops_depths_end; ++j) {
//        loop_depth = __EXTRAP_LOOPS_DEPTHS_PER_FUNC[j];
//        deps_offset += loop_depth;
//    }
//    // one accumulation of deps_offset too far
//    deps_offset -= loop_depth;
//
//    fprintf(stderr, "WriteLoop Func: %s Loop %d Depth %d DepsOffset %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], loop_idx, loop_depth, deps_offset);
//    dfsw_json_write_loop(function_idx, loop_idx, loop_depth, deps_offset);
//
//    dependencies * deps = &__EXTRAP_LOOP_DEPENDENCIES[deps_offset - loop_depth];
//    // we need to clean it since the subset detection in __dfsw_add_dep
//    // might use old results
//    for(int i = 0; i < deps->len; ++i)
//        deps->deps[i] = 0;
//    deps->len = 0;
//}


// This function is usually called with a single loop instance.
// Such calles emerge during loop write and the input is an array of loop instances
// from a nested function call.
//
// However, the nested lookup for subloops can provide a list of multipath loops.//
// Furthermore, an array might appear even lower since callpath f-g->h
// will create in f a JSON with two JSON merged and arrays inside.
//
// TODO: this won't be necessary after replacing JSON -> array of integers
// and a proper aggregation that replaces an array
void __dfsw_json_update_loop_level_subloop(json_t & loops, int depth);

void __dfsw_json_update_loop_level(json_t & loops, int depth)
{
    //std::cerr << "UPDATE: " << loops << '\n';
    for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
        //std::cerr << "UPDATEX " << it.value() << '\n';
        if(it.value().is_array()) {
            //std::cerr << "UPDATEX ARRAY " << it.value() << '\n';
            for(auto & loop : it.value())
                __dfsw_json_update_loop_level(loop, depth);
        } else {
            //std::cerr << "UPDATEX LEVEL BEFORE " << loops << '\n';
            it.value()["level"] = it.value()["level"].get<int>() + depth;
            //std::cerr << "UPDATEX LEVEL AFTER " << loops << '\n';
            auto subloops = it.value().find("loops");
            if(subloops != it.value().end())
                __dfsw_json_update_loop_level_subloop(*subloops, depth);
        }
    }
}

void __dfsw_json_update_loop_level_subloop(json_t & loops, int depth)
{
    //[ loop, ... ])
    //std::cerr << "UPDATE: " << loops << '\n';
    if(loops.is_array()) {
        for(auto & loop : loops)
            __dfsw_json_update_loop_level(loop, depth);
    } else {
        for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
            //std::cerr << "UPDATE LOOP: " << it.value() << '\n';
            //{ loop_idx: [ loop, ... ])
            if(it.value().is_array()) {
                __dfsw_json_update_loop_level_subloop(it.value(), depth);
            }
            //{ loop_idx: { loop }
            else {
                it.value()["level"] = it.value()["level"].get<int>() + depth;
                auto subloops = it.value().find("loops");
                if(subloops != it.value().end())
                    __dfsw_json_update_loop_level_subloop(*subloops, depth);
            }
        }
    }
}

json_t __dfsw_json_write_single_loop(dependencies * deps)
{
    json_t params;
    for(int jj = 0; jj < deps->len; ++jj) {
        json_t dependency;
        uint16_t val = deps->deps[jj];
        //fprintf(stderr, "Func: %s Level %d Loop %d Value %d\n", __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[function_idx], level, loop, val);
        for(int kk = 0; kk < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++kk)
            if(val & (1 << kk)) {
                __EXTRAP_INSTRUMENTATION_PARAMS_USED[kk] = true;
                dependency.push_back(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[kk]);
                //filled = true;
            }
        int vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_MAX_COUNT + __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
        for(int kk = __EXTRAP_INSTRUMENTATION_PARAMS_MAX_COUNT; kk < vars_count; ++kk)
            if(val & (1 << kk)) {
                __EXTRAP_INSTRUMENTATION_PARAMS_USED[kk] = true;
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
        int32_t * loop_structure, dependencies * deps, int & nested_loop_idx,
        nested_call *& begin, nested_call * end)
{
    json_t loop;
    int depth = *loop_data;

    json_t params = __dfsw_json_write_single_loop(deps++);
    if(!params.empty())
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

            //fprintf(stderr, "Function %d Level %d LevelSize %d Loop %d ParentIdx %d\n", function_idx, level, level_size, loop, parent_idx);
            nested_loop_idx++;
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
            if(begin != end) {
                //fprintf(stderr, "Function %d Idx %d LoopIdx %d Len %d data_ptr %p\n", function_idx, nested_loop_idx, (begin + 0)->nested_loop_idx, begin->len, begin->json_data[0]);
                while(begin != end && begin->nested_loop_idx == nested_loop_idx) {
#ifdef DEBUG
                    fprintf(stderr, "Inner Function %d Idx %d Len %zu data_ptr %p\n", function_idx, nested_loop_idx, begin->len, begin->json_data);
#endif
                    for(size_t i = 0; i < begin->len; ++i) {
                        json_t * data = static_cast<json_t*>(begin->json_data[i]);
                        if(!data->empty()) {
                            loop_level["loops"][std::to_string(begin->loop_size_at_level)].push_back(*data);
                            __dfsw_json_update_loop_level(loop_level["loops"][std::to_string(begin->loop_size_at_level)].back(), level + 1);
                        }
                    }
                        //(*prev_iteration[parent_idx])["loops"][std::to_string(begin->loop_size_at_level)].push_back(*static_cast<json_t*>(begin->json_data[i]));
                    begin++;
                }
            }
            (*prev_iteration[parent_idx])["loops"][std::to_string(loop_idx)] = loop_level;
            cur_iteration[loop] = &(*prev_iteration[parent_idx])["loops"][std::to_string(loop_idx)];
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

void __dfsw_json_loop_committed(json_t * loop)
{
    if(__EXTRAP_CURRENT_CALL == -1)
        return;
    nested_call & last_call = __EXTRAP_NESTED_CALLS.data[__EXTRAP_CURRENT_CALL];
    for(size_t i = 0; i < last_call.len; ++i) {
        if(last_call.json_data[i] == static_cast<void*>(loop))
            return;
    }
    if(last_call.len == last_call.capacity) {
        last_call.capacity += 5;
        last_call.json_data = static_cast<void**>(realloc(last_call.json_data, sizeof(void**) *
                last_call.capacity));
    }
#ifdef DEBUG
    fprintf(stderr, "Save JSON data at pos %d new len %lu for call %d %d pos_ptr %p data_ptr %p\n", __EXTRAP_CURRENT_CALL, last_call.len + 1, last_call.nested_loop_idx, last_call.loop_size_at_level, &__EXTRAP_NESTED_CALLS.data[__EXTRAP_CURRENT_CALL], loop);
#endif
    last_call.json_data[last_call.len++] = static_cast<void*>(loop);
}

bool __dfsw_json_write_loop(int function_idx, int calls_count)
{
    std::vector<json_t> params;
    //printf("Func: %d Dep %d Offset %d\n", i, loop_depth, deps_offset);

    bool non_empty = false;
    int nested_loop_idx = 0;

    int32_t * loop_data = &__EXTRAP_LOOPS_SIZES_PER_FUNC[
        __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx]
    ];
    // array stores three integers for each top-lop
    int loop_count = (__EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx + 1 ]
            - __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx]) / 3;
    int deps_offset = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    size_t structure_offset =
        __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    int32_t * loop_structure = &__EXTRAP_LOOPS_STRUCTURE_PER_FUNC[
            structure_offset
        ];
    json_t output;

    // Use the fact that entries should be sorted
    // First, nested loop indices in an increasing order
    // Second, outer calls with index -1
    nested_call * begin = nullptr, * end = nullptr;
    if(calls_count) {
        size_t len = __EXTRAP_NESTED_CALLS.len;
        begin = &__EXTRAP_NESTED_CALLS.data[len - calls_count];
        end = &__EXTRAP_NESTED_CALLS.data[len - 1] + 1;
#ifdef DEBUG
        fprintf(stderr, "Read JSON data func %d calls_count %d len %zu from pos %lu to pos %lu from ptr %p to ptr %p\n",function_idx, calls_count, len, len - calls_count, len - 1, begin, end);
        for(size_t i = 0; i < len; ++i)
            fprintf(stderr, "Function %d Idx %zu LoopIdx %d Len %zu Size %d\n", function_idx, i, (begin + i)->nested_loop_idx, (begin + i)->len, (begin + i)->loop_size_at_level);
#endif
    }
#ifdef DEBUG
    fprintf(stderr, "Function %d CallsCount %d LoopCount %d DepsOffset %d Begin %p End %p\n", function_idx, calls_count, loop_count, deps_offset, begin, end);
#endif
    for(int loop_idx = 0; loop_idx < loop_count; ++loop_idx) {

        int32_t structure_entries = loop_data[1];
        int32_t number_of_loops = loop_data[2];
        //fprintf(stderr, "LoopIdx %d Offset deps %d Offset struct %d\n", loop_idx, deps_offset, structure_offset);
        //std::cout << __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx] << " " <<  __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[function_idx] << '\n';

        int old_nested_idx = nested_loop_idx;
        //TODO: fix
        json_t loop_copied;
        if(begin != end) {
            //fprintf(stderr, "Function %d Idx %d LoopIdx %d Len %d\n", function_idx, nested_loop_idx, (begin + 0)->nested_loop_idx, begin->len);
            int loop_idx_shift = begin->loop_size_at_level;
            while(begin != end && begin->nested_loop_idx == old_nested_idx) {
#ifdef DEBUG
                fprintf(stderr, "Function %d Idx %d Len %zu data_ptr %p\n", function_idx, nested_loop_idx, begin->len, begin->json_data);
#endif
                for(size_t i = 0; i < begin->len; ++i) {
#ifdef DEBUG
                    fprintf(stderr, "Read Function %d Idx %d Len %zu data_ptr %p Wrte at pos %d\n", function_idx, nested_loop_idx, begin->len, begin->json_data[i], loop_idx_shift);
#endif
                    json_t * data = static_cast<json_t*>(begin->json_data[i]);
                    loop_copied[std::to_string(begin->loop_size_at_level)].push_back(*data);
                    __dfsw_json_update_loop_level(loop_copied[std::to_string(begin->loop_size_at_level)].back(), 1);
                    //for(auto it = data->begin(), end = data->end(); it != end; ++it) {
                    //    std::cerr << "Add loop: " << it.key() << " " << it.value() << '\n';
                    //    loop_copied[std::to_string(begin->loop_size_at_level)].push_back(it.value());
                    //    __dfsw_json_update_loop_level(loop_copied[std::to_string(begin->loop_size_at_level)].back(), 1);
                    //}
                }
                //for(size_t i = 0; i < begin->len; ++i)
                //    output[std::to_string(begin->loop_size_at_level)]
                //        .push_back(*static_cast<json_t*>(begin->json_data[i]));
                begin++;
            }
        }
        dependencies * deps = &__EXTRAP_LOOP_DEPENDENCIES[deps_offset];
        json_t loop = __dfsw_json_write_loop(function_idx, loop_data,
               loop_structure, deps, nested_loop_idx, begin, end);
        for(auto it = loop_copied.begin(), end = loop_copied.end(); it != end; ++it)
            loop["loops"][it.key()] = std::move(it.value());
        //std::cerr << loop << std::endl;
        if(!loop.empty()) {
            output[std::to_string(loop_idx)] = loop;
        }
        // finish previous loop
        loop_data += 3;
        loop_structure += structure_entries;
        deps_offset += number_of_loops;
        nested_loop_idx++;
    }

    // Add loops that don't appear inside any loop.
    // Their nested_loop_idx is -1.
    // No need to update loop levels - they start from 0.
    if(begin != end) {
        while(begin != end && begin->nested_loop_idx == -1) {
            for(size_t i = 0; i < begin->len; ++i) {
                json_t * data = static_cast<json_t*>(begin->json_data[i]);
                //fprintf(stderr, "Function %d callsCount %d Outside Len %d AtPos %d pos_ptr %p data_ptr %p\n", function_idx, calls_count, begin->len, begin->loop_size_at_level, begin, begin->json_data[i]);
                for(auto it = data->begin(), end = data->end(); it != end; ++it) {
                    //std::cerr << "Add loop: " << it.key() << " " << it.value() << '\n';
                    //output[std::to_string(begin->loop_size_at_level)].push_back(it.value());
                }
                output[std::to_string(begin->loop_size_at_level)].push_back(*data);
            }
            begin++;
        }
    }

    //for(int i = 0; i < calls_count; ++i) {
    //    nested_call & call = __EXTRAP_NESTED_CALLS.data[len - i - 1];
    //    fprintf(stderr, "Function %d Call %d Found %d non-zero calls\n", function_idx, i, call.len);
    //}

    if(!output.empty()) {
        json_t * func = &__dfsw_json_get(function_idx);
        json_t & prev_loops = (*func)["loops"];
        bool found = false;
        for(json_t & prev : prev_loops) {
            if(prev["instance"] == output) {
                found = true;
                bool callstack_found = false;
                json_t callstack;
                for(size_t i = 0; i <  __EXTRAP_CALLSTACK.len - 1; ++i)
                    callstack.push_back( __EXTRAP_CALLSTACK.stack[i] );
                for(const json_t & stack : prev["callstacks"]) {
                    if(stack == callstack) {
                        callstack_found = true;
                        break;
                    }
                }
                __dfsw_json_loop_committed(&prev["instance"]);
                //fprintf(stderr, "Commit JSON data already known %p callstack_len %d\n", &prev,
                        //callstack.size());
                if(!callstack_found) {
                    prev["callstacks"].push_back( std::move(callstack) );
                }
                break;
            }
        }
        if(!found) {
            // don't write current function
            json_t callstack;
            for(size_t i = 0; i <  __EXTRAP_CALLSTACK.len - 1; ++i)
                callstack.push_back( __EXTRAP_CALLSTACK.stack[i] );
            json_t instance;
            instance["callstacks"].push_back(callstack);
            instance["instance"] = output;
            ////std::cerr << instance << " " << prev_loops << '\n';
            ////
            //std::cout << instance << std::endl;
            //std::cout << *func << std::endl;
            //std::cout << function_idx << std::endl;
            //std::cout << prev_loops << std::endl;
            prev_loops.push_back( std::move(instance) );
            //fprintf(stderr, "Commit new JSON data %p callstack_len %d \n", &prev_loops.back(), callstack.size());
            __dfsw_json_loop_committed( & prev_loops.back()["instance"] );
        }
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

bool __dfsw_json_loop_is_important(json_t & loop_set);

bool __dfsw_is_important(json_t & loop)
{
    bool important = loop.find("params") != loop.end();
    auto subloops_it = loop.find("loops");
    if(subloops_it == loop.end()) {
        //it is not important! move to next loop
        if(!important)
            return important;
    }
    // visit subloops
    else {
        bool subloops_important = __dfsw_json_loop_is_important(*subloops_it);
        //std::cerr << subloops_important << " " << *subloops_it << '\n';
        //for(auto & l : *subloops_it) {
        //    // important subloop.
        //    // don't leave the function since we want to erase
        //    // empty subloops elsewhere
        //    if(__dfsw_json_loop_is_important(l)) {
        //        subloops_important = true;
        //        break;
        //    }
        //}
        //// subloops exist but they are not important
        if(!subloops_important)
            loop.erase("loops");
        important |= subloops_important;
    }
    return important;
}

bool __dfsw_json_loop_is_important(json_t & loop_set)
{
    bool global_important = false;
    for(auto it = loop_set.begin(), end = loop_set.end(); it != end; ++it) {
        json_t & loop  = it.value();
        bool important = false;
        // TODO: temporary fix to handle the case where subloops is an array
        // it can only happen when multiple JSONs are written in a nested function call
        if(loop.is_array()) {
            for(auto & v : loop) {
                //std::cerr << v << '\n';
                important |= __dfsw_json_loop_is_important(v);//__dfsw_is_important(v);
            }
        } else {
            important |= __dfsw_is_important(loop);
        }
        global_important |= important;
    }
    return global_important;
}

bool __dfsw_json_is_important(json_t & json)
{
    json_t & loops = json["loops"];
    if(loops.empty())
        return false;
    bool important = false;
    size_t idx = 0;
    std::vector<size_t> entries_to_remove;
    for(auto & loop : loops) {
        // don't leave - important but continue pruning
        if(__dfsw_json_loop_is_important(loop["instance"]))
          important = true;
        else
            entries_to_remove.push_back(idx);
        ++idx;
    }
    for(size_t v : entries_to_remove)
        loops.erase(v);
    return important;
}

void __dfsw_dump_json_output()
{
    json_t & out = *__dfsw_json_get();
    int vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;

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
    json_t functions_names, functions_mangled_names, functions_demangled_names;
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
        bool important_function = __dfsw_json_is_important(function);
        __dfsw_json_init_func(function, i, important_function);
            //out["functions"].back()["loops"] = cf_params;
            //

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

    json_t params, unused_params;
    for(int i = 0; i < vars_count; ++i) {
        // Fix for an old problem where legacy code detected params through
        // annotations and the new code registered params at runtime through
        // a call to store_label. Thus, it is possible that in case
        // of a mismatch we have more storage than we actually use.
        // Ensure that a name was written!
        if(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i]) {
            if(__EXTRAP_INSTRUMENTATION_PARAMS_USED[i])
                params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i] );
            else
                unused_params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i] );
        }

    }
    vars_count = __EXTRAP_INSTRUMENTATION_PARAMS_MAX_COUNT
        + __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
    for(int i = __EXTRAP_INSTRUMENTATION_PARAMS_MAX_COUNT; i < vars_count; ++i) {
        if(__EXTRAP_INSTRUMENTATION_PARAMS_USED[i])
            params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i] );
        else
            unused_params.push_back( __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i] );
    }
    out["parameters"] = params;
    if(!unused_params.empty())
        out["unused_parameters"] = unused_params;

    for(int i = 0; i < __EXTRAP_FUNCS_COUNT; ++i) {
        functions_names.push_back(__EXTRAP_INSTRUMENTATION_FUNCS_NAMES[i]);
        functions_mangled_names.push_back(__EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES[i]);
        functions_demangled_names.push_back(__EXTRAP_INSTRUMENTATION_FUNCS_DEMANGLED_NAMES[i]);
    }
    out["functions_names"] = std::move(functions_names);
    out["functions_mangled_names"] = std::move(functions_mangled_names);
    out["functions_demangled_names"] = std::move(functions_demangled_names);
    if(strcmp(__EXTRAP_INSTRUMENTATION_OUTPUT_FILENAME, "")) {
        if(__EXTRAP_INSTRUMENTATION_MPI_RANK != -1) {
            std::ofstream file(__EXTRAP_INSTRUMENTATION_OUTPUT_FILENAME
                    + std::string("_")
                    + std::to_string(__EXTRAP_INSTRUMENTATION_MPI_RANK)
                    + ".json",
                    std::ofstream::out);
            file << out.dump(2) << std::endl;
            file.close();
        } else {
            std::ofstream file(
                __EXTRAP_INSTRUMENTATION_OUTPUT_FILENAME + std::string(".json"),
                std::ofstream::out
                );
            file << out.dump(2) << std::endl;
            file.close();
        }
    } else
        std::cout << out.dump(2) << std::endl;
    delete &out;
    delete[] &__dfsw_json_get(0);
}

//void __dfsw_json_callsite(int f_idx, int site_idx, int arg_idx, bool * params)
//{
//    //json_t & out = *__dfsw_json_get();
//    //out["functions"][f_idx]["callsites"][site_idx]
//}

void __dfsw_json_initialize()
{
    __dfsw_json_get();
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
