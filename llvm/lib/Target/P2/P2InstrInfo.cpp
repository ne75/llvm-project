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
            .addImm(MI.getOperand(1).getImm() >> 32)
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
            .addImm(P2::WC);
        
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
            .addImm(P2::WC);

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
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addImm(MI.getOperand(2).getImm() & 0xffffffff)
            .addImm(P2::ALWAYS)
            .addImm(P2::WC);
        
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
            .addImm(P2::WC);

        BuildMI(*mbb, MI, dl, get(P2::ORrr))
            .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(1).getReg(), P2::sub1))
            .addReg(RI.getSubReg(MI.getOperand(2).getReg(), P2::sub0))
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
            .addImm(P2::WC);
        
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
            .addImm(P2::WC);

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

    BuildMI(*mbb, MI, dl, get(P2::ANDri))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(0x80000000)
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

    BuildMI(*mbb, MI, dl, get(P2::ANDri))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addReg(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub1))
        .addImm(0x80000000)
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
    BuildMI(*mbb, MI, dl, get(P2::MOVrr))
        .addDef(RI.getSubReg(MI.getOperand(0).getReg(), P2::sub0))
        .addReg(MI.getOperand(1).getReg())
        .addImm(P2::ALWAYS)
        .addImm(P2::NOEFF);

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

/* Branch Analysis */

static bool isTJOpcode(MachineInstr &I) {
    return (I.getOpcode() == P2::TJNZri || 
            I.getOpcode() == P2::TJNZrr ||
            I.getOpcode() == P2::TJZri || 
            I.getOpcode() == P2::TJZrr);
}

static bool isCondBranchOpcode(MachineInstr &I) {
    if (I.getOpcode() != P2::JMP && !isTJOpcode(I)) return false; // not a branch.

    LLVM_DEBUG(errs() << "is cond branch? ");
    LLVM_DEBUG(I.dump());

    if (I.getOpcode() == P2::JMP)
        return I.getOperand(2).getImm() != P2::ALWAYS;

    return true; // this is a TJ* instruction, which are always conditional. 
}

/// Analyze the branching code at the end of MBB, returning
/// true if it cannot be understood (e.g. it's a switch dispatch or isn't
/// implemented for a target).  Upon success, this returns false and returns
/// with the following information in various cases:
///
/// 1. If this block ends with no branches (it just falls through to its succ)
///    just return false, leaving TBB/FBB null.
/// 2. If this block ends with only an unconditional branch, it sets TBB to be
///    the destination block.
/// 3. If this block ends with a conditional branch and it falls through to a
///    successor block, it sets TBB to be the branch destination block and a
///    list of operands that evaluate the condition. These operands can be
///    passed to other TargetInstrInfo methods to create new branches.
/// 4. If this block ends with a conditional branch followed by an
///    unconditional branch, it returns the 'true' destination in TBB, the
///    'false' destination in FBB, and a list of operands that evaluate the
///    condition.  These operands can be passed to other TargetInstrInfo
///    methods to create new branches.
///
/// Note that RemoveBranch and insertBranch must be implemented to support
/// cases where this method returns success.
///
/// If AllowModify is true, then this routine is allowed to modify the basic
/// block (e.g. delete instructions after the unconditional branch).

// MBB: this machine block
// TBB: true basic block (where to jump when true)
// FBB: false basic block (where to jump when false)
// Cond: list of condition operands
bool P2InstrInfo::analyzeBranch(MachineBasicBlock &MBB, MachineBasicBlock *&TBB, MachineBasicBlock *&FBB,
                                   SmallVectorImpl<MachineOperand> &Cond, bool AllowModify) const {

    LLVM_DEBUG(errs() << "P2 Analyze Branch MBB: ");
    LLVM_DEBUG(MBB.dump());
    int old_br_code;

    // Start from the bottom of the block and work up, examining the
    // terminator instructions.
    MachineBasicBlock::iterator I = MBB.end();
    while (I != MBB.begin()) {
        --I;
        if (I->isDebugInstr()) continue;

        // Working from the bottom, when we see a non-terminator
        // instruction, we're done.
        if (!isUnpredicatedTerminator(*I)) {
            LLVM_DEBUG(errs() << "Not a terminator: ");
            LLVM_DEBUG(I->dump());
            break;
        }

        // A terminator that isn't a branch can't easily be handled
        // by this analysis.
        if (!I->isBranch()) {
            LLVM_DEBUG(I->dump());
            LLVM_DEBUG(errs() << "   is not a branch\n");
            return true;
        }

        // Cannot handle indirect branches.
        if (I->getOpcode() == P2::JMPr)
            return true;

        // Handle unconditional branches.
        if (!isCondBranchOpcode(*I)) {
            LLVM_DEBUG(I->dump());
            LLVM_DEBUG(errs() << "   is an unconditional branch\n");

            LLVM_DEBUG(errs() << "jump destination is: ");
            LLVM_DEBUG(I->getOperand(0).getMBB());

            if (!AllowModify) {
                TBB = I->getOperand(0).getMBB();
                continue;
            }

            // If the block has any instructions after a JMP, delete them.
            while (std::next(I) != MBB.end()) std::next(I)->eraseFromParent();
            Cond.clear();
            FBB = nullptr;

            // Delete the JMP if it's equivalent to a fall-through.
            if (MBB.isLayoutSuccessor(I->getOperand(0).getMBB())) {
                LLVM_DEBUG(errs() << "  this is equivalent to a fallthrough\n");
                TBB = nullptr;
                I->eraseFromParent();
                I = MBB.end();
                continue;
            }

            // TBB is used to indicate the unconditinal destination.
            TBB = I->getOperand(0).getMBB();
            continue;
        }

        // TODO: fix operand indices here
        // Handle conditional branches.
        assert(isCondBranchOpcode(*I) && "Invalid conditional branch");
        LLVM_DEBUG(I->dump());
        LLVM_DEBUG(errs() << "  is a conditional branch\n");

        unsigned dest_op_idx = 0;
        unsigned cond_op_idx = 1;
        if (isTJOpcode(*I)) {
            dest_op_idx = 1;
            cond_op_idx = 0;
        }

        int BranchCode = I->getOperand(2).getImm(); // condition code

        // Working from the bottom, handle the first conditional branch.
        if (Cond.empty()) {
            FBB = TBB;
            TBB = I->getOperand(dest_op_idx).getMBB();
            Cond.push_back(I->getOperand(cond_op_idx));
            Cond.push_back(MachineOperand::CreateImm(BranchCode)); // create an immediate with the branch condition code
            old_br_code = BranchCode;
            continue;
        }

        // Handle subsequent conditional branches. Only handle the case where all
        // conditional branches branch to the same destination.
        assert(Cond.size() == 1);
        assert(TBB);

        // Only handle the case where all conditional branches branch to
        // the same destination.
        if (TBB != I->getOperand(dest_op_idx).getMBB()) return true;

        // If the conditions are the same, we can leave them alone.
        if (old_br_code == BranchCode) continue;

        return true;
    }

    return false;
}

unsigned P2InstrInfo::insertBranch(MachineBasicBlock &MBB, MachineBasicBlock *TBB, MachineBasicBlock *FBB,
                                    ArrayRef<MachineOperand> Cond, const DebugLoc &dl, int *BytesAdded) const {


    LLVM_DEBUG(errs() << "P2 Insert Branch MBB: ");
    LLVM_DEBUG(MBB.dump());

    // Shouldn't be a fall through.
    assert(TBB && "insertBranch must not be told to insert a fallthrough");
    assert((Cond.size() == 2 || Cond.size() == 0) && "P2 branch conditions have one component!");
    assert(!BytesAdded && "code size not handled");

    if (Cond.empty()) {
        // Unconditional branch?
        assert(!FBB && "Unconditional branch with multiple successors!");
        BuildMI(&MBB, dl, get(P2::JMP)).addMBB(TBB).addImm(1).addImm(P2::ALWAYS);
        return 1;
    }

    for (int i = 0; i < Cond.size(); i++) {
        LLVM_DEBUG(errs() << "cond operand: ");
        LLVM_DEBUG(Cond[i].dump());
    }

    // Conditional branch.
    unsigned Count = 0;
    BuildMI(&MBB, dl, get(P2::JMP)).addMBB(TBB).add(Cond[0]).add(Cond[1]);
    ++Count;

    if (FBB) {
        // Two-way Conditional branch. Insert the second branch.
        BuildMI(&MBB, dl, get(P2::JMP)).addMBB(FBB).addImm(1).addImm(P2::ALWAYS);
        ++Count;
    }

    return Count;
}

unsigned P2InstrInfo::removeBranch(MachineBasicBlock &MBB, int *BytesRemoved) const {
    assert(!BytesRemoved && "code size not handled");

    MachineBasicBlock::iterator I = MBB.end();
    unsigned Count = 0;

    while (I != MBB.begin()) {
        --I;
        if (I->isDebugInstr()) continue;

        if (!isCondBranchOpcode(*I) &&
            I->getOpcode() != P2::JMPr &&
            I->getOpcode() != P2::JMP) break;

        // Remove the branch.
        I->eraseFromParent();
        I = MBB.end();
        ++Count;
    }

    return Count;
}