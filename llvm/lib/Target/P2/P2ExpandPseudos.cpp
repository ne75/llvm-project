//===- P2ExpandPseudosPass - P2 expand pseudo instructions ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass expands pseudo instructions into real propeller instrucitons
//===----------------------------------------------------------------------===//

#include "P2.h"
#include "P2InstrInfo.h"
#include "P2RegisterInfo.h"
#include "P2Subtarget.h"
#include "P2TargetMachine.h"
#include "MCTargetDesc/P2BaseInfo.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

#define DEBUG_TYPE "p2-expand-pseudos"

namespace {

    class P2ExpandPseudos : public MachineFunctionPass {
    public:
        static char ID;
        P2ExpandPseudos(P2TargetMachine &tm) : MachineFunctionPass(ID), TM(tm) {}

        bool runOnMachineFunction(MachineFunction &Fn) override;

        StringRef getPassName() const override { return "P2 Expand Pseudos"; }

    private:
        const P2InstrInfo *TII;
        const P2TargetMachine &TM;

        void expand_QUDIV(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_QUREM(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_SELECTCC(MachineFunction &MF, MachineBasicBlock::iterator SII);
        void expand_MOVi64(MachineFunction &MF, MachineBasicBlock::iterator SII);
    };

    char P2ExpandPseudos::ID = 0;

} // end anonymous namespace

void P2ExpandPseudos::expand_QUDIV(MachineFunction &MF, MachineBasicBlock::iterator SII) {
    MachineInstr &SI = *SII;

    LLVM_DEBUG(errs()<<"== lower pseudo unsigned division\n");
    LLVM_DEBUG(SI.dump());

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::QDIVrr))
            .addReg(SI.getOperand(1).getReg())
            .addReg(SI.getOperand(2).getReg())
            .addImm(P2::ALWAYS);
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQX), SI.getOperand(0).getReg())
            .addReg(P2::QX)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

    SI.eraseFromParent();
}

void P2ExpandPseudos::expand_QUREM(MachineFunction &MF, MachineBasicBlock::iterator SII) {
    MachineInstr &SI = *SII;

    LLVM_DEBUG(errs()<<"== lower pseudo unsigned remainder\n");
    LLVM_DEBUG(SI.dump());

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::QDIVrr))
            .addReg(SI.getOperand(1).getReg())
            .addReg(SI.getOperand(2).getReg())
            .addImm(P2::ALWAYS);
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQY), SI.getOperand(0).getReg())
            .addReg(P2::QY)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);

    SI.eraseFromParent();
}

/*
 * expand to
 * mov d (operand 0), f (operand 4)
 * cmp lhs (operand 1), rhs (operand 2)
 * <cond move> d (operand 0), t (operand 3) based on operand 5
 */
void P2ExpandPseudos::expand_SELECTCC(MachineFunction &MF, MachineBasicBlock::iterator SII) {
    MachineInstr &SI = *SII;
    auto &MRI = MF.getRegInfo();
    auto TRI = TM.getRegisterInfo();

    LLVM_DEBUG(errs()<<"== lower selectcc\n");
    LLVM_DEBUG(SI.dump());

    const MachineOperand &d = SI.getOperand(0);     // always a register
    const MachineOperand &lhs = SI.getOperand(1);   // always a register
    const MachineOperand &rhs = SI.getOperand(2);   // register or immediate
    const MachineOperand &t = SI.getOperand(3);     // register or immediate
    const MachineOperand &f = SI.getOperand(4);     // register or immediate
    int cc = SI.getOperand(5).getImm();             // condition code

    unsigned movt_op = P2::MOVrr;
    unsigned movf_op = P2::MOVrr;
    unsigned cmp_op;
    unsigned cmp_op_hi;

    if (f.isImm()) {
        movf_op = P2::MOVri;
    }

    if (t.isImm()) {
        movt_op = P2::MOVri;
    }

    switch(cc) {
        case P2::SETUEQ:
        case P2::SETUNE:
        case P2::SETULE:
        case P2::SETULT:
        case P2::SETUGT:
        case P2::SETUGE:
            if (rhs.isImm()) {
                cmp_op = P2::CMPri;
                cmp_op_hi = P2::CMPXri;
            } else {
                cmp_op = P2::CMPrr;
                cmp_op_hi = P2::CMPXrr;
            }
            break;

        case P2::SETEQ:
        case P2::SETNE:
        case P2::SETLE:
        case P2::SETLT:
        case P2::SETGT:
        case P2::SETGE:
            if (rhs.isImm()) {
                cmp_op = P2::CMPSri;
                cmp_op_hi = P2::CMPSXri;
            } else {
                cmp_op = P2::CMPSrr;
                cmp_op_hi = P2::CMPSXrr;
            }
            break;
        default:
            llvm_unreachable("unknown condition code in expand_SELECTCC for cmp");
    }

    int true_cond_imm;
    int false_cond_imm;

    switch(cc) {
        case P2::SETUEQ:
        case P2::SETEQ:
            true_cond_imm = P2::IF_Z;
            false_cond_imm = P2::IF_NZ;
            break;
        case P2::SETUNE:
        case P2::SETNE:
            true_cond_imm = P2::IF_NZ;
            false_cond_imm = P2::IF_Z;
            break;
        case P2::SETULE:
        case P2::SETLE:
            true_cond_imm = P2::IF_C;
            false_cond_imm = P2::IF_NC;
            break;
        case P2::SETULT:
        case P2::SETLT:
            true_cond_imm = P2::IF_C_OR_Z;
            false_cond_imm = P2::IF_NC_AND_NZ;
            break;
        case P2::SETUGT:
        case P2::SETGT:
            true_cond_imm = P2::IF_NC_AND_NZ;
            false_cond_imm = P2::IF_C_OR_Z;
            break;
        case P2::SETUGE:
        case P2::SETGE:
            true_cond_imm = P2::IF_NC;
            false_cond_imm = P2::IF_C;
            break;
        default:
            llvm_unreachable("unknown condition code in expand_SELECTCC for move");
    }

    // mov false into the destination
    // this is the 32 bit compare. write a custom routine to build a 64 bit compare that gives the same flag state. 
    LLVM_DEBUG(errs() << "lhs: ");
    LLVM_DEBUG(lhs.dump());

    if (TRI->getRegClass(P2::P2GPRRegClassID) == MRI.getRegClass(lhs.getReg())) {
        LLVM_DEBUG(errs() << "32 bit condition\n");
        BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(cmp_op), P2::SW)
            .addReg(lhs.getReg())
            .add(rhs)
            .addImm(P2::ALWAYS).addImm(P2::WCZ);
    } else {
        // 64 bit compare 
        // 1. compare low words, writing cz. 
        // 2. compare high words, with extended op, writing cz
        //
        // then, the moves can be correctly executed based on the flags 
        LLVM_DEBUG(errs() << "64 bit condition\n");

        if (rhs.isImm()) {
            // low compare
            BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(cmp_op), P2::SW)
                .addReg(lhs.getReg(), 0, P2::sub0)
                .addImm(rhs.getImm() & 0xffffffff)
                .addImm(P2::ALWAYS).addImm(P2::WCZ);

            // high compare
            BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(cmp_op_hi), P2::SW)
                .addReg(lhs.getReg(), 0, P2::sub1)
                .addImm(rhs.getImm() >> 32)
                .addImm(P2::ALWAYS).addImm(P2::WCZ);
        } else {
            // low compare
            BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(cmp_op), P2::SW)
                .addReg(lhs.getReg(), 0, P2::sub0)
                .addReg(rhs.getReg(), 0, P2::sub0)
                .addImm(P2::ALWAYS).addImm(P2::WCZ);

            // high compare
            BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(cmp_op_hi), P2::SW)
                .addReg(lhs.getReg(), 0, P2::sub1)
                .addReg(rhs.getReg(), 0, P2::sub1)
                .addImm(P2::ALWAYS).addImm(P2::WCZ);
        }
    }

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(movt_op), d.getReg())
        .add(t)
        .addImm(true_cond_imm)
        .addImm(P2::NOEFF);

    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(movf_op))
        .addReg(d.getReg())
        .add(f)
        .addImm(false_cond_imm)
        .addImm(P2::NOEFF);

    SI.eraseFromParent();
}

bool P2ExpandPseudos::runOnMachineFunction(MachineFunction &MF) {
    TII = TM.getInstrInfo();

    for (auto &MBB : MF) {
        MachineBasicBlock::iterator MBBI = MBB.begin(), E = MBB.end();
        while (MBBI != E) {
            MachineBasicBlock::iterator NMBBI = std::next(MBBI);
            switch (MBBI->getOpcode()) {
                case P2::QUDIV:
                    expand_QUDIV(MF, MBBI);
                    break;
                case P2::QUREM:
                    expand_QUREM(MF, MBBI);
                    break;
            }

            MBBI = NMBBI;
        }
    }

    LLVM_DEBUG(errs()<<"done with pseudo expansion\n");

    return true;
}

FunctionPass *llvm::createP2ExpandPseudosPass(P2TargetMachine &tm) {
    return new P2ExpandPseudos(tm);
}
