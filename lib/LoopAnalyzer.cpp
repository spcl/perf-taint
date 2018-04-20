//
// Created by mcopik on 4/19/18.
//

#include "LoopAnalyzer.hpp"

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"

#define DEBUG_TYPE "LoopExtractor"

results::LoopInformation LoopAnalyzer::analyze()
{
    //errs() << loop.getInductionVariable();
    //FIXME: what if there is not single preheader?
    //find initial value
    //loop.getLoopPreheader()->print(dbgs(), false);
    //loop.getHeader()->print(dbgs(), false);
    //Find the iteration variable for our loop.
    auto counter_var = findInductionVariable(loop.getHeader());
    DEBUG(dbgs() << "Iteration variable: " << *counter_var <<"\n");
    //Find the iteration variable for our loop.
    findCondition(loop.getHeader(), counter_var);
    //Find the initial value for our iteration variable.
    //FIXME: what if there is not single preheader?
    assert(loop.getLoopPreheader() && "Preheader does not exist!");
    //findValue(std::get<)
    for(BasicBlock * BB : loop.getBlocks())
    {
        //DEBUG(dbgs() << "basicb name: "<< BB->getName() <<"\n");
        //BB->print(dbgs(), false);
    }
    return {};
}

// Look for a load in the verification condition.
// If there's one, it should load our iteration variable.
// Works now only with a single condition
// TODO: what about multiple conditions?
Value* LoopAnalyzer::findInductionVariable(BasicBlock * header) const
{
    Value * iter_variable = nullptr;
    for(Instruction & instr : *header)
    {
        if(instr.getOpcode() == Instruction::Load) {
            assert(!iter_variable &&
                   "Multiple load instructions, not supported!");
            iter_variable = instr.getOperand(0);
        }
    }
    assert(iter_variable && "Iteration variable not found!");
    return iter_variable;
}

// Decompose condition
CmpInst* LoopAnalyzer:: findCondition(BasicBlock * header, Value * loopVar) const
{
    CmpInst * compare_instr = nullptr;
    for(Instruction & instr : *header)
    {
        if (instr.getOpcode() == Instruction::ICmp) {
            assert(!compare_instr &&
                   "Multiple compare instructions, not supported!");
            compare_instr = dyn_cast<CmpInst>(&instr);
            DEBUG(dbgs() << "Constant: " << compare_instr->getValueID() - Value::InstructionVal << " " << Value::BasicBlockVal << '\n');

            // Predicate: CmpInst::getPredicateName(CI->getPredicate())
            //DEBUG(dbgs() << CmpInst::getPredicateName(CI->getPredicate()) << '\n');

            // Operands should include: loaded counter and the value to
            // compare against
            for(int i = 0; i < instr.getNumOperands(); ++i) {

                // If it's a constant it must be the other side of inequality
                if(Constant * cons = dyn_cast<Constant>(instr.getOperand(i))) {
                    if(ConstantInt * cons_int = dyn_cast<ConstantInt>(cons)) {
                        DEBUG(dbgs() << "Constant: " << cons_int->getValue() << '\n');
                    } else {
                        assert(false && "Non-integer constants not supported!");
                    }
                }
                // If it's a load operation, the source might be the value
                // used in comparison or our counter.
                else if(Value * val = findLoadedValue(instr.getOperand(i))) {
                    DEBUG(dbgs() << "Loaded value: " << compareValues(val, loopVar) << '\n');
                }
            }
        }
    }
    assert(compare_instr && "Condition not found!");
}

// Find a source of used operand. It might be a constant, it might undefined.
Value * LoopAnalyzer::findLoadedValue(Value * instr) const
{
    // Returns null when it's not a load instruction
    if(LoadInst * inst = dyn_cast<LoadInst>(instr)) {
        Value * value = inst->getOperand(0);
        // If it's an allocation, return the name of allocated variable
        if(AllocaInst * allocInst = dyn_cast<AllocaInst>(value)) {
            DEBUG(dbgs() << "Alloca: " << *allocInst->getOperand(0) << " " << allocInst->getValueName()->getKey() << " " << *allocInst->getType() << " " << allocInst->getName() << '\n');
            return allocInst;
        }
    }
    assert(false && "Unknown value type!");
    return nullptr;
}

bool LoopAnalyzer::compareValues(Value * first, Value * second) const
{
    if(AllocaInst * first_inst = dyn_cast<AllocaInst>(first)) {
        if(AllocaInst * second_inst = dyn_cast<AllocaInst>(second)) {
            return first_inst->getName() == second_inst->getName();
        }
    }
    assert(false);
}