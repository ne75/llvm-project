//===-- P2FinalizeBranches.cpp - P2 Finalize Branches ---------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Finalize branches by finding branch distances and replacing TJ instructions
// as necessary. This must be the last pass run that adds/removes instructions
//
//===----------------------------------------------------------------------===//

#include "P2.h"

#include "P2TargetMachine.h"
#include "MCTargetDesc/P2BaseInfo.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBundle.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/ADT/SmallSet.h"

using namespace llvm;

#define DEBUG_TYPE "p2-finalize-branches"

static cl::opt<bool> EnableDelJmp("enable-p2-finalize-branches",
    cl::init(true),
    cl::desc("Compute branch distances to determine correct branch instruction(s)"),
    cl::Hidden);

namespace {
    struct P2FinalizeBranches : public MachineFunctionPass {
        static char ID;
        const P2TargetMachine &TM;
        P2FinalizeBranches(const P2TargetMachine &tm) : MachineFunctionPass(ID), TM(tm) {}

        StringRef getPassName() const override {
            return "P2 Finalize Branches";
        }

        bool isTJOpcode(MachineInstr &I) {
            return (I.getOpcode() == P2::TJNZri ||
                    I.getOpcode() == P2::TJZri);
        }

        /**
         * replace MI (which should be a TJ* branch) with 2 instructions, a compare and a jump
         */
        void replaceTJBranch(MachineInstr &MI) {
            assert(isTJOpcode(MI) && "replaceTJBranch can only operate on TJ machine instructions");

            auto *TII = TM.getInstrInfo();
            unsigned jmp_cond = 0;

            // we should only ever have the immediate version of this instruction
            if (MI.getOpcode() == P2::TJNZri) {
                jmp_cond = P2::IF_NZ;
            } else if (MI.getOpcode() == P2::TJZri) {
                jmp_cond = P2::IF_Z;
            } else {
                llvm_unreachable("unhandled tj* instruction\n");
            }

            BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), TII->get(P2::CMPri), P2::SW)
                .add(MI.getOperand(0))
                .addImm(0)
                .addImm(P2::ALWAYS)
                .addImm(P2::WZ);

            BuildMI(*MI.getParent(), MI, MI.getDebugLoc(), TII->get(P2::JMP))
                .add(MI.getOperand(1))
                .addReg(P2::SW, RegState::Kill)
                .addImm(jmp_cond);

            MI.eraseFromParent();
        }

        bool runOnMachineFunction(MachineFunction &MF) override {
            bool changed = false;
            LLVM_DEBUG(errs() << "******** P2 FINALIZE BRANCHES PASS ********\n");

            auto *TII = TM.getInstrInfo();

            std::map<MachineBasicBlock *, unsigned> block_addresses; // track addresses of MBBs, relative to function start, in # of instructions 
            std::map<MachineInstr *, unsigned> branch_addresses; // track every TJ* instruction and where they are located
            int pc = 0;
            bool UnknownLayout = false;

            // go through the entire function and find all possible branch destinations (the position of the MBB in the function)
            // and address of the TJ instructions that reference branch destinations
            for (auto &MBB : MF) {
                UnknownLayout |= MBB.getAlignment() > Align(4);
                block_addresses.insert(std::make_pair(&MBB, pc));
                for (auto &MI : MBB) {
                    int s = 0;
                    // determine instruction size.
                    if (MI.isInlineAsm()) {
                        // Directives such as .rept and .align are not bounded by
                        // LLVM's textual instruction-count estimate. Use the
                        // long branch form whenever layout is uncertain.
                        UnknownLayout = true;
                        s = 0;
                    } else if (isTJOpcode(MI)) {
                        // assume every TJ will expand into 2 instructions (for safety). this greatly simplifies calculating distnaces
                        // and it's a small corner case if it ends up needing to be only 1, so performance impact is small
                        s = 2;
                        branch_addresses.insert(std::make_pair(&MI, pc));
                    } else {
                        s = 1; // everything else is a single length instruction (all augs should have been expanded by now)
                    }

                    pc += s;
                }
            }

            // we've got a map of all basic block starts and all branch instructions. Now go through the list,
            // get the distnace to the branch destination, and replace it if needed
            for (auto br : branch_addresses) {
                int d = block_addresses[br.first->getOperand(1).getMBB()] - br.second - 1; // -1 because a jmp of 0 is one instruction away
                LLVM_DEBUG(errs() << "approcimate distance to branch: " << d << "\n");

                if (UnknownLayout || !isInt<9>(d)) {
                    LLVM_DEBUG(errs() << "branch too far, replacing with cmp/jmp\n");
                    replaceTJBranch(*br.first);
                    changed = true;
                }
                 
            }


            for (auto &MBB : MF)
                for (auto &MI : MBB)
                    changed |= TII->annotateFlagState(MI);

            // Prefixes are hardware state for their consumer. Bundle only
            // after layout decisions and all frame/augmentation expansion.
            auto IsPrefix = [](const MachineInstr &MI) {
                switch (MI.getOpcode()) {
                case P2::AUGS: case P2::AUGD:
                case P2::SETQi: case P2::SETQr:
                case P2::SETQ2i: case P2::SETQ2r:
                    return true;
                default: return false;
                }
            };
            for (auto &MBB : MF) {
                auto I = MBB.instr_begin();
                while (I != MBB.instr_end()) {
                    if (!IsPrefix(*I)) { ++I; continue; }
                    auto Begin = I;
                    do { ++I; } while (I != MBB.instr_end() && IsPrefix(*I));
                    assert(I != MBB.instr_end() && "P2 prefix without a consumer");
                    auto End = std::next(I);
                    finalizeBundle(MBB, Begin, End);
                    I = End;
                    changed = true;
                }
            }

            LLVM_DEBUG(errs() << "new MF:\n");
            LLVM_DEBUG(MF.dump());

            LLVM_DEBUG(errs() << "******** P2 FINALIZE BRANCHES PASS DONE ********\n");
            
            return changed;
        }
    };
    char P2FinalizeBranches::ID = 0;
} // end of anonymous namespace

FunctionPass *llvm::createP2FinalizeBranchesPass(P2TargetMachine &tm) {
    return new P2FinalizeBranches(tm);
}
