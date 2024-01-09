//===- P2ExpandPseudosPass - P2 expand pseudo instructions ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass expands pseudo instructions into real propeller instrucitons
// The only two instructions here can probably be moved to P2InstrInfo
// and this pass be removed.
// 
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

    // first call getqx so that we flush it out of the cordic. This is in case another cordic operation
    // after this calls get qx before it's done. 
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQX), SI.getOperand(0).getReg())
            .addReg(P2::QX)
            .addImm(P2::ALWAYS)
            .addImm(P2::NOEFF);
    BuildMI(*SI.getParent(), SI, SI.getDebugLoc(), TII->get(P2::GETQY), SI.getOperand(0).getReg())
            .addReg(P2::QY)
            .addImm(P2::ALWAYS)
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
