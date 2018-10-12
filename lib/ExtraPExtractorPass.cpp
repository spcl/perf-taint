
#include "ExtraPExtractorPass.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

#include <polly/PolySCEV.h>
#include <barvinok/isl.h>

#include <iostream>
#include <vector>
#include <string>
#include <tuple>

static llvm::cl::opt<std::string> LogFileName("extrap-extractor-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("extrap-extractor-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

namespace {

    void ExtraPExtractorPass::getAnalysisUsage(llvm::AnalysisUsage &AU) const
    {
        ModulePass::getAnalysisUsage(AU);
        // We require loop information
        AU.addRequiredTransitive<llvm::LoopInfoWrapperPass>();
        AU.addRequiredTransitive<llvm::ScalarEvolutionWrapperPass>();
        AU.addRequired<polly::PolySCEV>();
        // Pass does not modify the input information
        AU.setPreservesAll();
    }

    bool ExtraPExtractorPass::runOnModule(llvm::Module &m)
    {
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        PM.add(llvm::createMetaRenamerPass());
        PM.add(llvm::createCorrelatedValuePropagationPass());
        // mem2reg pass
        PM.add(llvm::createPromoteMemoryToRegisterPass());
        // loop-simplify
        PM.add(llvm::createLoopSimplifyPass());
        PM.run(m);

        // Since neither m.getName() or m.getSourceFileName provides a meaningful name
        // We rely on the user to supply an additional log name.
        std::string name = LogDirName.getValue().empty() ?
                           "results" :
                           cppsprintf("%s/results",
                                      LogDirName.getValue().c_str());
        log.open(
            cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()),
            std::ios::out);

        std::string loops_name = LogDirName.getValue().empty() ?
                           "loops" :
                           cppsprintf("%s/loops",
                                      LogDirName.getValue().c_str());
        result.open(loops_name.c_str(), std::ios::out);
        nlohmann::json loops;

        // extract file information
        auto it = m.debug_compile_units_begin(), end = m.debug_compile_units_end();
        std::vector< nlohmann::json > units;
        units.reserve( std::distance(it, end) );
        for(;it != end; ++it) {
            llvm::DICompileUnit * unit = *it;
            nlohmann::json debug_info;
            debug_info["directory"] = unit->getDirectory();
            debug_info["file_name"] = unit->getFilename();
            units.push_back( std::move(debug_info) );
        }
        loops["debug"] = units;
        
        std::vector<nlohmann::json> functions;
        for (llvm::Function &f : m) {
            auto res = runOnFunction(f);
            if(res)
                functions.push_back(res.getValue());
        }
        loops["functions"] = functions;
        result << loops.dump(2) << '\n';
        log.close();
        result.close();

        return false;
    }

    llvm::Optional<nlohmann::json> ExtraPExtractorPass::runOnFunction(llvm::Function &f)
    {
        if (!f.isDeclaration()) {
            nlohmann::json function;
            llvm::DISubprogram * debug = f.getSubprogram();
            function["name"] = debug->getName();
            function["line"] = debug->getLine();

            llvm::LoopInfo &LI = getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
            llvm::ScalarEvolution &SE = getAnalysis<llvm::ScalarEvolutionWrapperPass>(f).getSE();
            polly::PolySCEV &SCEV = getAnalysis<polly::PolySCEV>(f);
            llvm::ModuleSlotTracker MST(f.getParent());
            isl_printer * printer = isl_printer_to_str( SCEV.getCtx().get() );

            std::vector< nlohmann::json > loops;
            for(llvm::Loop * l : LI) {
             
                nlohmann::json loop;
                loop["line_number"] = l->getStartLoc().getLine();
                bool computable = false; 
                if( !SE.hasLoopInvariantBackedgeTakenCount(l)) {
                    const llvm::SCEV * count = SE.getBackedgeTakenCount(l);
                    if(count->getSCEVType() != llvm::scCouldNotCompute) {
                        computable = true;
                        std::string str; 
                        llvm::raw_string_ostream str_stream(str);
                        // TODO: dependency info
                        str_stream << *count;
                        loop["iterations"] = str_stream.str();
                    }
                } else {
                    polly::BasicBlockInfo bbi = SCEV.getYamlBB(*l->getHeader(), l->getLoopDepth(), &f.getEntryBlock(), true, MST);
                    if( isl_set_is_bounded(bbi.Domain.get()) && !isl_set_is_empty(bbi.Domain.get()) ) {
                        isl_printer_print_set(printer, bbi.Domain.get());
                        isl_printer_flush(printer);
                        isl_pw_qpolynomial * poly = isl_set_card(bbi.Domain.copy());
                        isl_printer_print_pw_qpolynomial(printer, poly);
                        isl_pw_qpolynomial_free(poly);
                        char *ptr = isl_printer_get_str(printer);
                        loop["iterations"] = std::string(ptr);
                        free(ptr);
                    }
                }
                loops.push_back(loop);
            }
            function["loops"] = loops;
            isl_printer_free(printer);
            return function;
        }
        return llvm::Optional<nlohmann::json>();
    }

}

char ExtraPExtractorPass::ID = 0;
static llvm::RegisterPass<ExtraPExtractorPass> register_pass(
    "extrap-extractor",
    "Extract loop information",
    true /* Only looks at CFG */,
    true /* Analysis Pass */);

// Allow running dynamically through frontend such as Clang
void addLoopExtractor(const llvm::PassManagerBuilder &Builder,
                        llvm::legacy::PassManagerBase &PM) {
  PM.add(new ExtraPExtractorPass());
}

// run after optimizations
llvm::RegisterStandardPasses SOpt(llvm::PassManagerBuilder::EP_OptimizerLast,
                            addLoopExtractor);

