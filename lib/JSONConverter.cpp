#include <iostream>
#include <string>
#include <fstream>
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
    if(ops.size() == 1)
        return ops;
    else
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
            additive_layers.push_back( convert_loop(it.value()) );
        }
    }
    auto it = loop.find("params");
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


json_t convert_loop_set(set_t & loop_set)
{
    json_t output;
    output["dependency"] = "additive";
    json_t & deps = output["operands"];
    for(auto & val : loop_set)
    {
        // TODO: here we only take a single instance of 
        json_t dep;
        for(auto v : val.second)
            dep.push_back(convert_loop(**v));
        deps.push_back(dep);
    }

    return output;
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
        "dbg_name"
    };
    for(const auto & key : to_copy) {
        output[key] = std::move(input[key]);
    }

    json_t & functions = input["functions"];
    json_t & functions_output = output["functions"];
    for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {

        const json_t & loops = it.value()["loops"];
        // callstack -> list of loops
        std::map<json_t, set_t> aggregated_callstacks;
        for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
            std::string loop_idx = it.key();
            const auto & loop_instances = it.value();
            for(auto & loop_instance : loop_instances) {
                const auto & callstacks = loop_instance["callstacks"];
                for(const auto & callstack : callstacks) {
                    //std::cout << callstack << '\n';
                    auto find = aggregated_callstacks.find(callstack);
                    if(find != aggregated_callstacks.end()) {
                        (*find).second[loop_idx].push_back(&loop_instance["instance"]);
                    } else {
                        aggregated_callstacks[callstack][loop_idx] =
                            std::vector<const json_t*>{1, &loop_instance["instance"]};
                    }
                }
            }
        }

        json_t new_loops;
        for(auto & callstack : aggregated_callstacks) {
            json_t instance;
            instance["callstack"] = callstack.first;
            instance["data"] = convert_loop_set(callstack.second);
            new_loops.push_back(std::move(instance));
        }

        json_t function;
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
