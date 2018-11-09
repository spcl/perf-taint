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

    struct JSONExporter
    {
        nlohmann::json out;

        JSONExporter(llvm::Module &);
        
        nlohmann::json export_callsite(CallSite &);
        nlohmann::json export_function(llvm::Function & f, AnalyzedFunction &); 
        
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
