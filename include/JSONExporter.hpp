#ifndef __JSONEXPORTER_HPP__
#define __JSONEXPORTER_HPP__

#include <nlohmann/json.hpp>

namespace llvm {
    class Function;
    class Module;
}

namespace extrap {

    class CallSite;

    struct JSONExporter
    {
        nlohmann::json out;

        JSONExporter(llvm::Module &);
        
        template<typename Iter>
        void export_function(llvm::Function & f, Iter callsite_begin, Iter callsite_end)
        {
            nlohmann::json function = export_function(f);
            std::vector<nlohmann::json> callsites;
            while(callsite_begin != callsite_end) {
                callsites.push_back( std::move(export_callsite(*callsite_begin)) );
                ++callsite_begin;
            }
            function["callsites"] = callsites;
            out["functions"].push_back(function);
        }
        nlohmann::json export_callsite(CallSite &);
        nlohmann::json export_function(llvm::Function & f); 
        
        nlohmann::json & json();

        template<typename OS>
        void print(OS & os) const
        {
            os << out.dump(2) << '\n';
        }
    };

}


#endif
