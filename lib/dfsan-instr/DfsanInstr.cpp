#include "dfsan-instr/DfsanInstr.hpp"
#include "ParameterFinder.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

#include <polly/PolySCEV.h>

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

static llvm::cl::opt<std::string> JSONOutputToFile("extrap-extractor-json-output-file",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> GenerateStats("extrap-extractor-export-stats",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("filename"));

namespace extrap {

    void DfsanInstr::getAnalysisUsage(llvm::AnalysisUsage &AU) const
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

    bool DfsanInstr::runOnModule(llvm::Module &m)
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

        // Since neither m.getName() or m.getSourceFileName provides a meaningful name
        // We rely on the user to supply an additional log name.
       
        std::string name = LogDirName.getValue().empty() ?
                           "results" :
                           cppsprintf("%s/results", LogDirName.getValue().c_str());
        log.open(
            cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()),
            std::ios::app);
        cgraph = &getAnalysis<llvm::CallGraphWrapperPass>().getCallGraph();
        Parameters::find_globals(m);

        this->m = &m;
        llvm::Function * main = m.getFunction("main");
        assert(main);

        runOnFunction(*main);
        Instrumenter instr(m);
        instr.createGlobalStorage(instrumented_functions.size());
        size_t params_count = Parameters::globals_names.size() + Parameters::arg_names.size();
        for(auto & f : instrumented_functions)
        {
            modifyFunction(*f.first, instr);
        }

        return false;
    }

    void DfsanInstr::runOnFunction(llvm::Function & f)
    {
        // ignore declarations
        if(!is_analyzable(*m, f))
            return;
        llvm::CallGraphNode * f_node = (*cgraph)[&f];
        ParameterFinder finder(f);
        FunctionParameters parameters = finder.find_args();
        instrumented_functions.insert( std::make_pair(&f, instrumented_functions.size()) );
        
        for(auto & callsite : *f_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            runOnFunction(*called_f);
        }
    }
    
    void DfsanInstr::modifyFunction(llvm::Function & f, Instrumenter & instr)
    {

        llvm::outs() << "Visit function: " << f.getName() << '\n';
        for(auto i = llvm::inst_begin(&f), end = llvm::inst_end(&f); i != end; ++i)
        {
            if(llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(&*i)) {
                if(br->isConditional()) {
                    // insert the check for labels
                    instr.checkLabel(0, br);
                }
            } 
        }
    }
    
    bool DfsanInstr::is_analyzable(llvm::Module & m, llvm::Function & f)
    {
        llvm::Function * in_module = m.getFunction(f.getName());
        if(f.isDeclaration() || !in_module) {
            unknown << f.getName().str() << '\n';
            return false;
        }
        return true;
    }

    void Instrumenter::createGlobalStorage(size_t functions_count)
    {
        this->functions_count = functions_count;
        params_count = Parameters::parameters_count();
        llvm::ArrayType *array_type = llvm::ArrayType::get(builder.getInt32Ty(), params_count * functions_count);
        std::vector<llvm::Constant*> V;
        for(int i = 0; i < params_count*functions_count; ++i)
            V.push_back( builder.getInt32(0));
        result_array = new llvm::GlobalVariable(m, array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, V), result_array_name); 
    }
    
    void Instrumenter::checkLabel(int function_idx, llvm::BranchInst * br)
    {
        assert(result_array);
        // insert call before branch
        builder.SetInsertPoint( br->getPrevNode() );
        InstrumenterVisiter vis{*this, 0};
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(br->getCondition());
        assert(inst);
        llvm::outs() << "Visit: " << *inst << '\n';
        // TODO: why instvisit is not for const inst?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }
    
    void Instrumenter::declareFunctions()
    {
        llvm::Type * void_t = builder.getVoidTy();
        llvm::Type * int8_ptr = builder.getInt8PtrTy();
        llvm::Type * idx_t = builder.getInt32Ty();
        llvm::FunctionType * func_t = llvm::FunctionType::get(void_t, {int8_ptr, idx_t}, false);
        m.getOrInsertFunction("__EXTRAP_CHECK_LABEL", func_t);
        load_function = m.getFunction("__EXTRAP_CHECK_LABEL");
        assert(load_function);
    } 
    
    void Instrumenter::checkLabel(int function_idx, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        llvm::outs() << "Insert cast: " << *cast << '\n';
        builder.CreateCall(load_function, {cast, builder.getInt32(function_idx) });
    }
    
    void InstrumenterVisiter::visitLoadInst(llvm::LoadInst & load)
    {
        llvm::outs() << "Visit: " << load << '\n';
        if(processed_loads.count(&load))
            return;
        processed_loads.insert(&load);
        instr.checkLabel(function_idx, load.getPointerOperand());
    }
    
    void InstrumenterVisiter::visitInstruction(llvm::Instruction & inst)
    {
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                visit(inst_new);
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

