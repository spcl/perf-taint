
#include "ExtraPExtractorPass.hpp"
#include "ScalarEvolutionVisitor.hpp"
#include "PollyVisitor.hpp"
#include "FunctionAnalysis.hpp"
#include "DependencyFinder.hpp"
#include "JSONExporter.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/ModuleSlotTracker.h>
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

static llvm::cl::opt<std::string> LogFileName("extrap-extractor-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("extrap-extractor-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<bool> EnableSCEV("extrap-extractor-scev",
                                       llvm::cl::desc("Enable LLVM Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> EnablePollySCEV("extrap-extractor-polly-scev",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> EnableManualDeps("extrap-extractor-man-deps",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> EnableJSONOutput("extrap-extractor-json-output",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<std::string> JSONOutputToFile("extrap-extractor-json-output-file",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("boolean flag"));

namespace {

    void Statistics::processed_function(bool undef)
    {
        ++functions_count;
        understood_functions += undef;
    }

    std::string to_string(const llvm::SCEV * scev)
    {
        std::string str; 
        llvm::raw_string_ostream str_stream(str);
        str_stream << *scev;
        str_stream.flush();
        return str;
    }

    ExtraPExtractorPass::~ExtraPExtractorPass()
    {
    }

    void ExtraPExtractorPass::getAnalysisUsage(llvm::AnalysisUsage &AU) const
    {
        ModulePass::getAnalysisUsage(AU);
        // We require loop information
        AU.addRequiredTransitive<llvm::LoopInfoWrapperPass>();
        if(EnableSCEV)
            AU.addRequiredTransitive<llvm::ScalarEvolutionWrapperPass>();
        if(EnablePollySCEV)
            AU.addRequired<polly::PolySCEV>();
        // Pass does not modify the input information
        AU.addRequired<llvm::CallGraphWrapperPass>();
        AU.setPreservesAll();
    }

    bool ExtraPExtractorPass::runOnModule(llvm::Module &m)
    {
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        //PM.add(llvm::createMetaRenamerPass());
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
            std::ios::app);
        nlohmann::json loops;
        extrap::JSONExporter exporter(m);
 
        std::vector<nlohmann::json> functions;
        llvm::CallGraph & cgraph = getAnalysis<llvm::CallGraphWrapperPass>().getCallGraph();
        extrap::FunctionAnalysis analysis(cgraph, m, exporter);
        extrap::Parameters params;
        //std::vector< std::string > param_names{"grid_points"};
        std::vector< std::string > param_names{"global", "global2"};
        params.find_globals(m, param_names);
        assert(param_names.empty());
        std::vector< std::string > param_names2{}; //"x1", "x2"};
        analysis.analyze_main(params, param_names2);
        //llvm::Function * main = nullptr;
        //for (llvm::Function &f : m) {
            //auto res = runOnFunction(f);
            //if(res)
            //functions.push_back(res.getValue());
        //if(f.getName() == "main")
        //        main = &f;
        //}
        //loops["functions"] = functions;
        if(EnableJSONOutput) {
            if(JSONOutputToFile != "") {
                std::ofstream json(JSONOutputToFile.getValue().c_str(),
                        std::ios::out);
                exporter.print(json);
                json.close();
            } else
                exporter.print(llvm::outs());
        }
        stats.dump(log);
        log.close();


        return false;
    }

    llvm::Optional<nlohmann::json> ExtraPExtractorPass::runOnFunction(llvm::Function &f)
    {
        if (f.isDeclaration())
            return llvm::Optional<nlohmann::json>();
        assert(debug);
        extrap::DependencyFinder dep;

        llvm::LoopInfo &LI = getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        if(EnableSCEV)
            SE = &getAnalysis<llvm::ScalarEvolutionWrapperPass>(f).getSE();
        if(EnablePollySCEV) {
            SCEV = &getAnalysis<polly::PolySCEV>(f);
            isl_print = isl_printer_to_str( SCEV->getCtx().get() );
        }
        llvm::ModuleSlotTracker MST(f.getParent());

        std::vector< nlohmann::json > loops;
        extrap::ScalarEvolutionVisitor vis{dep};
        extrap::PollyVisitor polly_vis{dep, *SCEV};
       
         
        /*bool everything_defined = true;
        for(llvm::Loop * l : LI) {
         
            nlohmann::json loop;
            llvm::DebugLoc start_loc = l->getStartLoc();
            if(start_loc)
                loop["line_number"] = start_loc.getLine();
            if( !compute_scev(l, vis, loop) ) {
                if( !compute_polly_scev(l, f, MST, polly_vis, loop) ) {               
                    loop = "undef";
                    everything_defined = false;
                    manual_dependencies(l, dep, loop);
                }
            }
            loops.push_back(loop);
        }
        function["loops"] = loops;
        function["dependencies"] = dep.dependencies;
        function["have_undefs"] = !everything_defined;*/
        //stats.processed_function(everything_defined);
        if(EnablePollySCEV) {
            isl_printer_free(isl_print);
        }
        //return function;
    }

    // TODO: rework after changing dependeny cinder
    bool ExtraPExtractorPass::manual_dependencies(llvm::Loop * l, extrap::DependencyFinder & dep,
            nlohmann::json & result)
    {
        if(EnableManualDeps) {
            // just process exit block?
            typedef std::pair< const llvm::BasicBlock*, const llvm::BasicBlock*> Edge;
            llvm::SmallVector<Edge, 4> exit_blocks;
            l->getExitEdges(exit_blocks);
            bool understood = true;
            for(Edge edge : exit_blocks) {
                //for(llvm::Instruction & instr : bb->instructionsWithoutDebug()) {
                    //llvm::outs() << instr << '\n';
                    //dep.find(&instr); 
                //}
                //llvm::outs() << *bb->getTerminator() << '\n';
                //llvm::outs() << llvm::dyn_cast<llvm::BranchInst>(bb->getTerminator()) << '\n';
                //dep.find( bb->getTerminator() );
                //llvm::outs() << *edge.first<< '\n';
                //understood &= dep.find( edge.first->getTerminator() );
            }
            return understood;
        }
        return false;
    }

    bool ExtraPExtractorPass::compute_scev(llvm::Loop * l, extrap::ScalarEvolutionVisitor & vis,
            nlohmann::json & result)
    {
        //llvm::outs() << SE << ' ' << EnableSCEV << '\n';
        //llvm::outs() << *l << '\n';
        //llvm::outs() << SE->hasLoopInvariantBackedgeTakenCount(l) << '\n';
        if( SE && l->getLoopDepth() == 1 && SE->hasLoopInvariantBackedgeTakenCount(l)) {
            const llvm::SCEV * count = SE->getBackedgeTakenCount(l);
            if( vis.is_computable(count) ) {
                result["iterations"] = to_string(count);
                if( vis.call(count) )
                    return true;
                else
                    return false;
            }
            return false;
        }
        return false;
    }
    
    bool ExtraPExtractorPass::compute_polly_scev(llvm::Loop * l, llvm::Function & f,
            llvm::ModuleSlotTracker & MST, extrap::PollyVisitor & vis, nlohmann::json & result)
    {
        if(!SCEV)
            return false;
        polly::BasicBlockInfo bbi = SCEV->getYamlBB(*l->getHeader(), l->getLoopDepth(),
                &f.getEntryBlock(), true, MST);
        if( vis.is_computable(bbi.Domain) ) {
            bool understood = vis.call(bbi.Domain);
            isl_printer_print_set(isl_print, bbi.Domain.get());
            isl_printer_flush(isl_print);
            isl_pw_qpolynomial * poly = isl_set_card(bbi.Domain.copy());
            isl_printer_print_pw_qpolynomial(isl_print, poly);
            isl_pw_qpolynomial_free(poly);
            char *ptr = isl_printer_get_str(isl_print);
            result["iterations"] = std::string(ptr);
            if(!understood) {
                log << "Loop at file: " << result["name"] << " line: " << result["line_number"];
                log << " unrecognized Polly domain: " << ptr << '\n';
            }
            free(ptr);
            return understood;
        }
        return false;
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

