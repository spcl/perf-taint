#ifndef __JSONEXPORTER_HPP__
#define __JSONEXPORTER_HPP__

#include <llvm/IR/DebugInfoMetadata.h>

#include <nlohmann/json.hpp>

namespace llvm {
    class Function;
    class Module;
}

namespace extrap {

    class CallSite;
    class AnalyzedFunction;
    class Parameters;

    struct JSONExporter
    {
        nlohmann::json out;

        JSONExporter(llvm::Module &);
        
        nlohmann::json export_callsite(CallSite &);
        void export_function(llvm::Function & f, AnalyzedFunction &); 
        void export_parameters(const Parameters & params);
 
        nlohmann::json & json();

        template<typename OS>
        void print(OS & os) const
        {
            os << out.dump(2) << '\n';
        }
    private:
        nlohmann::json export_function(llvm::Function & f); 
    };

}


#endif
