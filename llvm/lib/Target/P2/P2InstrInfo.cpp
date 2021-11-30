//===-- P2InstrInfo.cpp - P2 Instruction Information ------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains the P2 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "P2InstrInfo.h"

#include "P2TargetMachine.h"
#include "P2MachineFunctionInfo.h"
#include "MCTargetDesc/P2BaseInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

#define DEBUG_TYPE "p2-inst-info"

#define GET_INSTRINFO_CTOR_DTOR
#include "P2GenInstrInfo.inc"

// Pin the vtable to this file.
void P2InstrInfo::anchor() {}

P2InstrInfo::P2InstrInfo() : P2GenInstrInfo(P2::ADJCALLSTACKUP, P2::ADJCALLSTACKDOWN), RI() {}

void P2InstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB, MachineBasicBlock::iterator MI, Register DestReg, int FrameIndex,
                                        const TargetRegisterClass *RC, const TargetRegisterInfo *TRI) const {
    DebugLoc DL;
    if (MI != MBB.end()) {
        DL = MI->getDebugLoc();
    }

    MachineFunction &MF = *MBB.getParent();
    const MachineFrameInfo &MFI = MF.getFrameInfo();

    MachineMemOperand *MMO = MF.getMachineMemOperand(
        MachinePointerInfo::getFixedStack(MF, FrameIndex),
        MachineMemOperand::MOLoad, MFI.getObjectSize(FrameIndex),
        MFI.getObjectAlign(FrameIndex));

    if (TRI->isTypeLegalForClass(*RC, MVT::i32)) {
        BuildMI(MBB, MI, DL, get(P2::RDLONGri), DestReg)
            .addFrameIndex(FrameIndex)
            .addMemOperand(MMO)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else if (TRI->isTypeLegalForClass(*RC, MVT::i64)) {
        BuildMI(MBB, MI, DL, get(P2::RDDLONG), DestReg)
            .addFrameIndex(FrameIndex)
            .addMemOperand(MMO);
    } else {
        llvm_unreachable("Cannot load this register from a stack slot!");
    }

    LLVM_DEBUG(errs() << ">> load reg " << DestReg << " from stack " << FrameIndex << "\n");
}

void P2InstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                               MachineBasicBlock::iterator MI,
                               const DebugLoc &DL, MCRegister DestReg,
                               MCRegister SrcReg, bool KillSrc) const {

    if (SrcReg == P2::QX) {
        BuildMI(MBB, MI, DL, get(P2::GETQX), DestReg).addReg(P2::QX).addImm(P2::ALWAYS).addImm(P2::NOEFF);
    } else if (SrcReg == P2::QY) {
        BuildMI(MBB, MI, DL, get(P2::GETQY), DestReg).addReg(P2::QY).addImm(P2::ALWAYS).addImm(P2::NOEFF);
    } else {
        if (RI.getRegClass(P2::P2GPRPairRegClassID)->MC->contains(DestReg, SrcReg)) {
            BuildMI(MBB, MI, DL, get(P2::MOVrr))
                .addReg(RI.getSubReg(DestReg, P2::sub0))
                .addReg(RI.getSubReg(SrcReg, P2::sub0), getKillRegState(KillSrc))
                .addImm(P2::ALWAYS)
                .addImm(P2::NOEFF);

            BuildMI(MBB, MI, DL, get(P2::MOVrr))
                .addReg(RI.getSubReg(DestReg, P2::sub1))
                .addReg(RI.getSubReg(SrcReg, P2::sub1), getKillRegState(KillSrc))
                .addImm(P2::ALWAYS)
                .addImm(P2::NOEFF);
        } else {
            BuildMI(MBB, MI, DL, get(P2::MOVrr), DestReg)
                .addReg(SrcReg, getKillRegState(KillSrc))
                .addImm(P2::ALWAYS)
                .addImm(P2::NOEFF);
        }        
    }
}

void P2InstrInfo::storeRegToStackSlot(MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator MI,
                                        Register SrcReg, bool isKill,
                                        int FrameIndex,
                                        const TargetRegisterClass *RC,
                                        const TargetRegisterInfo *TRI) const {
    MachineFunction &MF = *MBB.getParent();

    DebugLoc DL;
    if (MI != MBB.end()) {
        DL = MI->getDebugLoc();
    }

    const MachineFrameInfo &MFI = MF.getFrameInfo();

    LLVM_DEBUG(errs() << ">> store reg " << SrcReg << " to stack frame index " << FrameIndex << "\n");

    MachineMemOperand *MMO = MF.getMachineMemOperand(
        MachinePointerInfo::getFixedStack(MF, FrameIndex),
        MachineMemOperand::MOStore, MFI.getObjectSize(FrameIndex),
        MFI.getObjectAlign(FrameIndex));

    if (TRI->isTypeLegalForClass(*RC, MVT::i32)) {
        BuildMI(MBB, MI, DL, get(P2::WRLONGri))
            .addReg(SrcReg, getKillRegState(isKill))
            .addFrameIndex(FrameIndex)
            .addMemOperand(MMO)
            .addImm(P2::ALWAYS);
    } else if (TRI->isTypeLegalForClass(*RC, MVT::i64)) {
        BuildMI(MBB, MI, DL, get(P2::WRDLONG))
            .addReg(SrcReg, getKillRegState(isKill))
            .addFrameIndex(FrameIndex)
            .addMemOperand(MMO);
    } else {
        llvm_unreachable("Cannot store this register into a stack slot!");
    }
}

void P2InstrInfo::adjustStackPtr(unsigned SP, int64_t amount, MachineBasicBlock &MBB, MachineBasicBlock::iterator I) const {
    DebugLoc DL = I != MBB.end() ? I->getDebugLoc() : DebugLoc();

    unsigned inst = P2::ADDri;

    LLVM_DEBUG(errs() << "adjust stack pointer by " << amount << "\n");

    if (amount < 0) {
        inst = P2::SUBri;
        amount = -amount;
    }

    if (isInt<32>(amount)) {
        if (!isInt<9>(amount)) {
            // if we need more than 9 bits to store amount, augment the next source immediate (which will be added below)
            BuildMI(MBB, I, DL, get(P2::AUGS)).addImm(amount>>9).addImm(P2::ALWAYS);
        }

        BuildMI(MBB, I, DL, get(inst), SP).addReg(SP).addImm(amount&0x1ff).addImm(P2::ALWAYS).addImm(P2::NOEFF);
    } else {
        llvm_unreachable("Cannot adjust stack pointer by more than 32 bits (and adjusting by more than 20 bits never makes sense!)");
    }
}

void P2InstrInfo::expand_MOVi64(MachineInstr &MI) const {
    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(P2::MOVri))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .addImm(MI.getOperand(1).getImm() & 0xffffffff)
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(P2::MOVri))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(MI.getOperand(1).getImm() >> 32)
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    MI.eraseFromParent();
}

void P2InstrInfo::expand_RDDLONG(MachineInstr &MI) const {
    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(P2::SETQi))
        .addImm(1)
        .addImm(P2::ALWAYS);

    unsigned opc = P2::RDLONGrr;
    if (MI.getOperand(1).isImm()) opc = P2::RDLONGri;

    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(opc))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .add(MI.getOperand(1))
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    MI.eraseFromParent();
}

void P2InstrInfo::expand_WRDLONG(MachineInstr &MI) const {
    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(P2::SETQi))
        .addImm(1)
        .addImm(P2::ALWAYS);

    unsigned opc = P2::WRLONGrr;
    if (MI.getOperand(1).isImm()) opc = P2::WRLONGri;

    BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), get(opc))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .add(MI.getOperand(1))
        .addImm(P2::ALWAYS);

    MI.eraseFromParent();
}

void P2InstrInfo::expand_ADD64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    if (MI.getOperand(2).isImm()) {
        BuildMI(*mbb, MI, dl, get(P2::ADDri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::WC);
        
        BuildMI(*mbb, MI, dl, get(P2::ADDXri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() >> 32)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else {
        BuildMI(*mbb, MI, dl, get(P2::ADDrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::WC);

        BuildMI(*mbb, MI, dl, get(P2::ADDXrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub1))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    MI.removeFromParent();
}

void P2InstrInfo::expand_SUB64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    if (MI.getOperand(2).isImm()) {
        BuildMI(*mbb, MI, dl, get(P2::SUBri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::WC);
        
        BuildMI(*mbb, MI, dl, get(P2::SUBXri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() >> 32)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else {
        BuildMI(*mbb, MI, dl, get(P2::SUBrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::WC);

        BuildMI(*mbb, MI, dl, get(P2::SUBXrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub1))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    MI.removeFromParent();
}

void P2InstrInfo::expand_AND64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    if (MI.getOperand(2).isImm()) {
        BuildMI(*mbb, MI, dl, get(P2::ANDri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
        
        BuildMI(*mbb, MI, dl, get(P2::ANDri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() >> 32)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else {
        BuildMI(*mbb, MI, dl, get(P2::ANDrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

        BuildMI(*mbb, MI, dl, get(P2::ANDrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub1))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    MI.removeFromParent();
}

void P2InstrInfo::expand_OR64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    if (MI.getOperand(2).isImm()) {
        BuildMI(*mbb, MI, dl, get(P2::ORri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
        
        BuildMI(*mbb, MI, dl, get(P2::ORri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() >> 32)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else {
        BuildMI(*mbb, MI, dl, get(P2::ORrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

        BuildMI(*mbb, MI, dl, get(P2::ORrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub1))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    MI.removeFromParent();
}

void P2InstrInfo::expand_XOR64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    if (MI.getOperand(2).isImm()) {
        BuildMI(*mbb, MI, dl, get(P2::XORri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
        
        BuildMI(*mbb, MI, dl, get(P2::XORri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() >> 32)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    } else {
        BuildMI(*mbb, MI, dl, get(P2::XORrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

        BuildMI(*mbb, MI, dl, get(P2::XORrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    MI.removeFromParent();
}

void P2InstrInfo::expand_SEXT64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    // to sign extend from a 32 bit to a 64 bit, first copy it to both subregs
    // then, mask the top bit (AND 0x8000_0000), then arithmetic right shift by 31
    BuildMI(*mbb, MI, dl, get(P2::MOVrr))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .addReg(MI.getOperand(1).getReg())
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    BuildMI(*mbb, MI, dl, get(P2::MOVrr))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(MI.getOperand(1).getReg())
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    BuildMI(*mbb, MI, dl, get(P2::SARri))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(31)
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    MI.removeFromParent();
}

void P2InstrInfo::expand_SEXTIR64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    // first, sign extend the lower word based on operand 2. 
    // then perform the same as SEXT64 for the upper word, 

    if (MI.getOperand(2).getImm() < 31) {
        BuildMI(*mbb, MI, dl, get(P2::SIGNXri))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addImm(MI.getOperand(2).getImm())
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    BuildMI(*mbb, MI, dl, get(P2::MOVrr))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    BuildMI(*mbb, MI, dl, get(P2::SARri))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(31)
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);    

     MI.removeFromParent();
}   

void P2InstrInfo::expand_ZEXT64(MachineInstr &MI) const {
    auto mbb = MI.getParent();
    auto dl = MI.getDebugLoc();

    // to zero extend, move the value into the low reg, 0 to the high reg
    // don't do the move if the source and destination are the same
    if (RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0) != MI.getOperand(1).getReg().asMCReg()) {
        BuildMI(*mbb, MI, dl, get(P2::MOVrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
            .addReg(MI.getOperand(1).getReg())
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    }

    BuildMI(*mbb, MI, dl, get(P2::MOVri))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(0)
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

    MI.removeFromParent();
}

bool P2InstrInfo::expandPostRAPseudo(MachineInstr &MI) const {
    switch(MI.getOpcode()) {
        case P2::ADD64ri:
        case P2::ADD64rr:
            expand_ADD64(MI);
            return true;
        
        case P2::SUB64ri:
        case P2::SUB64rr: 
            expand_SUB64(MI);
            return true;

        case P2::AND64ri:
        case P2::AND64rr:
            expand_AND64(MI);
            return true;

        case P2::OR64ri:
        case P2::OR64rr:
            expand_OR64(MI);
            return true;

        case P2::XOR64ri:
        case P2::XOR64rr:
            expand_XOR64(MI);
            return true;

        case P2::RDDLONG:
            expand_RDDLONG(MI);
            return true;

        case P2::WRDLONG:
            expand_WRDLONG(MI);
            return true;

        case P2::MOVi64:
            expand_MOVi64(MI);
            return true;

        case P2::SEXT64:
            expand_SEXT64(MI);
            return true;

        case P2::SEXTIR64:
            expand_SEXTIR64(MI);
            return true;

        case P2::ZEXT64:
            expand_ZEXT64(MI);
            return true;
    } 

    return false;
}