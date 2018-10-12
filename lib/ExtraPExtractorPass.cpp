
#include "ExtraPExtractorPass.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/IntrinsicInst.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

#include <polly/PolySCEV.h>
#include <barvinok/isl.h>

#include <iostream>
#include <vector>
#include <string>
#include <tuple>
#include <algorithm>

static llvm::cl::opt<std::string> LogFileName("extrap-extractor-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("extrap-extractor-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

namespace {

    struct Dependency
    {
        virtual ~Dependency() {}
        virtual void json(nlohmann::json &) const = 0;
    };

    struct FunctionArg : Dependency
    {
        int pos;

        FunctionArg(int _pos): pos(_pos) {}

        void json(nlohmann::json & j) const override
        {
            j = nlohmann::json{{"type", "arg"}, {"pos", pos}};
        }
    };

    void to_json(nlohmann::json& j, const Dependency * p)
    {
        p->json(j);
    }
    

    struct DependencyFinder
    {
        std::unordered_map<std::string, Dependency*> dependencies;

        ~DependencyFinder()
        {
            std::for_each(dependencies.begin(), dependencies.end(), [](auto & obj) { delete obj.second; });
        }

        void find(const llvm::Argument * arg)
        {
            llvm::DISubprogram * prog = arg->getParent()->getSubprogram();
            bool found = false;
            std::string name;
            for(llvm::DINode * dbg_info : prog->getRetainedNodes()) {
                if(llvm::DILocalVariable * var = llvm::dyn_cast<llvm::DILocalVariable>(dbg_info)) {
                    // is arg?
                    if(var->getArg() - 1 == arg->getArgNo()) {
                        name = var->getName();
                        found = true;
                        break;
                    }
                }
            }
            //TODO: error
            if(!found)
                name = arg->getName();
            //for(auto it = llvm::inst_begin(arg->getParent()), end = llvm::inst_end(arg->getParent()); it != end; ++it) {
            //    if(const llvm::DbgDeclareInst * inst = llvm::dyn_cast<llvm::DbgDeclareInst>(&(*it))) {
            //        if(arg == inst->getAddress()) { 
            //            name = inst->getVariable()->getName();
            //        }
            //    }
            //    if(const llvm::DbgValueInst * inst = llvm::dyn_cast<llvm::DbgValueInst>(&(*it))) {
            //        if(arg == inst->getValue()) {
            //            name = inst->getVariable()->getName();
            //        }
            //    }
            //}
            name = cppsprintf("%s;arg;%u", name, arg->getArgNo());
            if(dependencies.find(name) == dependencies.end())
                dependencies[name] = new FunctionArg(arg->getArgNo());
        }

        void find(llvm::Value * v)
        {
            if(const llvm::Argument * a = llvm::dyn_cast<llvm::Argument>(v))
                find(a);
        }
    };

    struct ScalarEvolutionVisitor
    {
        DependencyFinder dep;

        void call(const llvm::SCEVNAryExpr * scev)
        {
            for(int i = 0; i < scev->getNumOperands(); ++i)
               call( scev->getOperand(i) ); 
        }
        
        void call(const llvm::SCEVUDivExpr * scev)
        {
            call(scev->getLHS());
            call(scev->getRHS());
        }
   
        void call(const llvm::SCEV * scev)
        {
            switch(scev->getSCEVType()) {
                case llvm::scConstant:
                    break;
                case llvm::scTruncate:
                case llvm::scZeroExtend:
                case llvm::scSignExtend:
                    call(llvm::cast<llvm::SCEVCastExpr>(scev)->getOperand());
                    break;
                case llvm::scAddRecExpr:
                case llvm::scMulExpr:
                case llvm::scAddExpr:
                case llvm::scSMaxExpr:
                case llvm::scUMaxExpr:
                    call(llvm::cast<llvm::SCEVNAryExpr>(scev));
                    break;
                case llvm::scUDivExpr:
                    call(llvm::cast<llvm::SCEVUDivExpr>(scev));
                    break;
                case llvm::scUnknown:
                    dep.find(llvm::cast<llvm::SCEVUnknown>(scev)->getValue());
                    break;
                default:
                    llvm_unreachable( cppsprintf("Unhandled case %d!\n", scev->getSCEVType()).c_str() );
            }
        }

    };

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
            ScalarEvolutionVisitor vis;
            for(llvm::Loop * l : LI) {
             
                nlohmann::json loop;
                loop["line_number"] = l->getStartLoc().getLine();
                bool computable = false; 
                if( SE.hasLoopInvariantBackedgeTakenCount(l)) {
                    const llvm::SCEV * count = SE.getBackedgeTakenCount(l);
                    if(count->getSCEVType() != llvm::scCouldNotCompute
                            && count->getSCEVType() != llvm::scUnknown) {
                        computable = true;
                        std::string str; 
                        llvm::raw_string_ostream str_stream(str);
                        str_stream << *count;
                        loop["iterations"] = str_stream.str();

                        vis.call(count);
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
            function["dependencies"] = vis.dep.dependencies;
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

