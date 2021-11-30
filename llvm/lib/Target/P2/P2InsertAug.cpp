//===-- P2InsertAug.cpp - P2 InsertAug ------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Pass to insert augs/augd for large immediates.
//
//===----------------------------------------------------------------------===//

#include "P2.h"

#include "P2TargetMachine.h"
#include "MCTargetDesc/P2BaseInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/ADT/SmallSet.h"

using namespace llvm;

#define DEBUG_TYPE "p2-insert-aug"

static cl::opt<bool> EnableDelJmp("enable-p2-insert-aug",
    cl::init(true),
    cl::desc("Insert augs/augd for large immediates"),
    cl::Hidden);

namespace {
    struct P2InsertAug : public MachineFunctionPass {
        static char ID;
        const P2TargetMachine &TM;
        P2InsertAug(const P2TargetMachine &tm) : MachineFunctionPass(ID), TM(tm) {}

        StringRef getPassName() const override {
            return "P2 Insert Augs/Augd";
        }

        /**
         * Insert an aug with the given parameters before MI
         */
        void createAugInst(MachineInstr &MI, int type, int value, int condition) const {
            assert (type == 1 || type == 2 && "Unknown aug type");

            auto *TII = TM.getInstrInfo();
            unsigned opc;

            if (type == 1) {
                opc = P2::AUGS;
            } else {
                opc = P2::AUGD;
            }
            
            BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), TII->get(opc))
                .addImm(value)
                .addImm(condition);
        }

        /**
         * Insert an aug for the given operand
         */
        void createAugInst(MachineInstr &MI, int op_num) const {
            // 1. Figure out if we need augd or augs
            assert(canAug(MI) && "Can't create aug for instruction!\n");
            int aug_type = 0; // 0 = none, 1 = augs, 2 = augd

            bool has_d = P2::hasDField(MI);
            bool has_s = P2::hasSField(MI);
            int s_num = P2::getSNum(MI);
            int d_num = P2::getDNum(MI);

            LLVM_DEBUG(errs() << "has_d = " << has_d << " has_s = " << has_s << " s_num = " << s_num << " d_num = " << d_num << "\n");

            if (has_d && op_num == d_num) {
                aug_type = 2;
            } else if (has_s && op_num == s_num) {
                aug_type = 1;
            }

            LLVM_DEBUG(errs() << "aug_type = " << aug_type << "\n");
            
            // 2. create the MachineInstr
            const MachineOperand &MO = MI.getOperand(op_num);
            int aug_i = 0;

            if (MO.isImm()) { // apply the actual immediate for immediate operands, for others (global address, etc), just insert 0 for later fixup
                aug_i = (MO.getImm() >> 9) & 0x7fffff;
            }

            createAugInst(MI, aug_type, aug_i, P2::getCondition(MI));
        }

        bool canAug(const MachineInstr &MI) const {
            int type = P2::getInstructionForm(MI);

            if (type == P2::P2InstN || 
                type == P2::P2InstWRA ||
                type == P2::P2InstWRA ||
                type == P2::P2InstRA ||
                type == P2::P2InstD || 
                type == P2::P2InstCZ ||
                type == P2::P2InstCZD | 
                type == 0) return false;

            return true;
        }

        bool runOnMachineFunction(MachineFunction &MF) override {
            bool Changed = false;
            LLVM_DEBUG(errs() << "******** P2 INSERT AUG PASS ********\n");

            for (auto &MBB : MF) {
                for (auto &MI : MBB) {
                    LLVM_DEBUG(errs() << "MI to process: ");
                    LLVM_DEBUG(MI.dump());
                    for (unsigned i = 0, e = MI.getNumOperands(); i != e; ++i) {
                        MachineOperand &MO = MI.getOperand(i);

                        if ((MO.isImm() || MO.isGlobal() || MO.isJTI()) && canAug(MI)) {
                            if (MO.isImm()) {
                                // basic immediates
                                int imm = MO.getImm();

                                if (imm >> 9) {
                                    LLVM_DEBUG(errs() << "immediate " << imm << " requires an aug\n");
                                    // we need an aug instruction
                                    createAugInst(MI, i);
                                    MO.setImm(imm & 0x1ff);
                                    Changed = true;
                                }
                            } else {
                                // global addresses require an AUGS/D to be in inserted to be fixed-up later
                                createAugInst(MI, i);
                                Changed = true;
                            }
                        }
                    }
                }
            }

            LLVM_DEBUG(errs() << "new MF:\n");
            LLVM_DEBUG(MF.dump());

            LLVM_DEBUG(errs() << "******** P2 INSERT AUG PASS DONE ********\n");
            
            return Changed;
        }
    };
    char P2InsertAug::ID = 0;
} // end of anonymous namespace

FunctionPass *llvm::createP2InsertAugPass(P2TargetMachine &tm) {
    return new P2InsertAug(tm);
}