#include <iostream>
#include <string>
#include <fstream>
#include <set>
#include <nlohmann/json.hpp>

typedef nlohmann::json json_t;

// loop_idx -> loop
typedef std::map<std::string, std::vector<const json_t*>> set_t;

json_t convert_params(const json_t & params)
{
    json_t output;
    output["dependency"] = "unknown";
    json_t & ops = output["operands"];
    for(const auto & param : params) {
        if(param.is_array()) {
            for(const auto & p : param)
                ops.push_back(p);
        } else
            ops.push_back(param);
    }
    //if(ops.size() == 1)
    //    return ops[0];
    //else
    return output;
}

json_t convert_loop(const json_t & loop)
{
    std::vector<json_t> layers;
    json_t output;

    json_t current;
    std::vector<json_t> additive_layers;
    auto subloops = loop.find("loops");
    if(subloops != loop.end()) {
        for(auto it = subloops->begin(), end = subloops->end(); it != end; ++it) {
            //std::cout << it.key() << ' ' << it.value() << '\n';
            //std::cout << "Convert: " << it.value() << '\n';
            additive_layers.push_back( convert_loop(it.value()) );
            //std::cout << "Converted: " << additive_layers.back() << '\n';
        }
    }
    auto it = loop.find("params");
    //std::cout << "Properconvert: " << loop << " " << additive_layers.size() << '\n';
    if(it != loop.end()) {
        json_t params = convert_params(*it);
        // no additional dependency
        if(additive_layers.size() == 0) {
            return params;
        }
        else {
            json_t additive;
            additive["dependency"] = "additive";
            additive["operands"] = std::move(additive_layers);
            json_t result;
            result["dependency"] = "multiplicative";
            result["operands"].push_back(params);
            result["operands"].push_back(additive);
            return result;
        }
    } else {
        // no params? skip this, return an additive over subloops
        if(additive_layers.size() == 1) {
            return additive_layers[0];
        } else {
            json_t additive;
            additive["dependency"] = "additive";
            additive["operands"] = std::move(additive_layers);
            return additive;
        }
    }

    //while(cur_layer) {
    //    auto it = cur_layer->find("params");
    //    //std::cout << *cur_layer << ' ' << (it != cur_layer->end()) << '\n';
    //    if(it != cur_layer->end()) {
    //        layers.push_back( convert_params(*it) );
    //    }
    //    auto subloops = cur_layer->find("loops");
    //    //std::cout << *cur_layer << ' ' << (subloops != cur_layer->end()) << '\n';
    //    cur_layer = (subloops != cur_layer->end()) ? &(*subloops) : nullptr;
    //    additive_layers.clear();
    //    if(cur_layer) {
    //        for(auto it = cur_layer->begin(), end = cur_layer->end(); it != end; ++it) {
    //            std::cout << it.key() << ' ' << it.value() << '\n';
    //        }
    //    }
    //}

    //output["dependency"] = "multiplicative";
    //output["operands"] = layers;

    //return output;
}


json_t convert_loop_set(const json_t & loop_set)
{
    json_t output;
    output["dependency"] = "additive";
    json_t & deps = output["operands"];
    for(auto it = loop_set.begin(), end = loop_set.end(); it != end; ++it)
    {
        // TODO : change when we get sequence of loops comitted at instance
        //json_t dep;
        //for(auto v : it.value()) {
        //dep.push_back(convert_loop(*v));
        //}
        //deps.push_back(dep);
        deps.push_back(convert_loop(it.value()));
    }

    return output;
}

uint32_t param_to_int(const json_t & op, const json_t & params)
{
    uint32_t res = 0;
    for(auto & v: op) {
        size_t i = 0;
        for(; i < params.size(); ++i)
            if(params[i] == v)
                break;
        res |= (1 << i);
    }
    return res;
}

std::vector<uint32_t> parse(const json_t & op, const json_t & all_params)
{
    // now we process each instance per callstack
    //if(op.is_array()) {
    //    std::cout << "Process param: " << op << ' ' << param_to_int(op, all_params) << '\n';
    //    return std::vector<uint32_t>(1, param_to_int(op, all_params));
    //} else
    //if(op.is_array()) {
    //    std::cout << "Process param: " << op << ' ' << param_to_int(op, all_params) << '\n';
    //    return std::vector<uint32_t>(1, param_to_int(op, all_params));
    //} else
    if(op.is_array()) {
        return parse(op[0], all_params);
    } else if(op["dependency"] == "additive") {
        const json_t ops = op["operands"];
        std::vector<uint32_t> params;
        for(const auto & v : ops) {
            //std::cout << "Process additive arg: " << v << '\n';
            auto res = parse(v, all_params);
            //std::cout << "Process additive arg: " << v << " results: ";
            for(uint32_t val : res) {
                //std::cout << val << ' ';
                params.push_back(val);
            }
            //std::cout << '\n';
        }
        //std::cout << "Process additive: " << ops << ' ' << params.size() << '\n';
        return params;
    } else if(op["dependency"] == "multiplicative") {
        const json_t ops = op["operands"];
        std::vector<uint32_t> params = parse(ops[0], all_params);
        //std::cout << "Process multiplicative arg: " << ops[0]  << " begin: ";
        //for(auto v : params)
        //    std::cout << v << ' ';
        //std::cout << '\n';
        // TODO: remove duplicates
        for(int i = 1; i < ops.size(); ++i) {
           auto res = parse(ops[i], all_params);
           std::vector<uint32_t> new_params;
            //std::cout << "Process multiplicative arg: " << ops[i]  << " results: ";
            for(int i = 0; i < params.size(); ++i) {
               for(int j = 0; j < res.size(); ++j) {
                    uint32_t result = params[i] | res[j];
                    //std::cout << result << ' ';
                    new_params.push_back(result);
               }
            }
            //std::cout << '\n';
            // if there is nothing beneath, don't override old results
            if(res.size() != 0)
                params = std::move(new_params);
        }
        //std::cout << "Process mul: " << ops << ' ' << params.size() << '\n';
        return params;
    } else if(op["dependency"] == "unknown") {
        uint32_t res = 0;
        //std::cout << "Process unknown: " << op["operands"] << '\n';
        for(const auto & v : op["operands"])
            res |= param_to_int(v, all_params);
        //std::cout << "Process unknown: " << op["operands"] << ' ' << res << '\n';
        return std::vector<uint32_t>{res};
    } else {
        assert(false);
    }
}

void get_deps(json_t & out, json_t & loop, const json_t & params)
{
    // pessimistic implementation - each unknown is multiplication
    // TODO : change when we get sequence of loops comitted at instance
    //json_t & ops = loop["operands"];
    json_t & deps = out["deps"];
    std::set<uint32_t> dependencies;
    json_t & not_found_params = out["not_found_params"];
    uint32_t aggregation = 0;
    // TODO: nested array, shouldn't be here
    // right now we have have a list of loops and for each one list of instances
    // this should be a list of instances where each one is additive instance
    //std::cout << "Op: " << ops << '\n';
    //for(const auto & op_array : ops)
    //{
    //    std::cout << "Op: " << op_array << '\n';
    //    for(const auto & op : op_array)
    //    {
    //        std::vector<uint32_t> results = parse(op, params);
    //        for(uint32_t v : results)
    //        {
    //            aggregation |= v;
    //            dependencies.insert(v);
    //        }
    //    }
    //}
    std::vector<uint32_t> loop_data = parse(loop, params);
    for(uint32_t v : loop_data)
    {
        aggregation |= v;
        dependencies.insert(v);
    }
    for(int i = 0; i < params.size(); ++i)
        if(!(aggregation & (1 << i)))
           not_found_params.push_back(params[i]);
    for(auto v : dependencies)
    {
        json_t dependency;
        for(int i = 0; i < params.size(); ++i)
            if(v & (1 << i))
                dependency.push_back(params[i]);
        deps.push_back( std::move(dependency) );
    }
}

json_t convert(json_t & input)
{
    json_t output;
    std::vector<std::string> to_copy{
        "functions_demangled_names",
        "functions_mangled_names",
        "functions_names",
        "parameters"
    };
    std::vector<std::string> to_copy_local{
        "file",
        "line",
        "func_idx"
    };
    for(const auto & key : to_copy) {
        output[key] = std::move(input[key]);
    }

    json_t & functions = input["functions"];
    json_t & functions_output = output["functions"];
    json_t & params = output["parameters"];
    for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {

        //std::cout << "Name: " << it.key() << '\n';
        json_t & loops = it.value()["loops"];
        // callstack -> list of loops
        //std::map<json_t, set_t> aggregated_callstacks;
        //for(const auto & loop_instances : loops) {
        ////for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
        //    //std::string loop_idx = it.key();
        //    //const auto & loop_instances = it.value();
        //    for(auto & loop_instance : loop_instances) {
        //        const auto & callstacks = loop_instance["callstacks"];
        //        for(const auto & callstack : callstacks) {
        //            //std::cout << callstack << '\n';
        //            auto find = aggregated_callstacks.find(callstack);
        //            if(find != aggregated_callstacks.end()) {
        //                (*find).second[loop_idx].push_back(&loop_instance["instance"]);
        //            } else {
        //                aggregated_callstacks[callstack][loop_idx] =
        //                    std::vector<const json_t*>{1, &loop_instance["instance"]};
        //            }
        //        }
        //    }
        //}

        std::map<json_t, std::tuple<json_t, std::vector<uint32_t>> > aggregated_callstacks;
        json_t new_loops;
        for(auto & callstack : loops) {//aggregated_callstacks) {
            json_t & callstack_data = callstack["callstacks"];
            json_t converted = convert_loop_set(callstack["instance"]);
            std::vector<uint32_t> loop_data = parse(converted, params);
            auto it = aggregated_callstacks.find(callstack_data);
            if(it != aggregated_callstacks.end()) {
                std::get<0>((*it).second)["data"].push_back(std::move(converted));
                for(uint32_t v : loop_data)
                    std::get<1>((*it).second).push_back(v);
            } else {
                json_t instance;
                instance["callstack"] = callstack_data;
                instance["data"].push_back(std::move(converted));
                aggregated_callstacks[callstack_data] =
                    std::make_tuple(std::move(instance), std::move(loop_data));
            }
             //callstack.first;
            //std::cout << "Start data: " << callstack.second << '\n';
            //get_deps(instance, instance["data"], output["parameters"]);
            //new_loops.push_back(std::move(instance));
        }

        json_t function;
        for(auto & v : aggregated_callstacks) {
            std::set<uint32_t> dependencies;
            json_t & deps = std::get<0>(v.second)["deps"];
            json_t & not_found_params = std::get<0>(v.second)["not_found_params"];
            uint32_t aggregation = 0;
            for(uint32_t v : std::get<1>(v.second))
            {
                aggregation |= v;
                dependencies.insert(v);
            }
            for(int i = 0; i < params.size(); ++i)
                if(!(aggregation & (1 << i)))
                   not_found_params.push_back(params[i]);
            for(auto v : dependencies)
            {
                json_t dependency;
                for(int i = 0; i < params.size(); ++i)
                    if(v & (1 << i))
                        dependency.push_back(params[i]);
                deps.push_back( std::move(dependency) );
            }
            new_loops.push_back( std::move(std::get<0>(v.second)) );
        }
        // TODO: nested array, shouldn't be here
        // right now we have have a list of loops and for each one list of instances
        // this should be a list of instances where each one is additive instance
        //std::cout << "Op: " << ops << '\n';
        //for(const auto & op_array : ops)
        //{
        //    std::cout << "Op: " << op_array << '\n';
        //    for(const auto & op : op_array)
        //    {
        //        std::vector<uint32_t> results = parse(op, params);
        //        for(uint32_t v : results)
        //        {
        //            aggregation |= v;
        //            dependencies.insert(v);
        //        }
        //    }
        //}

        function["loops"] = std::move(new_loops);
        for(const auto & key : to_copy_local) {
            function[key] = std::move(it.value()[key]);
        }
        functions_output[it.key()] = std::move(function);
    }

    return output;
}


int main(int argc, char ** argv)
{
    json_t input;
    assert(argc == 2);
    std::ifstream in(argv[1], std::ios_base::in);
    in >> input;
    in.close();

    json_t converted = convert(input);
    std::cout << converted.dump(2);
    return 0;
}
