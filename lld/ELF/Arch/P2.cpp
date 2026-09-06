//===- P2.cpp ------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
#include "InputFiles.h"
#include "InputSection.h"
#include "SymbolTable.h"
#include "Symbols.h"
#include "Target.h"
#include "lld/Common/ErrorHandler.h"
#include "llvm/Object/ELF.h"
#include "llvm/Support/Endian.h"

#define DEBUG_TYPE "p2"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::support::endian;
using namespace llvm::ELF;

namespace lld {
    namespace elf {

        namespace {
            class P2 final : public TargetInfo {
            public:
                RelExpr getRelExpr(RelType type, const Symbol &s, const uint8_t *loc) const override;
                void relocate(uint8_t *loc, const Relocation &rel, uint64_t val) const override;
            };
        } // namespace

        static bool isLutSymbol(const Symbol *symbol) {
            const auto *defined = dyn_cast_or_null<Defined>(symbol);
            return defined && defined->section &&
                   (defined->section->name == "lut" ||
                    defined->section->name.startswith(".lut"));
        }

        static uint64_t lutAddress(const uint8_t *loc, uint64_t value) {
            const Symbol *base = symtab->find("__p2_lut_load_start");
            const Symbol *end = symtab->find("__p2_lut_load_end");
            if (!base || !base->isDefined() || !end || !end->isDefined()) {
                error(getErrorLocation(loc) + "LUT calls require __p2_lut_load_start and __p2_lut_load_end");
                return 0;
            }
            uint64_t offset = value - base->getVA();
            if (value < base->getVA() || value >= end->getVA() || offset >= 2048 || offset % 4) {
                error(getErrorLocation(loc) + "LUT call target is outside the aligned 512-long LUT image");
                return 0;
            }
            return 0x200 + offset / 4;
        }

        RelExpr P2::getRelExpr(RelType type, const Symbol &s, const uint8_t *loc) const {
            switch (type) {
            case R_P2_NONE: return R_NONE;
            case R_P2_PC32:
            case R_P2_PCCOG9: return R_PC;
            case R_P2_PC20: return isLutSymbol(&s) ? R_ABS : R_PC;
            default: return R_ABS;
            }
        }

        void P2::relocate(uint8_t *loc, const Relocation &rel, uint64_t val) const {
            auto writeField = [&](unsigned offset, unsigned bits, uint64_t value) {
                uint32_t mask = uint32_t((uint64_t(1) << bits) - 1) << offset;
                write32le(loc, (read32le(loc) & ~mask) | ((value << offset) & mask));
            };
            switch (rel.type) {
            case R_P2_NONE: return;
            case R_P2_8:
                checkIntUInt(loc, val, 8, rel); *loc = val; return;
            case R_P2_16:
                checkIntUInt(loc, val, 16, rel); write16le(loc, val); return;
            case R_P2_32:
            case R_P2_PC32:
                checkIntUInt(loc, val, 32, rel); write32le(loc, val); return;
            case R_P2_64:
                write64le(loc, val); return;
            case R_P2_PC20:
                if (isLutSymbol(rel.sym)) {
                    val = lutAddress(loc, val);
                    write32le(loc, read32le(loc) & ~(1u << 20));
                    checkUInt(loc, val, 20, rel);
                } else {
                    val -= 4;
                    checkInt(loc, val, 20, rel);
                }
                writeField(0, 20, val); return;
            case R_P2_COG9: // legacy name-based calls; inspect actual placement
            case R_P2_20:
                if (isLutSymbol(rel.sym))
                    val = lutAddress(loc, val);
                if (rel.type == R_P2_COG9)
                    write32le(loc, read32le(loc) & ~(1u << 20));
                checkUInt(loc, val, 20, rel);
                writeField(0, 20, val); return;
            case R_P2_PCCOG9:
                val -= 4;
                if (val % 4)
                    error(getErrorLocation(loc) + "unaligned short branch target");
                val = uint64_t(int64_t(val) / 4);
                checkInt(loc, val, 9, rel);
                writeField(0, 9, val); return;
            case R_P2_AUG_HI23:
                checkIntUInt(loc, val, 32, rel);
                writeField(0, 23, val >> 9); return;
            case R_P2_AUG23:
                checkIntUInt(loc, val, 23, rel);
                writeField(0, 23, val); return;
            case R_P2_AUGS_LO9:
                writeField(0, 9, val); return;
            case R_P2_AUGD_LO9:
                writeField(9, 9, val); return;
            case R_P2_AUG20: {
                // Retain readable legacy objects, but reject a malformed pair
                // before accessing the preceding instruction. New objects use
                // independent high/D-low/S-low relocations.
                if (rel.offset < 4) {
                    error(getErrorLocation(loc) + "legacy AUG relocation has no preceding instruction");
                    return;
                }
                uint32_t aug = read32le(loc - 4);
                uint32_t opcode = aug & 0x0f800000;
                if (opcode != 0x0f000000 && opcode != 0x0f800000) {
                    error(getErrorLocation(loc) + "legacy AUG relocation is not preceded by AUGS/AUGD");
                    return;
                }
                unsigned shift = opcode == 0x0f800000 ? 9 : 0;
                val += (read32le(loc) >> shift) & 0x1ff;
                checkIntUInt(loc, val, 32, rel);
                write32le(loc - 4, (aug & ~0x7fffffu) | ((val >> 9) & 0x7fffff));
                writeField(shift, 9, val); return;
            }
            default:
                error(getErrorLocation(loc) + "unrecognized relocation " + toString(rel.type));
            }
        }

        TargetInfo *getP2TargetInfo() {
            static P2 target;
            return &target;
        }
    } // namespace elf
} // namespace lld
