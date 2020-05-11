
#include <perf-taint/llvm-pass/PerfTaintPass.hpp>

#include <perf-taint/llvm-pass/AnnotationAnalyzer.hpp>
#include <perf-taint/llvm-pass/DebugInfo.hpp>
#include <perf-taint/llvm-pass/Function.hpp>
#include <perf-taint/llvm-pass/FunctionDatabase.hpp>
#include <perf-taint/llvm-pass/Instrumenter.hpp>
#include <perf-taint/llvm-pass/ParameterFinder.hpp>
#include <perf-taint/util/util.hpp>

#include <llvm/Analysis/CallGraph.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/CommandLine.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>
#include <llvm/Transforms/Utils/Cloning.h>

#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>
#include <string>
#include <fstream>
#include <cstdio>

static llvm::cl::opt<std::string> LogFileName("perf-taint-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("perf-taint-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> OutputFileName("perf-taint-out-name",
                                       llvm::cl::desc("Specify name for output file."),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> FunctionDatabaseName("perf-taint-func-database",
                                       llvm::cl::desc("Input database with functions."),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> PassStatsFile("perf-taint-pass-stats",
                                       llvm::cl::desc("Input database with functions."),
                                       llvm::cl::init("perf-taint-pass.json"),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<bool> EnableSCEV("perf-taint-scev",
                                       llvm::cl::desc("Enable LLVM Scalar Evolution"),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> GenerateStats("perf-taint-export-stats",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("filename"));

namespace perf_taint {

    std::set<Parameters::id_t> LabelAnnotator::annotated_params;

    void DfsanInstr::getAnalysisUsage(llvm::AnalysisUsage &AU) const
    {
      ModulePass::getAnalysisUsage(AU);
      // We require loop information
      AU.addRequired<llvm::LoopInfoWrapperPass>();
      if(EnableSCEV)
          AU.addRequiredTransitive<llvm::ScalarEvolutionWrapperPass>();
      // Pass does not modify the input information
      AU.addRequired<llvm::CallGraphWrapperPass>();
      AU.setPreservesAll();
    }

    bool DfsanInstr::runOnModule(llvm::Module &m)
    {
      {
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        //PM.add(llvm::createMetaRenamerPass());
        PM.add(llvm::createCorrelatedValuePropagationPass());
        // mem2reg pass
        PM.add(llvm::createPromoteMemoryToRegisterPass());
        //PM.add(llvm::createDemoteRegisterToMemoryPass());
        // loop-simplify
        PM.add(llvm::createLoopSimplifyPass());
        PM.run(m);
      }


      // Since neither m.getName() or m.getSourceFileName provides a meaningful name
      // We rely on the user to supply an additional log name.

      std::string name = LogDirName.getValue().empty() ?
                         "results" :
                         cppsprintf("%s/results", LogDirName.getValue().c_str());
      log.open(
          cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()),
          std::ios::app);
      cgraph = &getAnalysis<llvm::CallGraphWrapperPass>().getCallGraph();
      AnnotationAnalyzer annotations("extrap");
      annotations.findGlobalAnnotations(m,
              [](llvm::GlobalVariable * var) {
                  Parameters::process_param(var->getName(), var);
              });

      if(!FunctionDatabaseName.getValue().empty()) {
          std::ifstream file(FunctionDatabaseName.getValue(), std::ios_base::in);
          database.read(file);
          file.close();
      }
      Instrumenter instr(*this, m, OutputFileName.getValue());
      database.setInstrumenter(&instr);

      this->m = &m;
      llvm::Function * main = m.getFunction("main");
      assert(main);
      // TODO: why is main treated differently?
      // why is main not inserted?
      bool is_important = runOnFunction(*main);
      instr.initialize(main);
      for(llvm::Function & f : m)
        instr.initialize_MPI(&f);
      for(llvm::Function & f : m)
      {
        if(instrumented_functions.find(&f) == instrumented_functions.end()) {
          runOnFunction(f);
        }
      }

      // TODO: merge this into a single collection
      // Copy to vector and sort to ensure that we get a deterministic order
      // of functions and their indices. Otherwise the indices of functions
      // might depend on addresses of functions. While it does not influence
      // the correctness of the algorithm, it makes testing harder.
      typedef std::pair<llvm::Function *, llvm::Optional<Function>> elem_t;
      std::vector<elem_t> elems(
          instrumented_functions.begin(),
          instrumented_functions.end()
      );
      std::sort(elems.begin(), elems.end(),
          [](elem_t & f1, elem_t & f2) {
            return f1.first->getName() < f2.first->getName();
          }
      );
      for(auto & t : elems) {
          // For each unimportant function, add it to a database
          // for callstack generation
          if(t.second.hasValue()) {
              //notinstrumented_functions.push_back(t.first);
              Function & f = t.second.getValue();
              for(auto t : f.implicit_loops) {
                  auto it = implicit_functions.find(t.called_function);
                  if(it == implicit_functions.end()) {
                      implicit_functions[t.called_function] = instrumented_functions_counter++;
                  }
              }
          }
      }

      for(auto & f : instrumented_functions)
      {
          if(f.second) {
              modifyFunction(*f.first, f.second.getValue(), instr);
          }
      }
      instr.createGlobalStorage(parent_functions, database,
              instrumented_functions.begin(), instrumented_functions.end(),
              implicit_functions.begin(), implicit_functions.end(),
              notinstrumented_functions.begin(), notinstrumented_functions.end());
      //instr.annotateParams(found_params);
      size_t params_count = Parameters::globals_names.size() + Parameters::local_names.size();
      // TODO: also change that we dependent on this vector.
      // we should have all functions - not important, instrumented - in same data structure
      // TODO: why the hell is it parent_functions?
      //int idx = parent_functions.size();
      int idx = instrumented_functions_counter;
      for(auto * f : notinstrumented_functions) {
          instr.enterFunction(*f, idx++);
      }
      // instrument callstack

      stats.print(PassStatsFile);

      return false;
    }

    bool DfsanInstr::handleOpenMP(llvm::Function & f, int override_counter)
    {
        bool openmp_call = false;
        for(llvm::BasicBlock & bb: f)
            for(llvm::Instruction & instr : bb)
                if(llvm::CallInst * call
                        = llvm::dyn_cast<llvm::CallInst>(&instr)) {
                    if(call->getCalledFunction() &&
                            call->getCalledFunction()->getName() == "__kmpc_fork_call") {
                        llvm::ConstantExpr * cast =
                            llvm::dyn_cast<llvm::ConstantExpr>(call->getOperand(2));
                        assert(cast);
                        llvm::Function * func =
                            llvm::dyn_cast<llvm::Function>(cast->getOperand(0));
                        assert(func);
                        //insert call with the same counter
                        //don't insert into names vector, that's for the parent function
                        int counter = override_counter != -1 ?
                            override_counter : instrumented_functions_counter;
                        //instrumented_functions.insert(
                        //        std::make_pair(func, counter)
                        //    );
                        openmp_call = true;
                        llvm::errs() << "Detected OpenMP call " << f.getName() << " " << call->getCalledFunction()->getName() << ' ' << func->getName() << '\n';
                        //handle additional calls
                        //OpenMP can split for loop functions into additional
                        //calls e.g. omp.outlined and omp.outlined._debug
                        runOnFunction(*func, counter);
                    } else if(!call->getCalledFunction()) {
                        unknown << "Unknown call: ";
                        std::string str;
                        llvm::raw_string_ostream os(str);
                        os << *call;
                        os << ' ';
                        os << *call->getFunctionType();
                        unknown << os.str() << '\n';
                    }
                }
        return openmp_call;
    }

    void DfsanInstr::foundFunction(llvm::Function &f, bool important, int counter)
    {
        auto it = instrumented_functions.find(&f);
        assert(it == instrumented_functions.end());
        if(important) {
            bool overriden = true;
            if(counter == -1) {
                // when overriding, only the parent function matters
                // don't insert name in such case
                parent_functions.push_back(&f);
                // when not overriding, get the current counter and update
                counter = instrumented_functions_counter;
                instrumented_functions_counter++;
                overriden = false;
            }
            instrumented_functions[&f] =
                llvm::Optional<Function>(Function(counter, f.getName(), overriden));
        } else {
            // Insert information that function is overriden by a parent
            if(counter != -1) {
                instrumented_functions[&f] =
                    llvm::Optional<Function>(Function(counter, f.getName(), true));
            }
            // Insert information that function is processed and unimportant
            else {
                instrumented_functions[&f] = llvm::Optional<Function>();
                notinstrumented_functions.push_back(&f);
            }
        }
    }

    void DfsanInstr::insertCallsite(llvm::Function & f, llvm::Value * val)
    {
        auto it = instrumented_functions.find(&f);
        if( (*it).second.hasValue() )
            (*it).second->add_callsite(val);
    }

    bool DfsanInstr::analyzeFunction(llvm::Function & f,
            llvm::CallGraphNode * cg_node, int override_counter)
    {
        linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        assert(linfo);
        llvm::errs() << f.getName() << ' ' << std::distance(linfo->begin(), linfo->end()) << '\n';
        // TODO: replace with a database
        bool has_openmp_calls = handleOpenMP(f, override_counter);

        typedef std::tuple<llvm::Function*, llvm::Value*> vec_entry_t;
        llvm::SmallVector<vec_entry_t, 5> library_calls;
        bool has_important_call = false;
        for(auto & callsite : *cg_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            if(called_f && database.contains(called_f)) {
               has_important_call = true;
               library_calls.emplace_back(called_f, call);
            }
            if(called_f)
              database.annotateParameters(called_f, call);
        }

        int loop_count = 0;
        // Count if SCEV helped with pruning some loops or scev helped
        // with prunning all loops.
        int scev_analyzed_constant = 0;
        int scev_analyzed_nonconstant = 0;
        bool has_nonconstant_loop = false;
        const std::string & function_name = f.getName();

        std::vector<Loop> loops; 
        for(llvm::Loop * l : *linfo) {
          loops.emplace_back(f, l);
          loop_count += loops.back().loops_count();
        }
        if(EnableSCEV) {
          llvm::ScalarEvolution & scev
            = getAnalysis<llvm::ScalarEvolutionWrapperPass>(f).getSE();
          for(Loop & loop : loops) {
            loop.analyzeSCEV(scev);
            scev_analyzed_constant += loop.scev_constant();
            scev_analyzed_nonconstant += loop.scev_nonconstant();
            has_nonconstant_loop |= !loop.is_constant();
          }
          stats.function_statistics(function_name, "loops",
              "scev_analyzed_constant", scev_analyzed_constant);
          stats.function_statistics(function_name, "loops",
              "scev_analyzed_nonconstant", scev_analyzed_nonconstant);
        }
        // if no static analysis information is provided,
        // then we have to assume that any loop is non-constant
        else
          has_nonconstant_loop = loops.size();
        stats.function_statistics(function_name, "loops", "count", loop_count);

        // Worth instrumenting
        // FIXME: still instrument if SCEV discovered constant loops to ensure
        // that function indices don't change
        if(has_nonconstant_loop || (!has_nonconstant_loop && scev_analyzed_constant > 0) || has_openmp_calls || has_important_call) {

            foundFunction(f, true, override_counter);
            Function & func = instrumented_functions[&f].getValue();

            //for(Loop & loop : loops) {
            //  LoopStructure analyzed_loop = loop.analyze();
            //  std::copy(
            //      analyzed_loop.structure.begin(),
            //      analyzed_loop.structure.end(),
            //      std::back_inserter(func.loops_structures)
            //  );
            //  func.loops_sizes.push_back(analyzed_loop.depth);
            //  func.loops_sizes.push_back(analyzed_loop.structure.size());
            //  func.loops_sizes.push_back(analyzed_loop.loops_count);
            //}
            func.loops = std::move(loops);

            //int implicit_loops = 0;
            for(auto t : library_calls) {
              database.processLoop(
                std::get<0>(t), std::get<1>(t), func
              );
            }
            stats.function_statistics(function_name, "loops",
                "implicit", library_calls.size());

            if(has_nonconstant_loop)
              stats.instrumented_function(f.getName(), "loops");
            //FIXME: same as above
            if(!has_nonconstant_loop && scev_analyzed_constant > 0)
              stats.pruned_function(function_name, "scev");
            if(has_openmp_calls)
              stats.instrumented_function(f.getName(), "openmp_calls");
            // TODO: per-library discovery
            if(has_important_call)
              stats.instrumented_function(f.getName(), "important_call");
            return true;
        } else {
            //TODO: debug
            llvm::errs() << "Not instrumenting function: " << f.getName() << '\n';
            // We had some loops and found out they're constant
            if(loop_count > 0 && loop_count == scev_analyzed_constant)
              stats.pruned_function(function_name, "scev");
            else
              stats.pruned_function(function_name, "no_performance_critical_code");
            foundFunction(f, false, override_counter);
            return false;
        }
    }

    bool DfsanInstr::runOnFunction(llvm::Function & f, int override_counter)
    {
        // ignore declarations
        // TODO: handle instrumentation of unknown functions
        if(!is_analyzable(*m, f))
            return false;
        auto it = instrumented_functions.find(&f);
        if(it != instrumented_functions.end())
            return (*it).second.hasValue();
        //TODO: debug
        llvm::errs() << "Analyzing function: " << f.getName() << '\n';
        stats.found_function(f.getName());
        llvm::CallGraphNode * f_node = (*cgraph)[&f];
        ParameterFinder finder(f);
        FunctionParameters parameters = finder.find_args();
        for(auto & param : parameters.locals) {
            found_params.push_back(param);
        }
        bool is_important = analyzeFunction(f, f_node, override_counter);
        llvm::errs() << "Function: " << f.getName() << " is important: " << is_important << '\n';
        for(auto & callsite : *f_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            // For some reason I keep seeing nullptr here
            if(called_f) {
                // it's important if at least one of subfunctions is important
                bool f_important = runOnFunction(*called_f, override_counter);
                if(f_important) {
                    insertCallsite(*called_f, call);
                    is_important = true;
                }
            }
        }
        return is_important;
    }


    bool DfsanInstr::callsImportantFunction(llvm::Function * called_f,
            std::set<llvm::Function*> & recursive_calls)
    {
        if(!called_f)
            return true;
        // Don't instrument functions without definition
        // We can't track them anyway.
        if(called_f->isDeclaration()) {
            calls_important[called_f] = false;
            return false;
        }
        // Is it a recursive call? Then don't instrument.
        //if(recursive_calls.count(called_f)) {
        //    calls_important[called_f] = false;
        //    recursive_functions.insert(called_f);
        //    return false;
        //}
        auto it = calls_important.find(called_f);
        if(it != calls_important.end())
            return (*it).second;
        llvm::CallGraphNode * f_node = (*cgraph)[called_f];
        assert(f_node);
        auto func_it = instrumented_functions.find(called_f);
        // the function itself is already known to be important
        if(func_it != instrumented_functions.end()
                && (*func_it).second.hasValue())
        {
            //calls_important[called_f] = true;
            return true;
        }

        bool important = false;
        for(auto & callsite : *f_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * new_called_f = node->getFunction();
            // write down this function to detect recursive calls
            // if it happens, it's important
            // TODO: probelms in recursive functions
            //calls_important[called_f] = true;
            recursive_calls.insert(new_called_f);
            important |= new_called_f ?
                callsImportantFunction(new_called_f, recursive_calls) :
                true;
            recursive_calls.erase(recursive_calls.find(new_called_f));
            if(important)
                break;
        }
        calls_important[called_f] = important;
        return important;
    }

    bool DfsanInstr::callsImportantFunction(const llvm::CallBase * base)
    {
      std::set<llvm::Function*> recursive_calls;
      llvm::Function * called_f = base->getCalledFunction();
      if(called_f)
        return callsImportantFunction(called_f, recursive_calls);
      // unknown function - most likely a call/invoke of a pointer
      // overapproximation, assume yes -
      else
        return true;
    }

    void DfsanInstr::modifyFunction(llvm::Function & f, Function & func,
            Instrumenter & instr)
    {
      linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
      assert(linfo);

      //TODO: debug
      if(!func.is_overriden()){
        std::set<const llvm::BasicBlock*> loop_blocks;
        int loop_idx = 0, nested_loop_idx = 0;
        FunctionCalls calls;

        for(Loop & loop : func.loops) {
          for(const llvm::BasicBlock * bb : loop.loop().blocks())
            loop_blocks.insert(bb);
        }
        for(Loop & loop : func.loops) {
          LoopStructure structure = instr.instrumentLoop(func, loop, nested_loop_idx, calls);
          func.loop_structures.push_back(std::move(structure));
          nested_loop_idx += structure.loops_count;
          for(const llvm::BasicBlock * bb : loop.loop().blocks())
            loop_blocks.insert(bb);
          //nested_loop_idx += func.loops_sizes[3*loop_idx + 2];
          loop_idx++;
        }

        int loop_idx_implicit = loop_idx, nested_loop_idx_implicit = nested_loop_idx;
        // FIXME: register calls to catch implicit functions.
        for(auto implicit_call : func.implicit_loops) {
          calls.calls.emplace_back(implicit_call.call, -1, loop_idx);
          loop_idx++;
          //TODO: implicit calls
          //nested_loop_idx += func.loops_sizes[3*loop_idx + 2];
          //TODO: remove after moving implicit calls to proper class
          func.loop_structures.push_back(implicit_call.structure);
          nested_loop_idx += implicit_call.structure.loops_count;
        }

        // Now find calls outside of the loop
        for(llvm::BasicBlock & bb : f) {
          if(loop_blocks.count(&bb))
             continue;
          for(llvm::Instruction & instr : bb) {
            if(llvm::CallBase * call =
                  llvm::dyn_cast<llvm::CallBase>(&instr)) {
              // add one more potential loop
              if(callsImportantFunction(call))
                calls.calls.emplace_back(call, -1, loop_idx++);
            }
          }
        }

        llvm::Instruction * place = nullptr;
        for(auto & v : calls.calls)
        {
          place = instr.instrumentLoopCall(f, v.call, v.nested_loop_idx,
                v.loop_idx, place ? place->getNextNode() : place);
        }

        // Handle implicit calls
        for(auto implicit_call : func.implicit_loops) {

          instr.callImplicitLoop(
            implicit_call,
            func.function_idx(),
            implicit_functions.at(implicit_call.called_function),
            loop_idx_implicit,
            nested_loop_idx_implicit
          );
          loop_idx_implicit++;
          //TODO: as above
          //nested_loop_idx_implicit += func.loops_sizes[3*loop_idx_implicit + 2];
        }

        // Leaving order:
        // 1) revert previous registered call
        // 2) commit loops
        // 3) remove registered calls
        // 4) pop the function from callstack
        if(calls.size())
            instr.saveCurrentCall(f);
        instr.commitLoops(f, func.function_idx(), calls.size());
        if(calls.size())
            instr.removeLoopCalls(f, calls.size());
      } else {
          instr.commitLoops(f, func.function_idx(), 0);
      }
      // don't add overidden functions to callstack
      if(!func.is_overriden())
          instr.enterFunction(f, func);

      //int labels = 0;
      //for(auto i = llvm::inst_begin(&f), end = llvm::inst_end(&f); i != end; ++i)
      //{
      //    if(llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(&*i)) {
      //        if(br->isConditional()) {
      //            // is this a part of a loop?
      //            // insert the check for labels
      //            instr.checkCF(func.function_idx(), br);
      //            labels++;
      //        }
      //    }
      //}

      int idx = 0;
      for(llvm::Value * callsite : func.callsites) {
          llvm::Instruction * s = llvm::dyn_cast<llvm::Instruction>(callsite);
          llvm::CallBase * call = llvm::dyn_cast<llvm::CallBase>(s);
          assert(call);
          //instr.checkCall(func.function_idx(), idx++, call);
      }

      //stats.label_function(labels);
    }

    bool DfsanInstr::is_analyzable(llvm::Module & m, llvm::Function & f)
    {
        llvm::Function * in_module = m.getFunction(f.getName());
        if(f.isDeclaration() || !in_module) {
            unknown << f.getName().str() << '\n';
            //LLVM_DEBUG(dbgs() << "Not analyzable: " << f.getName() << '\n');
            llvm::errs() << "Not analyzable: " << f.getName() << '\n';
            return false;
        }
        //LLVM_DEBUG(dbgs() << "Analyzable: " << f.getName() << '\n');
        llvm::errs() << "Analyzable: " << f.getName() << '\n';
        return true;
    }

}

char perf_taint::DfsanInstr::ID = 0;
static llvm::RegisterPass<perf_taint::DfsanInstr> register_pass(
  "perf-taint",
  "Apply taint-based loop modeling",
  true /* Only looks at CFG */,
  false /* Analysis Pass */
);

// Allow running dynamically through frontend such as Clang
void addDfsanInstr(const llvm::PassManagerBuilder &Builder,
                        llvm::legacy::PassManagerBase &PM) {
  PM.add(new perf_taint::DfsanInstr());
}

// run after optimizations
llvm::RegisterStandardPasses SOpt(llvm::PassManagerBuilder::EP_OptimizerLast,
                            addDfsanInstr);

