
#include <dfsan-instr/DfsanInstr.hpp>
#include <dfsan-instr/Function.hpp>
#include <dfsan-instr/FunctionDatabase.hpp>
#include "AnnotationAnalyzer.hpp"
#include "DebugInfo.hpp"
#include "ParameterFinder.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/Analysis/ScalarEvolutionExpressions.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Support/Debug.h>
#include <llvm/Support/raw_ostream.h>
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
#include <cxxabi.h>
#include <cstdio>

static llvm::cl::opt<std::string> LogFileName("extrap-extractor-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("extrap-extractor-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> OutputFileName("extrap-extractor-out-name",
                                       llvm::cl::desc("Specify name for output file."),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> FunctionDatabaseName("extrap-extractor-func-database",
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

static llvm::cl::opt<std::string> JSONOutputToFile("extrap-extractor-json-output-file",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> GenerateStats("extrap-extractor-export-stats",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("filename"));

namespace extrap {

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
      if(EnableSCEV) {
        analyzed_module = llvm::CloneModule(m);
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        //PM.add(llvm::createMetaRenamerPass());
        PM.add(llvm::createCorrelatedValuePropagationPass());
        // mem2reg pass
        PM.add(llvm::createPromoteMemoryToRegisterPass());
        // loop-simplify
        PM.add(llvm::createLoopSimplifyPass());
        PM.run(*analyzed_module);
      }
      {
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        //PM.add(llvm::createMetaRenamerPass());
        PM.add(llvm::createCorrelatedValuePropagationPass());
        // mem2reg pass
        //PM.add(llvm::createPromoteMemoryToRegisterPass());
        PM.add(llvm::createDemoteRegisterToMemoryPass());
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
        Instrumenter instr(m);
        database.setInstrumenter(&instr);

        this->m = &m;
        llvm::Function * main = m.getFunction("main");
        assert(main);
        // TODO: why is main treated differently?
        // why is main not inserted?
        bool is_important = runOnFunction(*main);
        for(llvm::Function & f : m)
        {
            if(instrumented_functions.find(&f) == instrumented_functions.end())
                runOnFunction(f);
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
                    auto it = implicit_functions.find(std::get<1>(t));
                    if(it == implicit_functions.end()) {
                        implicit_functions[std::get<1>(t)] = instrumented_functions_counter++;
                    }
                }
            }
        }

        instr.createGlobalStorage(parent_functions, database,
                instrumented_functions.begin(), instrumented_functions.end(),
                implicit_functions.begin(), implicit_functions.end(),
                notinstrumented_functions.begin(), notinstrumented_functions.end());
        instr.initialize(main);
        //instr.annotateParams(found_params);
        size_t params_count = Parameters::globals_names.size() + Parameters::local_names.size();
        for(auto & f : instrumented_functions)
        {
            if(f.second) {
                modifyFunction(*f.first, f.second.getValue(), instr);
            }
        }
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

    int DfsanInstr::analyzeLoop(Function & f, llvm::Loop & l,
            std::vector<std::vector<int>> & data, int depth)
    {
        auto & subloops = l.getSubLoops();
        if(depth < data.size())
            data[depth].push_back(subloops.size());
        else {
            data.emplace_back(1, subloops.size());
        }
        int loop_count = subloops.size();
        for(llvm::Loop * l : subloops) {
            loop_count += analyzeLoop(f, *l, data, depth + 1);
        }
        return loop_count;
    }

    bool DfsanInstr::analyzeFunction(llvm::Function & f,
            llvm::CallGraphNode * cg_node, int override_counter)
    {
        linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        assert(linfo);
        llvm::errs() << f.getName() << ' ' << linfo->empty() << '\n';
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
        // with prunning all loops. False if empty since SCEV didn't help at all.
        int scev_analyzed_constant = 0;
        int scev_analyzed_nonconstant = 0;
        bool has_nonconstant_loop = false;
        const std::string & function_name = f.getName();

        if(EnableSCEV) {
          llvm::Function* analyzed_f = (*analyzed_module).getFunction(function_name);

          llvm::ScalarEvolution & scev = getAnalysis<llvm::ScalarEvolutionWrapperPass>(*analyzed_f).getSE();
          // Process loops
          for(llvm::Loop * l : *linfo) {

            ++loop_count;
            if(scev.hasLoopInvariantBackedgeTakenCount(l)) {
              const llvm::SCEV * backedge_count = scev.getBackedgeTakenCount(l);
              // Unknown count? SCEV failed, function is instrumented
              if(isa<llvm::SCEVCouldNotCompute>(backedge_count)) {
                has_nonconstant_loop = true;
              // Non-constant count? SCEV succeeded, function is instrumented
              } else if(!isa<llvm::SCEVConstant>(backedge_count)) {
                has_nonconstant_loop = true;
                ++scev_analyzed_nonconstant;
              // Constant count? SCEV succeeded, function maybe not instrumented
              } else
                ++scev_analyzed_constant;
            // Not known? SCEV failed, function is instrumented
            } else {
              has_nonconstant_loop = true;
            }
          }
          stats.function_statistics(function_name, "loops",
              "scev_analyzed_constant", scev_analyzed_constant);
          stats.function_statistics(function_name, "loops",
              "scev_analyzed_nonconstant", scev_analyzed_nonconstant);
        } else {
          loop_count = std::distance(linfo->begin(), linfo->end());
          has_nonconstant_loop = loop_count;
        }
        stats.function_statistics(function_name, "loops", "count", loop_count);

        // Worth instrumenting
        if(has_nonconstant_loop || has_openmp_calls || has_important_call) {

            foundFunction(f, true, override_counter);
            Function & func = instrumented_functions[&f].getValue();

            // TODO: refactor for general loop interface
            for(llvm::Loop * l : *linfo) {
                std::vector< std::vector<int> > data;
                // count main loop
                int loop_count = analyzeLoop(func, *l, data, 0) + 1;
                int depth = data.size();
                int structure_size = func.loops_structures.size();
                for(auto & vec : data)
                    std::copy(vec.begin(), vec.end(),
                            std::back_inserter(func.loops_structures));
                structure_size = func.loops_structures.size() - structure_size;
                func.loops_sizes.push_back(depth);
                func.loops_sizes.push_back(structure_size);
                func.loops_sizes.push_back(loop_count);
            }

            for(auto t : library_calls) {
                std::vector< std::vector<int> > data;
                database.processLoop(std::get<0>(t), std::get<1>(t), func, data);
                //func.addImplicitLoop(std::get<1>(t), data);
            }

            if(has_nonconstant_loop)
              stats.instrumented_function(f.getName(), "loops");
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

    bool DfsanInstr::callsImportantFunction(llvm::CallBase * base)
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

    void DfsanInstr::instrumentLoop(Function & func, llvm::Loop & l,
            int nested_loop_idx, call_vec_t & calls, Instrumenter & instr)
    {
        typedef std::vector<llvm::Loop*> loops_t;
        loops_t buf_first{1, &l}, buf_second;

        loops_t * cur_loops = &buf_first, * next_loops = &buf_second;
        int internal_nested_index = 0;

        while(!cur_loops->empty()) {

            for(llvm::Loop * l : *cur_loops) {

                llvm::SmallSet<llvm::BasicBlock*, 20> subloops_bb;
                auto & subloops = l->getSubLoops();
                for(llvm::Loop * subloop : subloops) {
                    for(llvm::BasicBlock * bb : subloop->blocks())
                        subloops_bb.insert(bb);
                }

                call_vec_t calls_in_this_loop;
                int calls_count = 0;
                for(llvm::BasicBlock * bb : l->blocks()) {
                    // loop basic block that is not a part of subloop
                    if(!subloops_bb.count(bb)) {
                        for(llvm::Instruction & inst : *bb) {
                            // call!
                            if(llvm::CallBase * call =
                                    llvm::dyn_cast<llvm::CallBase>(&inst)) {
                                if(callsImportantFunction(call)) {
                                        // TODO: optimize by checking if this call could
                                        // produce any loop - in case we know function
                                        calls.emplace_back(call, internal_nested_index,
                                                subloops.size() + calls_count++);
                                }
                            }
                        }
                    }
                }

                llvm::SmallVector<llvm::BasicBlock*, 10> exit_blocks;
                l->getExitingBlocks(exit_blocks);
                for(llvm::BasicBlock * bb : exit_blocks) {
                    const llvm::Instruction * inst = bb->getTerminator();
                    //llvm::errs() << *inst << '\n';
                    const llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(inst);
                    if(br && br->isConditional()) {
                        const llvm::Instruction * inst =
                            llvm::dyn_cast<llvm::Instruction>(br->getCondition());
                        assert(inst);
                        instr.checkLoop(nested_loop_idx, func.function_idx(), inst);
                    } else if(const llvm::SwitchInst * _switch = llvm::dyn_cast<llvm::SwitchInst>(inst)) {
                        const llvm::Instruction * inst =
                            llvm::dyn_cast<llvm::Instruction>(_switch->getCondition());
                        assert(inst);
                        instr.checkLoop(nested_loop_idx, func.function_idx(), inst);
                    } else if(const llvm::InvokeInst * invoke = llvm::dyn_cast<llvm::InvokeInst>(inst)) {
                        // ignore the exception control flow outside of the loop
                        //const llvm::InvokeInst * invoke = llvm::dyn_cast<llvm::InvokeInst>(inst);
                    } else {
                        llvm::errs() << "Unknown branch: " << *inst << '\n';
                    }
                }
                nested_loop_idx++;
                internal_nested_index++;
                std::copy(subloops.begin(), subloops.end(), std::back_inserter(*next_loops));
            }
            std::swap(cur_loops, next_loops);
            next_loops->clear();
        }
    }

    void DfsanInstr::modifyFunction(llvm::Function & f, Function & func,
            Instrumenter & instr)
    {
        linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        llvm::errs() << f.getName() << ' ' << linfo->empty() << '\n';
        assert(linfo);

        //TODO: debug
        llvm::errs() << "Instrumenting function: " << f.getName()
          << " is_overriden: " << func.is_overriden() << '\n';
        if(!func.is_overriden()){
            std::set<llvm::BasicBlock*> loop_blocks;
            int loop_idx = 0, nested_loop_idx = 0;
            call_vec_t calls;
            llvm::errs() << "Instrumenting function: " << f.getName()
              << " loop: " << linfo->empty() << '\n';
            for(llvm::Loop * l : *linfo) {
                llvm::errs() << "Instrumenting function: " << f.getName()
                  << " loop: " << *l << '\n';
                instrumentLoop(func, *l, nested_loop_idx, calls, instr);

                for(auto & call: calls) {
                    //register and set current id before each call
                    //instr.instrumentLoopCall(*l, std::get<0>(call),
                            //std::get<1>(call), std::get<2>(call));
                }
                for(llvm::BasicBlock * bb : l->blocks())
                    loop_blocks.insert(bb);
                nested_loop_idx += func.loops_sizes[3*loop_idx + 2];
                loop_idx++;
            }

            for(auto implicit_call : func.implicit_loops) {

                // TODO: nested calls as well
                // TODO: more parameters
                instr.callImplicitLoop(std::get<0>(implicit_call),
                        func.function_idx(),
                        implicit_functions.at(std::get<1>(implicit_call)),
                        nested_loop_idx,
                        std::get<2>(implicit_call));
                loop_idx++;
                nested_loop_idx += func.loops_sizes[3*loop_idx + 2];
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
                            calls.emplace_back(call, -1, loop_idx++);
                    }
                }
            }

            for(auto & v : calls)
            {
                //llvm::errs() << f.getName() << ' ' << std::get<0>(v)->getCalledFunction()->getName()
                //    << ' ' << std::get<1>(v) << ' ' << std::get<2>(v) << '\n';
                instr.instrumentLoopCall(f, std::get<0>(v), std::get<1>(v),
                        std::get<2>(v));
            }

            // Handle implicit calls

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

    std::string demangle(llvm::StringRef name)
    {
        int status = 0;
        char * demangled_name =
            abi::__cxa_demangle(name.data(), 0, 0, &status);
        std::string str_name; if(status == 0)
            str_name = demangled_name;
        else if(status == -2)
            str_name = name;
        else
            assert(false);
        free( static_cast<void*>(demangled_name) );
        return str_name;
    }

    void Instrumenter::writeParameter(llvm::Instruction * instr,
        llvm::Value * dest, int parameter_idx)
    {
      builder.SetInsertPoint(instr);
      llvm::Value* casted = builder.CreatePointerCast(dest, builder.getInt8PtrTy());
      builder.CreateCall(write_parameter_function,
          {
            casted,
            builder.getInt32(size_of(dest)),
            builder.getInt32(parameter_idx)
          });
    }

    void Instrumenter::callImplicitLoop(llvm::Instruction * instr, int func_idx,
            int called_func_idx, int nested_loop_idx, int param_idx)
    {
        builder.SetInsertPoint(instr);
        builder.CreateCall(mark_implicit_label,
                {builder.getInt16(func_idx),
                builder.getInt16(nested_loop_idx),
                builder.getInt16(param_idx)});
        builder.CreateCall(call_implicit_function,
                {builder.getInt16(called_func_idx)});
    }

    template<typename Vector, typename FuncIter, typename FuncIter2, typename FuncIter3>
    void Instrumenter::createGlobalStorage(const Vector & funcs_names,
            const FunctionDatabase & database,
            FuncIter begin, FuncIter end,
            FuncIter3 implicit_begin, FuncIter3 implicit_end,
            FuncIter2 not_instr_begin, FuncIter2 not_instr_end)
    {
        functions_count = funcs_names.size();
        int implicit_functions_count = std::distance(implicit_begin,
                implicit_end);
        int not_instr_functions_count = std::distance(not_instr_begin,
                not_instr_end);
        std::vector<Function*> functions(functions_count);
        params_count = Parameters::parameters_count();
        // dummy insert since we only create global variables
        // but IRBuilder uses BB to determine the module
        // insert into first BB of first function
        builder.SetInsertPoint( &*(m.begin()->begin()) );

        // uint16_t __dfsan__retval_tls;
        glob_retval_tls = new llvm::GlobalVariable(m, builder.getInt16Ty(),
                false, llvm::GlobalValue::ExternalWeakLinkage,
                nullptr, glob_retval_tls_name, nullptr,
                llvm::GlobalValue::InitialExecTLSModel);

        // int32_t functions_count;
        llvm::Type * llvm_int_type = builder.getInt32Ty();
        glob_instr_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(functions_count),
                glob_instr_funcs_count_name);

        // int32_t functions_count;
        llvm_int_type = builder.getInt32Ty();
        glob_implicit_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(implicit_functions_count),
                glob_implicit_funcs_count_name);

        // int32_t functions_count;
        glob_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(functions_count + implicit_functions_count + not_instr_functions_count),
                glob_funcs_count_name);

        // int32_t params_count
        glob_implicit_params_count = new llvm::GlobalVariable(m,
                llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(database.parameters_count()),
                glob_implicit_params_count_name);

        glob_params_max_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(params_count),
                glob_params_max_count_name);

        // char * output_filename
        glob_output_filename = new llvm::GlobalVariable(m,
                builder.getInt8PtrTy(), false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.CreateGlobalStringPtr(OutputFileName.getValue()),
                glob_output_filename_name);

        // char ** file_names
        auto file_it = file_index.begin(), file_end = file_index.end();
        size_t file_count = std::distance(file_it, file_end);
        llvm::ArrayType * array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    file_count
                );
        std::vector<llvm::Constant*> file_names(file_count);
        for(; file_it != file_end; ++file_it) {
            llvm::StringRef fname = (*file_it).first;
            llvm::Constant * allocated = builder.CreateGlobalStringPtr(fname);
            file_names[ std::get<0>((*file_it).second) ] = allocated;
        }
        glob_files = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, file_names),
                glob_files_name);

        // char ** functions_names
        // char ** functions_mangled_names
        int database_size = functions_count + implicit_functions_count + not_instr_functions_count;
        array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    database_size
                );
        std::vector<llvm::Constant*> function_names(database_size),
            mangled_function_names(database_size),
            demangled_function_names(database_size);
        for(auto it = begin; it != end; ++it) {
            if( !(*it).second.hasValue() )
                continue;
            int f_idx = (*it).second->function_idx();
            // another function with the same ID already wrote data
            if(function_names[f_idx])
                continue;
            // Func -> ID is a many-to-one mapping
            // but only one parent function provides name
            llvm::Function * func = funcs_names[f_idx];
            llvm::StringRef name = info.getFunctionName(*func);
            llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
            llvm::StringRef mangled_name = func->getName();
            mangled_function_names[f_idx] =
                builder.CreateGlobalStringPtr(mangled_name);
            demangled_function_names[f_idx] = builder.CreateGlobalStringPtr(
                    demangle(mangled_name));
            function_names[f_idx] = fname;
        }
        for(auto it = implicit_begin; it != implicit_end; ++it) {
            int f_idx = (*it).second;

            llvm::StringRef name = (*it).first;
            llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
            mangled_function_names[f_idx] = fname;
            demangled_function_names[f_idx] = fname;
            function_names[f_idx] = fname;
        }
        int idx = functions_count + implicit_functions_count;
        for(auto it = not_instr_begin; it != not_instr_end; ++it) {
            llvm::Function * func = *it;
            llvm::StringRef name = info.getFunctionName(*func);
            llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
            llvm::StringRef mangled_name = func->getName();
            mangled_function_names[idx] =
                builder.CreateGlobalStringPtr(mangled_name);
            demangled_function_names[idx] = builder.CreateGlobalStringPtr(
                    demangle(mangled_name));
            function_names[idx] = fname;
            idx++;
        }
        glob_funcs_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, function_names),
                glob_funcs_names_name);
        glob_funcs_mangled_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, mangled_function_names),
                glob_funcs_mangled_names_name);
        glob_funcs_demangled_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, demangled_function_names),
                glob_funcs_demangled_names_name);

        // int32_t * functions_sizes
        array_type = llvm::ArrayType::get(
                    builder.getInt32Ty(),
                    functions_count
                );
        std::vector<llvm::Constant*> functions_args(functions_count);
        for(auto it = begin; it != end; ++it) {
            if( !(*it).second.hasValue() || (*it).second->is_overriden())
                continue;
            int f_idx = (*it).second->function_idx();
            int arg_size = (*it).first->arg_size();
            functions[f_idx] = &(*it).second.getValue();
            functions_args[f_idx] = builder.getInt32(arg_size);
        }
        glob_funcs_args = new llvm::GlobalVariable(m,
                array_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, functions_args),
                glob_funcs_args_name);

        // int * functions_dbg_info
        array_type = llvm::ArrayType::get(
                    builder.getInt32Ty(),
                    functions_count*2
                );
        std::vector<llvm::Constant*> functions_dbg_info(2*functions_count);
        for(auto it = begin; it != end; ++it) {
            if( !(*it).second.hasValue() )
                continue;
            int f_idx = (*it).second->function_idx();
            // another function with the same ID already wrote data
            if(functions_dbg_info[2*f_idx])
                continue;
            auto loc = info.getFunctionLocation(*(*it).first);
            int line = -1, file_idx = -1;
            if(loc.hasValue()) {
                // line of code
                line = std::get<1>(*loc);
                // file index
                file_idx = file_index.getIdx(std::get<0>(*loc));
            }
            // line of code
            functions_dbg_info[2*f_idx] = builder.getInt32(line);
            // file index
            functions_dbg_info[2*f_idx + 1] = builder.getInt32(file_idx);
        }

        glob_funcs_dbg = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, functions_dbg_info),
                glob_funcs_dbg_name);

        // char ** params_names
        // filled during execution
        size_t full_params_count = params_count + database.parameters_count();
        std::cerr << full_params_count << '\n';
        array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    full_params_count);
        std::vector<llvm::Constant*> params_names(full_params_count);
        for(int i = 0; i < database.parameters_count(); ++i)
            params_names[i] =
                builder.CreateGlobalStringPtr(database.parameter_name(i));
        for(int i = 0; i < params_count; ++i)
            params_names[i + database.parameters_count()] = llvm::ConstantPointerNull::get(builder.getInt8PtrTy());
        glob_params_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                //llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, params_names),
                glob_params_names_name);

        array_type = llvm::ArrayType::get(
                    builder.getInt1Ty(),
                    full_params_count);
        glob_params_used = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantAggregateZero::get(array_type),
                glob_params_used_name);

        array_type = llvm::ArrayType::get(
                    builder.getInt16Ty(),
                    database.parameters_count());
        glob_params_redirect = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantAggregateZero::get(array_type),
                glob_params_redirect_name);

        // int16_t instrumentation_labels[] = {0..}
        array_type = llvm::ArrayType::get(builder.getInt16Ty(), params_count);
        std::vector<llvm::Constant*> labels;
        for(int i = 0; i < params_count; ++i)
            labels.push_back(builder.getInt16(0));
        glob_labels = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, labels),
                glob_labels_name);

        // int32_t instrumentation_results[functions * params];
        //array_type = llvm::ArrayType::get(builder.getInt32Ty(),
        //        params_count * functions_count);
        //glob_result_array = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantAggregateZero::get(array_type),
        //        glob_result_array_name);

        // callsite_count * operand_count
        // last element stores the final size
        //std::vector<int> sizes(functions_count + 1);
        //for(auto it = begin; it != end; ++it) {
        //    if( (*it).second.hasValue() && !(*it).second->is_overriden()) {
        //        int operands_count = (*it).first->arg_size();
        //        int callsites_count = (*it).second->callsites_size();
        //        int f_idx = (*it).second->function_idx();
        //        sizes[f_idx] = operands_count * callsites_count;
        //        //llvm::outs() << (*it).first->getName() << ' ' << operands_count << ' ' << callsites_count << '\n';
        //    }
        //}
        //// compute offsets with a prefix sum
        //std::partial_sum(sizes.begin(), sizes.end(), sizes.begin());
        //int total_size = sizes.back();
        //// int8_t callsites_results[total_size];
        //array_type = llvm::ArrayType::get(builder.getInt1Ty(), total_size);
        //glob_callsites_result = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantAggregateZero::get(array_type),
        //        glob_callsites_result_name);
        //// int32_t callsites_offsets[functions_count + 1];
        //// first element is always zero, the last one is an accumulated sum
        //std::vector<llvm::Constant*> offsets(functions_count + 1);
        //std::transform(sizes.begin(), sizes.end(), offsets.begin(),
        //    [this](int offset) {
        //        return builder.getInt32(offset);
        //    }
        //);
        //array_type = llvm::ArrayType::get(builder.getInt32Ty(),
        //        functions_count + 1);
        //glob_callsites_offsets = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantArray::get(array_type, offsets),
        //        glob_callsites_offsets_name);

        ////int32_t loop_depths
        //std::vector<llvm::Constant*> depths(loops_depths.size());
        //std::transform(loops_depths.begin(), loops_depths.end(), depths.begin(),
        //    [this](int depth) {
        //        return builder.getInt32(depth);
        //    }
        //);
        //array_type = llvm::ArrayType::get(builder.getInt32Ty(),
        //        loops_depths.size());
        //glob_loops_depths = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantArray::get(array_type, depths),
        //        glob_loops_depths_name);

        ////int32_t loops_depths_offsets
        //std::vector<int> depths_offsets(functions_count + 1);
        //std::partial_sum(loops_counts.begin(), loops_counts.end(),
        //    depths_offsets.begin() + 1);
        //depths_offsets[0] = 0;
        //std::vector<llvm::Constant*> depths_offsets_ir(functions_count + 1);
        //std::transform(depths_offsets.begin(), depths_offsets.end(),
        //        depths_offsets_ir.begin(),
        //        [this](int offset) {
        //            return builder.getInt32(offset);
        //        });
        //array_type = llvm::ArrayType::get(builder.getInt32Ty(),
        //        functions_count + 1);
        //glob_depths_array_offsets = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantArray::get(array_type, depths_offsets_ir),
        //        glob_depths_array_offsets_name);

        ////int32_t deps_offsets
        //// for each function compute the number of `dependencies` objects
        //// corresponds to sum of loop depths
        //std::vector<int> loops_per_func(functions_count);
        //std::vector<int> deps_offsets(functions_count + 1);
        //int cnt = 0;
        //for(int i = 0; i < functions_count; ++i) {
        //    int loops = 0;
        //    for(int j = 0; j < loops_counts[i]; ++j) {
        //        loops += loops_depths[cnt++];
        //    }
        //    loops_per_func[i] = loops;
        //}
        //std::partial_sum(loops_per_func.begin(), loops_per_func.end(),
        //    deps_offsets.begin() + 1);
        //deps_offsets[0] = 0;
        //std::vector<llvm::Constant*> deps(functions_count + 1);
        //std::transform(deps_offsets.begin(), deps_offsets.end(), deps.begin(),
        //    [this](int offset) {
        //        return builder.getInt32(offset);
        //    }
        //);
        //array_type = llvm::ArrayType::get(builder.getInt32Ty(),
        //        loops_counts.size() + 1);
        //glob_deps_offsets = new llvm::GlobalVariable(m,
        //        array_type, false, llvm::GlobalValue::WeakAnyLinkage,
        //        llvm::ConstantArray::get(array_type, deps),
        //        glob_deps_offsets_name);

        // number of loops in the entire program
        std::vector<int> loops_structures;
        std::vector<int> loops_structures_offsets(functions_count + 1);
        std::vector<int> loops_sizes;
        std::vector<int> loops_sizes_offsets(functions_count + 1);
        loops_sizes_offsets[0] = 0;
        loops_structures_offsets[0] = 0;
        int number_of_loops = 0;
        for(Function * f : functions) {
            std::copy(f->loops_structures.begin(), f->loops_structures.end(),
                    std::back_inserter(loops_structures));
            int f_idx = f->function_idx();
            std::copy(f->loops_sizes.begin(), f->loops_sizes.end(),
                    std::back_inserter(loops_sizes));
            loops_sizes_offsets[f_idx + 1] = f->loops_sizes.size();
            loops_structures_offsets[f_idx + 1] = f->loops_structures.size();
            int loops = f->loops_sizes.size() / 3;
            for(int i = 0; i < loops; ++i)
                number_of_loops += f->loops_sizes[3*i + 2];
        }

        std::vector<llvm::Constant*> structures(loops_structures.size());
        std::transform(loops_structures.begin(), loops_structures.end(),
                structures.begin(),
                [this](int offset) {
                    return builder.getInt32(offset);
                }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                loops_structures.size());
        glob_loops_structures = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, structures),
                glob_loops_structures_name);

        std::vector<llvm::Constant*> sizes(loops_sizes.size());
        std::transform(loops_sizes.begin(), loops_sizes.end(),
                sizes.begin(),
                [this](int offset) {
                    return builder.getInt32(offset);
                }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                loops_sizes.size());
        glob_loops_sizes = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, sizes),
                glob_loops_sizes_name);

        std::partial_sum(loops_sizes_offsets.begin(), loops_sizes_offsets.end(),
            loops_sizes_offsets.begin());
        std::vector<llvm::Constant*> sizes_llvm(functions_count + 1);
        std::transform(loops_sizes_offsets.begin(), loops_sizes_offsets.end(),
                sizes_llvm.begin(),
                [this](int offset) {
                    return builder.getInt32(offset);
                }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                functions_count + 1);
        glob_loops_sizes_offsets = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, sizes_llvm),
                glob_loops_sizes_offsets_name);

        std::partial_sum(loops_structures_offsets.begin(), loops_structures_offsets.end(),
            loops_structures_offsets.begin());
        std::vector<llvm::Constant*> structs_llvm(functions_count + 1);
        std::transform(loops_structures_offsets.begin(), loops_structures_offsets.end(),
                structs_llvm.begin(),
                [this](int offset) {
                    return builder.getInt32(offset);
                }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                functions_count + 1);
        glob_loops_sizes_offsets = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, structs_llvm),
                glob_loops_structures_offsets_name);

        glob_loops_number = new llvm::GlobalVariable(m,
                builder.getInt32Ty(), false, llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(number_of_loops),
                glob_loops_number_name);
    }

    void Instrumenter::checkLoop(int nested_loop_idx, int function_idx,
            const llvm::Instruction * inst)
    {
        // insert call before branch
        InstrumenterVisiter vis(*this,
            [this, nested_loop_idx, function_idx]
            (uint64_t size, llvm::Value * ptr) {
                checkLoopLoad(nested_loop_idx, function_idx, size, ptr);
            },
            [this, nested_loop_idx, function_idx]
            (llvm::CallBase * ptr) {
                checkLoopRetval(nested_loop_idx, function_idx, ptr);
            }
        );
        // TODO: why instvisit is not for const instruction?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::checkLoopLoad(int nested_loop_idx, int function_idx,
            size_t size, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        builder.CreateCall(load_loop_function, {
                cast, builder.getInt32(size),
                builder.getInt32(nested_loop_idx),
                builder.getInt32(function_idx)
            });
    }

    void Instrumenter::checkLoopRetval(int nested_loop_idx,
            int function_idx, llvm::CallBase * call)
    {
        llvm::Value * load_tls = builder.CreateLoad(glob_retval_tls);
        builder.CreateCall(label_loop_function, {
                load_tls, builder.getInt32(nested_loop_idx),
                builder.getInt32(function_idx)
            });
    }

    void Instrumenter::checkCF(int function_idx, llvm::BranchInst * br)
    {
        // insert call before branch
        InstrumenterVisiter vis(*this,
            [this, function_idx](uint64_t size, llvm::Value * ptr) {
                checkCFLoad(function_idx, size, ptr);
            },
            [this, function_idx](llvm::CallBase * ptr) {
                checkCFRetval(function_idx, ptr);
            }
        );
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(br->getCondition());
        assert(inst);
        // TODO: why instvisit is not for const instruction?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::checkCFLoad(int function_idx, size_t size, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        builder.CreateCall(load_function, {cast, builder.getInt32(size), builder.getInt32(function_idx) });
    }

    void Instrumenter::checkCFRetval(int function_idx, llvm::CallBase * call)
    {
        llvm::Value * load_tls = builder.CreateLoad(glob_retval_tls);
        builder.CreateCall(label_function,
                {load_tls, builder.getInt32(function_idx)}
            );
    }

    void Instrumenter::checkCallSite(int function_idx, int callsite_idx,
            llvm::CallBase * call)
    {
        // dom't cache loads because we update args seperately
        // same load might appear twice
        // TODO: optimize this to call check with multiple arg ids
        int arg_idx = 0;
        auto load_check =
            [=, &arg_idx](uint64_t size, llvm::Value * ptr) {
                checkCallSiteLoad(function_idx, callsite_idx, arg_idx++, size, ptr);
            };
        auto label_check =
            [=, &arg_idx](llvm::CallBase * ptr) {
                checkCallSiteRetval(function_idx, callsite_idx, arg_idx++, ptr);
            };
        InstrumenterVisiter vis(*this, load_check, label_check, false);
        for(int i = 0; i < call->getNumArgOperands(); ++i) {
            llvm::Value * arg = call->getArgOperand(i);
            // constant values (int, fp)
            if(llvm::isa<llvm::ConstantData>(arg))
                continue;
            llvm::Instruction * instr = llvm::dyn_cast<llvm::Instruction>(arg);
            assert(instr);
            vis.visit(*instr);
        }
    }

    void Instrumenter::checkCallSiteLoad(int function_idx, int callsite_idx,
            int arg_idx, uint64_t size, llvm::Value * ptr)
    {
        llvm::Value * cast = builder.CreatePointerCast(ptr, builder.getInt8PtrTy());
        builder.CreateCall(callsite_function, {cast, builder.getInt32(size),
                builder.getInt32(function_idx), builder.getInt32(callsite_idx),
                builder.getInt32(arg_idx)});
    }

    void Instrumenter::checkCallSiteRetval(int function_idx, int callsite_idx,
            int arg_idx, llvm::CallBase * ptr)
    {
    }

    void Instrumenter::setLabel(Parameters::id_t param, const llvm::Value * val)
    {
        assert(glob_labels);
        LabelAnnotator vis{*this, param};
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(val);
        assert(inst);
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::callSetLabel(int param_idx, const char * param_name, size_t size, llvm::Value * operand)
    {
        //TODO: can we embed a const string in code?
        //llvm::Constant * name = llvm::ConstantDataArray::getString(builder.getContext(), param_name, false);
        llvm::Value * name = builder.CreateGlobalString(param_name, "");
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        llvm::Value * zero = builder.getInt32(0);
        llvm::Value * indices[] = {zero, zero};
        llvm::Value * gep = llvm::GetElementPtrInst::CreateInBounds(name, llvm::makeArrayRef(indices, 2), "", llvm::dyn_cast<llvm::Instruction>(cast));
        //llvm::Value * name_cast = builder.CreatePointerCast(name, builder.getInt8PtrTy());
        // set_label(data, size, param_idx, param_name)
        builder.CreateCall(store_function,{
                    cast, builder.getInt32(size),
                    builder.getInt32(param_idx),
                    gep
                    //llvm::ConstantExpr::getPointerCast(name, builder.getInt8PtrTy())
                });
    }

    void Instrumenter::commitLoop(llvm::Loop & l, int func_idx, int loop_idx)
    {
        llvm::SmallVector<llvm::BasicBlock*, 5> exit_blocks;
        l.getExitBlocks(exit_blocks);
        for(llvm::BasicBlock * bb : exit_blocks) {
            builder.SetInsertPoint(&bb->front());
            builder.CreateCall(commit_loop_function,
                {builder.getInt32(func_idx)}
            );
        }
    }

    void Instrumenter::commitLoops(llvm::Function & f, int func_idx, int calls_count)
    {
        llvm::SmallVector<llvm::ReturnInst*, 5> returns;
        findTerminator(f, returns);
        for(llvm::ReturnInst * ret : returns) {
            builder.SetInsertPoint(ret);
            builder.CreateCall(commit_loop_function,
                {builder.getInt32(func_idx), builder.getInt32(calls_count)}
            );
        }
    }

    void Instrumenter::instrumentLoopCall(llvm::Function & f, llvm::CallBase * call,
            int16_t nested_loop_idx, uint16_t loop_size)
    {
        //llvm::BasicBlock * header = l.getHeader();
        //assert(header);
        //std::vector< std::tuple<llvm::Value*, llvm::BasicBlock*> > values;
        //for(auto it = pred_begin(header), end = pred_end(header); it != end; ++it)
        //{
        //    // exclude interna blocks going back to the header
        //    if( l.contains(*it) )
        //        continue;
        //    builder.SetInsertPoint( &(*it)->back() );
        //    llvm::Value * idx = builder.CreateCall(register_call_function,
        //            {builder.getInt16(nested_loop_idx), builder.getInt16(loop_size)}
        //        );
        //    //llvm::errs() << idx << " " << *idx->getType() << " " << *it << '\n';
        //    values.push_back( std::make_tuple(idx, *it) );
        //}
        //builder.SetInsertPoint(&call->getParent()->front());
        //llvm::PHINode * phi = builder.CreatePHI(builder.getInt16Ty(),
        //        values.size());
        //for(auto & t : values)
        //    phi->addIncoming( std::get<0>(t), std::get<1>(t) );
        //builder.CreateCall(current_call_function, {phi});
        // on function enter
        // idx = register_call(loop_idx, loop_size);
        builder.SetInsertPoint(&f.front().front());
        llvm::Value * idx = builder.CreateCall(register_call_function,
                {builder.getInt16(nested_loop_idx), builder.getInt16(loop_size)}
            );
        // just before the call
        // set_current_register(idx)
        builder.SetInsertPoint(call);
        builder.CreateCall(set_current_call_function, {idx});
    }

    void Instrumenter::removeLoopCalls(llvm::Function & f, size_t size)
    {
        //llvm::SmallVector<llvm::BasicBlock*, 5> exit_blocks;
        //l.getExitBlocks(exit_blocks);
        //for(llvm::BasicBlock * bb : exit_blocks) {
        //    // after loop commit
        //    builder.SetInsertPoint(&bb->back());
        //    builder.CreateCall(remove_calls_function,
        //        { builder.getInt16(size)}
        //        );
        //}
        llvm::SmallVector<llvm::ReturnInst*, 5> returns;
        findTerminator(f, returns);
        for(llvm::ReturnInst * ret : returns) {
            builder.SetInsertPoint(ret);
            builder.CreateCall(remove_calls_function, {builder.getInt16(size)});
        }
    }

    void Instrumenter::findTerminator(llvm::Function & f, llvm::SmallVector<llvm::ReturnInst*, 5> & returns)
    {
        bool found_unreachable = false;
        for(llvm::BasicBlock & bb : f) {
            llvm::Instruction * instr = bb.getTerminator();
            if(llvm::ReturnInst * ret = llvm::dyn_cast<llvm::ReturnInst>(instr)) {
                returns.push_back(ret);
            } else if(llvm::UnreachableInst * unreachable = llvm::dyn_cast<llvm::UnreachableInst>(instr))
                found_unreachable = true;
        }
        // TODO: more generic solution where there are unreachable blocks
        assert(found_unreachable || returns.size());
    }

    void Instrumenter::saveCurrentCall(llvm::Function & f)
    {
        builder.SetInsertPoint(&f.front().front());
        llvm::Value * last_val = builder.CreateCall(
                get_current_call_function,
                {});
        llvm::SmallVector<llvm::ReturnInst*, 5> returns;
        findTerminator(f, returns);
        for(llvm::ReturnInst * ret : returns) {
            builder.SetInsertPoint(ret);
            builder.CreateCall(set_current_call_function, {last_val});
        }
    }

    void Instrumenter::declareFunctions()
    {
        llvm::Type * void_t = builder.getVoidTy();
        llvm::Type * int8_ptr = builder.getInt8PtrTy();
        llvm::Type * idx_t = builder.getInt32Ty();
        llvm::Type * i16_t = builder.getInt16Ty();
        llvm::FunctionType * func_t = nullptr;

        //// void check_load(int8_t *, int32_t, int32_t)
        //func_t = llvm::FunctionType::get(
        //        void_t, {int8_ptr, idx_t, idx_t}, false);
        //m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LOAD", func_t);
        //load_function = m.getFunction("__dfsw_EXTRAP_CHECK_LOAD");
        //assert(load_function);

        //// void check_label(uint16_t, int32_t)
        //func_t = llvm::FunctionType::get(
        //        void_t, {builder.getInt16Ty(), idx_t}, false);
        //m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
        //label_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");
        //assert(label_function);

        // void store_label(int8_t *, int32_t, int32_t, int8_t*)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, int8_ptr}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_STORE_LABEL", func_t);
        store_function = m.getFunction("__dfsw_EXTRAP_STORE_LABEL");
        assert(store_function);

        // void check_arg(int8_t *, int32_t, int32_t, int32_t, int32_t)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_CALLSITE", func_t);
        callsite_function = m.getFunction("__dfsw_EXTRAP_CHECK_CALLSITE");
        assert(store_function);

        // void at_exit()
        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_AT_EXIT", func_t);
        at_exit_function = m.getFunction("__dfsw_EXTRAP_AT_EXIT");
        assert(at_exit_function);

        // void extrap_init()
        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_INIT", func_t);
        init_function = m.getFunction("__dfsw_EXTRAP_INIT");
        assert(init_function);

        // void __EXTRAP_CHECK_LABEL(label, loop_idx, func_idx)
        func_t = llvm::FunctionType::get(void_t,
                {builder.getInt16Ty(), idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
        label_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");

        // __EXTRAP_CHECK_LOAD(addr, size, loop_idx, func_idx)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LOAD", func_t);
        load_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LOAD");

        // __EXTRAP_COMMIT_LOOP(loop_idx, function_idx, calls_count)
        func_t = llvm::FunctionType::get(void_t, {idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_COMMIT_LOOP", func_t);
        commit_loop_function = m.getFunction("__dfsw_EXTRAP_COMMIT_LOOP");
        assert(commit_loop_function);

        // __dfsw_EXTRAP_PUSH_CALL_FUNCTION(idx)
        func_t = llvm::FunctionType::get(void_t,
                {i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_PUSH_CALL_FUNCTION", func_t);
        push_function = m.getFunction("__dfsw_EXTRAP_PUSH_CALL_FUNCTION");
        assert(push_function);

        // __dfsw_EXTRAP_POP_CALL_FUNCTION
        func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_POP_CALL_FUNCTION", func_t);
        pop_function = m.getFunction("__dfsw_EXTRAP_POP_CALL_FUNCTION");
        assert(pop_function);

        // uint16_t __dfsw_EXTRAP_REGISTER_CALL(uint16_t, uint16_t);
        func_t = llvm::FunctionType::get(i16_t, {i16_t, i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_REGISTER_CALL", func_t);
        register_call_function = m.getFunction("__dfsw_EXTRAP_REGISTER_CALL");
        assert(register_call_function);

        // void __dfsw_EXTRAP_REMOVE_CALLS(uint16_t)
        func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_REMOVE_CALLS", func_t);
        remove_calls_function = m.getFunction("__dfsw_EXTRAP_REMOVE_CALLS");
        assert(remove_calls_function);

        // void __dfsw_EXTRAP_SET_CURRENT_CALL(int16_t)
        func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_SET_CURRENT_CALL", func_t);
        set_current_call_function = m.getFunction("__dfsw_EXTRAP_SET_CURRENT_CALL");
        assert(set_current_call_function);

        // int16_t __dfsw_EXTRAP_CURRENT_CALL()
        func_t = llvm::FunctionType::get(i16_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CURRENT_CALL", func_t);
        get_current_call_function = m.getFunction("__dfsw_EXTRAP_CURRENT_CALL");
        assert(get_current_call_function);

        // void __dfsw_EXTRAP_INIT_MPI
        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_INIT_MPI", func_t);
        init_mpi_function = m.getFunction("__dfsw_EXTRAP_INIT_MPI");
        assert(init_mpi_function);

        // void __dfsw_EXTRAP_MARK_IMPLICIT_LABEL(uint16_t, uint16_t, uint16_t)
        func_t = llvm::FunctionType::get(void_t, {i16_t, i16_t, i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_MARK_IMPLICIT_LABEL", func_t);
        mark_implicit_label = m.getFunction("__dfsw_EXTRAP_MARK_IMPLICIT_LABEL");
        assert(mark_implicit_label);

        // void __dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION(uint16_t)
        func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION", func_t);
        call_implicit_function = m.getFunction("__dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION");
        assert(call_implicit_function);

        // void __dfsw_EXTRAP_WRITE_PARAMETER(int8_t *, size_t, int32_t)
        func_t = llvm::FunctionType::get(void_t, {int8_ptr, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_WRITE_PARAMETER", func_t);
        write_parameter_function = m.getFunction("__dfsw_EXTRAP_WRITE_PARAMETER");
        assert(write_parameter_function);
    }

    // polly lib/CodeGen/PerfMonitor.cpp
    llvm::Function * Instrumenter::getAtExit()
    {
        llvm::Function * f = m.getFunction("atexit");
        if(!f) {
            //int32_t atexit(int8_t*)
            llvm::GlobalValue::LinkageTypes linkage
                = llvm::GlobalValue::ExternalLinkage;
            llvm::FunctionType * f_type = llvm::FunctionType::get(
                    builder.getInt32Ty(),
                    {builder.getInt8PtrTy()}, false
                );
            f = llvm::Function::Create(f_type, linkage, "atexit", m);
        }
        return f;
    }

    void Instrumenter::enterFunction(llvm::Function & f, Function & func)
    {
        enterFunction(f, func.function_idx());
    }

    void Instrumenter::enterFunction(llvm::Function & f, size_t idx)
    {
        builder.SetInsertPoint(&f.front().front());
        builder.CreateCall(push_function,
                { builder.getInt16(idx) });
        llvm::SmallVector<llvm::ReturnInst*, 5> returns;
        findTerminator(f, returns);
        for(llvm::ReturnInst * ret : returns) {
            builder.SetInsertPoint(ret);
            builder.CreateCall(pop_function, {builder.getInt16(idx)});
        }
    }

    void Instrumenter::setInsertPoint(llvm::Instruction & instr)
    {
        builder.SetInsertPoint(&instr);
    }

    void Instrumenter::initialize(llvm::Function * main)
    {
        //builder.SetInsertPoint(main->getEntryBlock().getTerminator()->getPrevNode());
        builder.SetInsertPoint( &(*main->getEntryBlock().begin()) );
        llvm::Value * cast_f = builder.CreatePointerCast(at_exit_function, builder.getInt8PtrTy());
        builder.CreateCall(getAtExit(), {cast_f});
        builder.CreateCall(init_function);

        // TODO: make it work outside of main
        for(llvm::BasicBlock & bb : *main) {
            for(llvm::Instruction & instr : bb) {
                if(llvm::CallBase * call =
                        llvm::dyn_cast<llvm::CallBase>(&instr)) {
                    if(llvm::Function * f = call->getCalledFunction()) {
                        llvm::StringRef name = f->getName();
                        if(name == "MPI_Init" || name == "MPI_Init_thread") {
                            builder.SetInsertPoint(instr.getNextNode());
                            builder.CreateCall(init_mpi_function);
                        }
                    }
                }
            }
        }
    }

    void Instrumenter::annotateParams(const std::vector< std::tuple<const llvm::Value *, Parameters::id_t> > & params)
    {
        assert(glob_labels);
        for(int i = 0; i < params.size(); ++i) {
            if(LabelAnnotator::visited(std::get<1>(params[i])))
                continue;
            LabelAnnotator vis{*this, std::get<1>(params[i])};
            const llvm::Value * param = std::get<0>(params[i]);
            if(const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(param)) {
                assert( vis.visit( const_cast<llvm::Instruction*>(inst) ) );
            } else if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(param)) {
                //assert(vis.visit(*gep));
                //TODO: get rid of that
                llvm::Value * ptr = const_cast<llvm::Value*>(gep->getPointerOperand());
                llvm::Value ** indices = new llvm::Value*[gep->getNumIndices()];
                auto it = gep->idx_begin();
                for(int i = 0; i < gep->getNumIndices(); ++i, ++it) {
                    indices[i] = llvm::dyn_cast<llvm::Value>(*it);
                    assert(indices[i]);
                }
                llvm::Value * value = builder.CreateGEP(ptr, llvm::makeArrayRef(indices, gep->getNumIndices()));
                delete[] indices;
                //for(const llvm::Value * use : gep->users()) {
                //    llvm::outs() << *gep << ' ' << *use << '\n';
                //    const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(use);
                //    assert(inst);
                //    assert( vis.visit( const_cast<llvm::Instruction*>(inst) ) );
                //}
            } else
                assert(false);
            LabelAnnotator::annotated_params.insert(std::get<1>(params[i]));
        }
    }

    llvm::Instruction * Instrumenter::createGlobalStringPtr(const char * name, llvm::Instruction * placement)
    {
        llvm::Value * str = builder.CreateGlobalString(name, "");
        llvm::Value * zero = builder.getInt32(0);
        llvm::Value * indices[] = {zero, zero};
        return llvm::GetElementPtrInst::CreateInBounds(str, llvm::makeArrayRef(indices, 2), "", placement);
    }

    uint64_t Instrumenter::size_of(llvm::Value * val)
    {
        llvm::PointerType * ptr = llvm::dyn_cast<llvm::PointerType>(val->getType());
        assert(ptr);
        assert(layout);
        return layout->getTypeStoreSize(ptr->getPointerElementType());
    }

    void InstrumenterVisiter::visitLoadInst(llvm::LoadInst & load)
    {
        if(avoid_duplicates) {
            if(processed_loads.count(&load))
                return;
            processed_loads.insert(&load);
        }

        if(load.getType()->isPointerTy()) {
            instr.setInsertPoint(*load.getNextNode());
            uint64_t size = instr.size_of(&load);
            load_function(size, &load);
        } else {
            // we perform verification close to the original load
            // branches
            instr.setInsertPoint(load);
            uint64_t size = instr.size_of(load.getPointerOperand());
            //instr.callCheckLabel(function_idx, size, load.getPointerOperand());
            load_function(size, load.getPointerOperand());
        }
    }

    llvm::Instruction * to_instr(llvm::Value * val)
    {
        return llvm::dyn_cast<llvm::Instruction>(val);
    }

    void InstrumenterVisiter::visitPHINode(llvm::PHINode & inst)
    {
        // Avoid cyclic references in loops
        if(phis.find(&inst) != phis.end())
            return;
        phis.insert(&inst);
        for(int i = 0; i < inst.getNumIncomingValues(); ++i) {
            if(llvm::Instruction * operand
                    = to_instr(inst.getIncomingValue(i)))
                visit(operand);
        }
        phis.erase(&inst);
    }

    void InstrumenterVisiter::visitCallInst(llvm::CallInst & inst)
    {
        processCall(&inst);
    }

    void InstrumenterVisiter::visitInvokeInst(llvm::InvokeInst & inst)
    {
        processCall(&inst);
    }

    void InstrumenterVisiter::processCall(llvm::CallBase * call)
    {
        if(avoid_duplicates) {
            if(processed_calls.count(call))
                return;
            processed_calls.insert(call);
        }
        label_function(call);
    }

    void InstrumenterVisiter::visitInstruction(llvm::Instruction & inst)
    {
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                visit(inst_new);
    }

    FileIndex::iterator FileIndex::begin()
    {
        return index.begin();
    }

    FileIndex::iterator FileIndex::end()
    {
        return index.end();
    }

    void FileIndex::import(llvm::Module & m, DebugInfo & info)
    {
        int idx = 0;
        info.getTranslationUnits(m,
            [this, &idx](const llvm::StringRef & dir,
                        const llvm::StringRef & name) {
                index[name] = std::make_tuple(idx++, dir);
            }
        );
    }

    int FileIndex::getIdx(llvm::StringRef & name)
    {
        auto it = index.find(name);
        if(it != index.end())
            return std::get<0>((*it).second);
        else
            return -1;
    }

    bool LabelAnnotator::visitLoadInst(llvm::LoadInst & load)
    {
        instr.builder.SetInsertPoint(load.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, load.getPointerOperand());
        return true;
    }

    bool LabelAnnotator::visitAllocaInst(llvm::AllocaInst & alloca)
    {
        instr.builder.SetInsertPoint(alloca.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, &alloca);
        return true;
    }

    bool LabelAnnotator::visitInstruction(llvm::Instruction & inst)
    {
        bool ret = false;
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                ret |= visit(inst_new);
        return ret;
    }

    bool LabelAnnotator::visitGetElementPtrInst(llvm::GetElementPtrInst & gepinst)
    {
        instr.builder.SetInsertPoint(gepinst.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, &gepinst);
        return true;
    }

    bool LabelAnnotator::visitBitCastInst(llvm::BitCastInst & cast)
    {
        instr.builder.SetInsertPoint(cast.getNextNode());
        if(!llvm::isa<llvm::Instruction>(cast.getOperand(0))) {
            llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(cast.getOperand(0));
            assert(gep);
            llvm::SmallVector<llvm::Value*, 5> indices;
            for(auto it = gep->idx_begin(), end = gep->idx_end(); it != end; ++it)
                indices.push_back(*it );
            llvm::Value * new_gep = llvm::GetElementPtrInst::CreateInBounds(
                    gep->getPointerOperand(),
                    llvm::makeArrayRef(indices.data(), indices.size()),
                    "", &cast);
            instr.callSetLabel(param_idx, "param", 4, new_gep);
        } else
            instr.callSetLabel(param_idx, "param", 4, cast.getOperand(0));
        return true;
    }

    bool LabelAnnotator::visited(Parameters::id_t id)
    {
        return annotated_params.find(id) != annotated_params.end();
    }
}

char extrap::DfsanInstr::ID = 0;
static llvm::RegisterPass<extrap::DfsanInstr> register_pass(
    "extrap-extractor",
    "Extract loop information",
    true /* Only looks at CFG */,
    false /* Analysis Pass */);

// Allow running dynamically through frontend such as Clang
void addDfsanInstr(const llvm::PassManagerBuilder &Builder,
                        llvm::legacy::PassManagerBase &PM) {
  PM.add(new extrap::DfsanInstr());
}

// run after optimizations
llvm::RegisterStandardPasses SOpt(llvm::PassManagerBuilder::EP_OptimizerLast,
                            addDfsanInstr);

