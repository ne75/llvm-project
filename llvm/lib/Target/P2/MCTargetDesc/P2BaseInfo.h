//===-- P2BaseInfo.h - Top level definitions for P2 MC ------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file contains small standalone helper functions and enum definitions for
// the P2 target useful for the compiler back-end and the MC libraries.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_P2_MCTARGETDESC_P2BASEINFO_H
#define LLVM_LIB_TARGET_P2_MCTARGETDESC_P2BASEINFO_H

#include "P2MCTargetDesc.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/Support/DataTypes.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/CodeGen/MachineInstr.h"
#include <map>

namespace llvm {

    namespace P2 {
        // special immediates for rd/wrbyte/word/long that will modify PTRx
        enum name {
            PTRA_POSTINC = 0x161,
            PTRB_POSTINC = 0x1e1,
            
            PTRA_POSTDEC = 0x17f,
            PTRB_POSTDEC = 0x1ff,

            PTRA_PREINC = 0x141,
            PTRB_PREINC = 0x1c1,

            PTRA_PREDEC = 0x15f,
            PTRB_PREDEC = 0x1df,

            PTRA_INDEX6 = 0x100, 
            PTRA_INDEX6_AUGS = 0x800000
        };

        // Map LLVM's condition code to immediate operands for expanding instructions with condition codes
        enum {
            SETUEQ = 0,
            SETUNE,
            SETULE,
            SETULT,
            SETUGT,
            SETUGE,
            SETEQ,
            SETNE,
            SETLE,
            SETLT,
            SETGT,
            SETGE
        };

        enum {
            _RET_ = 0,
            IF_NC_AND_NZ,
            IF_NC_AND_Z,
            IF_NC,
            IF_C_AND_NZ,
            IF_NZ,
            IF_C_NE_Z,
            IF_NC_OR_NZ,
            IF_C_AND_Z,
            IF_C_EQ_Z,
            IF_Z,
            IF_NC_OR_Z,
            IF_C,
            IF_C_OR_NZ,
            IF_C_OR_Z,
            ALWAYS
        };

        enum {
            NOEFF = 0,
            WZ,
            WC,
            WCZ
        };

        enum {
            P2Inst,
            P2InstCZIDS,
            P2Inst3NIDS,
            P2Inst2NIDS,
            P2Inst1NIDS,
            P2InstIDS,
            P2InstZIDS,
            P2InstCIDS,
            P2InstLIDS,
            P2InstIS,
            P2InstCLIDS,
            P2InstLD,
            P2InstCLD,
            P2InstCZD,
            P2InstCZ,
            P2InstCZLD,
            P2InstD,
            P2InstRA,
            P2InstWRA,
            P2InstN
        };

        extern const char *cond_string_lut[];
        extern const char *effect_string_lut[];
        extern std::map<StringRef, int> cond_string_map;
        extern std::map<StringRef, int> effect_string_map;

        static inline int getInstructionForm(uint64_t flags) {
            return flags & 0x1f;
        }

        static inline bool hasDField(uint64_t flags) {
            return ((flags >> 6) & 1) == 1;
        }

        static inline int getDNum(uint64_t flags) {
            return (flags >> 11) & 0x7;
        }

        static inline bool hasSField(uint64_t flags) {
            return ((flags >> 5) & 1) == 1;
        }

        static inline int getSNum(uint64_t flags) {
            return (flags >> 8) & 0x7;
        }

        static inline bool hasNField(uint64_t flags) {
            return ((flags >> 7) & 1) == 1;
        }

        static inline int getNNum(uint64_t flags) {
            return (flags >> 14) & 0x7;
        }

        static inline int getInstructionForm(const MachineInstr &mi) {
            return getInstructionForm(mi.getDesc().TSFlags);
        }

        static inline bool hasDField(const MachineInstr &mi) {
            return hasDField(mi.getDesc().TSFlags);
        }

        static inline int getDNum(const MachineInstr &mi) {
            return getDNum(mi.getDesc().TSFlags);
        }

        static inline bool hasSField(const MachineInstr &mi) {
            return hasSField(mi.getDesc().TSFlags);
        }

        static inline int getSNum(const MachineInstr &mi) {
            return getSNum(mi.getDesc().TSFlags);
        }

        static inline bool hasNField(const MachineInstr &mi) {
            return hasNField(mi.getDesc().TSFlags);
        }

        static inline int getNNum(const MachineInstr &mi) {
            return getNNum(mi.getDesc().TSFlags);
        }

        // Every concrete form ends in a condition, followed by an optional
        // effect. Keep MachineInstr and MCInst interpretation in one place.
        static inline bool hasEffectField(uint64_t Flags) {
            switch (getInstructionForm(Flags)) {
            case P2InstCZIDS: case P2InstZIDS: case P2InstCIDS:
            case P2InstCLIDS: case P2InstCLD: case P2InstCZD:
            case P2InstCZ: case P2InstCZLD:
                return true;
            default:
                return false;
            }
        }

        static inline int getConditionOperand(uint64_t Flags, unsigned Count) {
            unsigned Form = getInstructionForm(Flags);
            if (Form == P2Inst || Form > P2InstN)
                return -1;
            unsigned Suffix = hasEffectField(Flags) ? 2 : 1;
            assert(Count >= Suffix && "Missing P2 condition operand");
            return Count - Suffix;
        }

        static inline int getCondition(const MachineInstr &MI) {
            // Descriptor count excludes implicit register-state operands.
            int Op = getConditionOperand(MI.getDesc().TSFlags,
                                         MI.getDesc().getNumOperands());
            return Op < 0 ? ALWAYS : MI.getOperand(Op).getImm();
        }

        static inline int getCondition(const MCInst &MI) {
            int Op = getConditionOperand(MI.getFlags(), MI.getNumOperands());
            return Op < 0 ? ALWAYS : MI.getOperand(Op).getImm();
        }

        // These forms have no augmentable D/S immediate field.
        static inline bool canAugment(uint64_t Flags) {
            switch (getInstructionForm(Flags)) {
            case P2Inst: case P2InstN: case P2InstWRA: case P2InstRA:
            case P2InstD: case P2InstCZ: case P2InstCZD:
                return false;
            default:
                return true;
            }
        }

    }

}

#endif