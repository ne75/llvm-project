//===-- P2FrameLowering.cpp - P2 Frame Information --------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the P2 implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "P2FrameLowering.h"

#include "P2InstrInfo.h"
#include "P2TargetMachine.h"
#include "P2MachineFunctionInfo.h"
#include "MCTargetDesc/P2BaseInfo.h"

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetOptions.h"

#define DEBUG_TYPE "p2-frame-lower"

using namespace llvm;

void P2FrameLowering::emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const {
    LLVM_DEBUG(dbgs() << "Emit Prologue: " << MF.getName() << "\n");

    const P2InstrInfo *TII = MF.getSubtarget<P2Subtarget>().getInstrInfo();
    MachineBasicBlock::iterator MBBI = MBB.begin();
    P2FunctionInfo *P2FI = MF.getInfo<P2FunctionInfo>();
    MachineFrameInfo &MFI = MF.getFrameInfo();

    LLVM_DEBUG(errs() << "Frame Info:\n");
    LLVM_DEBUG(MFI.dump(MF));

    if (MF.getFunction().hasFnAttribute("cogmain")) {
        LLVM_DEBUG(errs() << "cog entry function, saving ptra[0] to r0\n");
        DebugLoc DL = MBB.findDebugLoc(MBBI);
        BuildMI(MBB, MBBI, DL, TII->get(P2::RDLONGrr))
            .addDef(P2::R0)
            .addReg(P2::PTRA)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    // the stack gets preallocated for incoming arguments + 4 bytes for the PC/SW + regs already saved to the stack
    // there might be a better way to encode this data in other variables sutch that MFI.getStackSize() already 
    // returns the correct value, but leave the adjustment here for now
    uint64_t StackSize = MFI.getStackSize() - 4 - P2FI->getIncomingArgSize() - P2FI->getCalleeSavedFrameSize();
    LLVM_DEBUG(errs() << "Allocating " << StackSize << " bytes for stack (original value: " << MFI.getStackSize() << ")\n");
    LLVM_DEBUG(errs() << "* Incoming arg size: " << P2FI->getIncomingArgSize() << "\n");
    LLVM_DEBUG(errs() << "* Callee saved frame size: " << P2FI->getCalleeSavedFrameSize() << "\n");

    // No need to allocate space on the stack.
    if (StackSize == 0) {
        LLVM_DEBUG(errs() << "No need to allocate stack space\n");
        return;
    }

    // we want to iterate MBBI until we hit the first function instruction, we marked the callee saving instructions
    // as FrameSetup instructions
    if (P2FI->getCalleeSavedFrameSize())
        while ((*MBBI).getFlag(MachineInstr::FrameSetup)) MBBI++;

    TII->adjustStackPtr(P2::PTRA, StackSize, MBB, MBBI);
}

void P2FrameLowering::emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const {
    LLVM_DEBUG(dbgs() << "Emit Epilogue: " << MF.getName() << "\n");
    MachineBasicBlock::iterator MBBI = MBB.getLastNonDebugInstr();
    const MachineFrameInfo &MFI = MF.getFrameInfo();
    P2FunctionInfo *P2FI = MF.getInfo<P2FunctionInfo>();

    const P2InstrInfo *TII = MF.getSubtarget<P2Subtarget>().getInstrInfo();
    uint64_t StackSize = MFI.getStackSize() - 4 - P2FI->getIncomingArgSize() - P2FI->getCalleeSavedFrameSize();

    LLVM_DEBUG(errs() << "Frame Info:\n");
    LLVM_DEBUG(MFI.dump(MF));

    // allocate 0s for now for testing
    if (StackSize == 0) {
        LLVM_DEBUG(errs() << "No need to de-allocate stack space\n");
        return;
    }

    // back up before the callee restore instructions/return instruction, then insert the stack pointer adjustment
    if (P2FI->getCalleeSavedFrameSize())
        while (MBBI != MBB.begin() && MBBI->getPrevNode()->getFlag(MachineInstr::FrameDestroy)) MBBI--;

    // Adjust stack.
    TII->adjustStackPtr(P2::PTRA, -StackSize, MBB, MBBI);
}

void P2FrameLowering::determineCalleeSaves(MachineFunction &MF, BitVector &SavedRegs, RegScavenger *RS) const {

    LLVM_DEBUG(errs() << "=== Function: " << MF.getName() << " ===\n");
    LLVM_DEBUG(errs() << "Determining callee saves\n");

    if (MF.getFunction().hasFnAttribute("cogmain")) {
        return;
    }

    TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);
    // eventually might need to add to this to re-order the frame index based to match what will happen in spilling/restoring
}

namespace {
// Model every register touched by SETQ block transfers. The first register is
// explicit; the remaining registers and PTRA's update are implicit operands.
void emitCSRBlock(MachineBasicBlock &MBB, MachineBasicBlock::iterator Where,
                  ArrayRef<CalleeSavedInfo> CSI, unsigned Begin, unsigned End,
                  const TargetInstrInfo &TII, bool Restore) {
    MachineFunction &MF = *MBB.getParent();
    DebugLoc DL = MBB.findDebugLoc(Where);
    auto Flag = Restore ? MachineInstr::FrameDestroy : MachineInstr::FrameSetup;
    unsigned Count = End - Begin;
    if (Count > 1)
        BuildMI(MBB, Where, DL, TII.get(P2::SETQi))
            .addImm(Count - 1).addImm(P2::ALWAYS).setMIFlag(Flag);
    auto Transfer = BuildMI(MBB, Where, DL,
                           TII.get(Restore ? P2::RDLONGri : P2::WRLONGri));
    Transfer.addReg(CSI[Begin].getReg(), Restore ? RegState::Define : 0)
        .addImm(Restore ? P2::PTRA_PREDEC : P2::PTRA_POSTINC)
        .addImm(P2::ALWAYS);
    if (Restore)
        Transfer.addImm(P2::NOEFF);
    for (unsigned I = Begin + 1; I < End; ++I)
        Transfer.addReg(CSI[I].getReg(), Restore ? RegState::ImplicitDefine
                                                : RegState::Implicit);
    Transfer.addReg(P2::PTRA, RegState::Implicit)
        .addReg(P2::PTRA, RegState::ImplicitDefine)
        .addMemOperand(MF.getMachineMemOperand(
            MachinePointerInfo(), Restore ? MachineMemOperand::MOLoad
                                          : MachineMemOperand::MOStore,
            Count * 4, Align(1)))
        .setMIFlag(Flag);
}
}

bool P2FrameLowering::spillCalleeSavedRegisters(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
    ArrayRef<CalleeSavedInfo> CSI, const TargetRegisterInfo *TRI) const {
    if (CSI.empty())
        return false;
    const auto &TII = *MBB.getParent()->getSubtarget<P2Subtarget>().getInstrInfo();
    for (const auto &Saved : CSI)
        if (!MBB.isLiveIn(Saved.getReg()))
            MBB.addLiveIn(Saved.getReg());
    for (unsigned Begin = 0, End; Begin < CSI.size(); Begin = End) {
        End = Begin + 1;
        while (End < CSI.size() &&
               TRI->getEncodingValue(CSI[End].getReg()) ==
                   TRI->getEncodingValue(CSI[End - 1].getReg()) + 1)
            ++End;
        emitCSRBlock(MBB, MI, CSI, Begin, End, TII, false);
    }
    MBB.getParent()->getInfo<P2FunctionInfo>()->setCalleeSavedFrameSize(CSI.size() * 4);
    return true;
}

bool P2FrameLowering::restoreCalleeSavedRegisters(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator MI,
    MutableArrayRef<CalleeSavedInfo> CSI, const TargetRegisterInfo *TRI) const {
    if (CSI.empty())
        return false;
    const auto &TII = *MBB.getParent()->getSubtarget<P2Subtarget>().getInstrInfo();
    for (unsigned End = CSI.size(), Begin; End; End = Begin) {
        Begin = End - 1;
        while (Begin && TRI->getEncodingValue(CSI[Begin].getReg()) ==
                            TRI->getEncodingValue(CSI[Begin - 1].getReg()) + 1)
            --Begin;
        emitCSRBlock(MBB, MI, CSI, Begin, End, TII, true);
    }
    return true;
}

MachineBasicBlock::iterator P2FrameLowering::eliminateCallFramePseudoInstr(MachineFunction &MF, MachineBasicBlock &MBB,
                                MachineBasicBlock::iterator I) const {

    LLVM_DEBUG(errs() << "=== eliminate call frame pseudo\n");

    int64_t adjust = I->getOperand(0).getImm();
    auto opc = I->getOpcode();
    MachineBasicBlock::iterator IStart;

    if (opc == P2::ADJCALLSTACKDOWN) {
        LLVM_DEBUG(errs() << "Adjust down\n");
        LLVM_DEBUG(errs() << "block: \n");
        LLVM_DEBUG(MBB.dump());

        // move backwards until we get to the call instruction
        adjust = -adjust;
        I = MBB.erase(I); // erase the psuedo
        IStart = I;

        if (I == MBB.end()) I--;

        auto op = I->getOpcode();
        while (op != P2::CALL && op != P2::CALLa && op != P2::CALLAa && op != P2::CALLAr && op != P2::CALLr) {
            I--; // skip back to the call instruction.
            op = I->getOpcode();
        }

        I++; // go forward one to insert after the call
    } else if (opc == P2::ADJCALLSTACKUP) {
        LLVM_DEBUG(errs() << "Adjust up\n");
        LLVM_DEBUG(errs() << "block: \n");
        LLVM_DEBUG(MBB.dump());

        I = MBB.erase(I); // first erase our psuedo instruction.
        IStart = I;

        auto op = I->getOpcode();
        while (op != P2::CALL && op != P2::CALLa && op != P2::CALLAa && op != P2::CALLAr && op != P2::CALLr) {
            I++; // skip ahead to the call instruction.
            op = I->getOpcode();
        }
    }

    // adjust the stack pointer, if necessary
    if (adjust)
        tm.getInstrInfo()->adjustStackPtr(P2::PTRA, adjust, MBB, I);

    // move back to where we started, in case we skipped over a frame index instruction that needs elimination
    while (I != IStart) 
        if (opc == P2::ADJCALLSTACKUP) I--;
        else if (opc == P2::ADJCALLSTACKDOWN) I++;

    return I;
}