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
            PTRA_PREDEC = 0x15f,
            PTRA_INDEX = 0x100, 
            PTRA_INDEX_AUGS = 0x800000
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

        static inline int getInstructionForm(const MachineInstr &mi) {
            int flags = mi.getDesc().TSFlags;

            return flags & 0x1f;
        }

        static inline bool hasDField(const MachineInstr &mi) {
            int flags = mi.getDesc().TSFlags;

            return ((flags >> 6) & 1) == 1;
        }

        static inline int getDNum(const MachineInstr &mi) {
            int flags = mi.getDesc().TSFlags;

            return (flags >> 10) & 0x7;
        }

        static inline bool hasSField(const MachineInstr &mi) {
            int flags = mi.getDesc().TSFlags;

            return ((flags >> 5) & 1) == 1;
        }

        static inline int getSNum(const MachineInstr &mi) {
            int flags = mi.getDesc().TSFlags;

            return (flags >> 7) & 0x7;
        }

        static inline int getCondition(const MachineInstr &mi) {
            switch (getInstructionForm(mi)) {
            case P2InstCZIDS:
            case P2InstZIDS:
            case P2InstCIDS:
            case P2InstCLIDS:
            case P2InstCLD:
            case P2InstCZD:
            case P2InstCZ:
            case P2InstCZLD:
                return mi.getOperand(mi.getNumOperands()-2).getImm();
                break;

            
            case P2Inst3NIDS:
            case P2Inst2NIDS:
            case P2Inst1NIDS:
            case P2InstIDS:
            case P2InstLIDS:
            case P2InstIS:
            case P2InstLD:
            case P2InstD:
            case P2InstRA:
            case P2InstWRA:
            case P2InstN:
                return mi.getOperand(mi.getNumOperands()-1).getImm();
                break;
            
            default:
                break;
            }

            return ALWAYS;
        }
    }

}

#endif