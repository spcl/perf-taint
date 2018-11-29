#ifndef __DEPENDENCY_FINDER_HPP__
#define __DEPENDENCY_FINDER_HPP__

#include <llvm/ADT/SmallSet.h>

#include <algorithm>
#include <unordered_map>
#include <set>
#include <string>

#include <nlohmann/json_fwd.hpp>

namespace llvm {
    class Argument;
    class Instruction;
    class Value;
    class PHINode;
    class GlobalVariable;
    class GetElementPtrInst;
}

namespace extrap {

    class FunctionParameters;
    class AnalyzedFunction;

    struct Dependency
    {
        virtual ~Dependency() {}
        virtual void json(nlohmann::json &) const = 0;
    };

    struct FunctionArg : Dependency
    {
        int pos;
        std::string name;

        FunctionArg(std::string _name, int _pos): pos(_pos), name(_name) {}

        void json(nlohmann::json & j) const override;
    };
    
    struct GlobalArg : Dependency
    {
        std::string name;

        GlobalArg(std::string _name) :name(_name) {}

        void json(nlohmann::json & j) const override;
    };
 
    struct DependencyFinder
    {
        //std::unordered_map<std::string, Dependency*> dependencies;
        std::set<llvm::PHINode*> phi_nodes;
        typedef llvm::SmallSet<int32_t, 5> vec_t;

        ~DependencyFinder();

        bool find(const llvm::Argument * arg, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::GlobalVariable * instr, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::Value * v, const AnalyzedFunction *, const FunctionParameters & params, vec_t & ids);
        bool find(const llvm::Instruction * instr, const AnalyzedFunction *, const FunctionParameters & params, vec_t & ids);
        //bool find(const llvm::GetElementPtrInst * instr);
        //
    };

    // Serialization of Dependency
    void to_json(nlohmann::json& j, const Dependency * p);
}


#endif
