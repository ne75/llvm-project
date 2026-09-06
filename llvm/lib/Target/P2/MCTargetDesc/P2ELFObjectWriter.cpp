//===-- P2ELFObjectWriter.cpp - P2 ELF Writer -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===------------------------------------------------------------------===//

#include "MCTargetDesc/P2BaseInfo.h"
#include "MCTargetDesc/P2FixupKinds.h"
#include "MCTargetDesc/P2MCTargetDesc.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCSection.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/ErrorHandling.h"
#include <list>

using namespace llvm;

namespace {
    class P2ELFObjectWriter : public MCELFObjectTargetWriter {
    public:
        P2ELFObjectWriter(uint8_t OSABI);

        ~P2ELFObjectWriter() override;

        unsigned getRelocType(MCContext &Ctx, const MCValue &Target, const MCFixup &Fixup, bool IsPCRel) const override;
    };
}

P2ELFObjectWriter::P2ELFObjectWriter(uint8_t OSABI) : MCELFObjectTargetWriter(false, OSABI, ELF::EM_P2, /*HasRelocationAddend*/ true) {}

P2ELFObjectWriter::~P2ELFObjectWriter() {}

unsigned P2ELFObjectWriter::getRelocType(MCContext &Ctx, const MCValue &Target, const MCFixup &Fixup, bool IsPCRel) const {
    // determine the type of the relocation

    unsigned Type = (unsigned)ELF::R_P2_NONE;
    unsigned Kind = (unsigned)Fixup.getKind();

    switch (Kind) {
    default:
        llvm_unreachable("invalid fixup kind!");
    case P2::fixup_P2_AUG23: return ELF::R_P2_AUG23;
    case FK_Data_1: return ELF::R_P2_8;
    case FK_Data_2: return ELF::R_P2_16;
    case FK_Data_8: return ELF::R_P2_64;
    case P2::fixup_P2_AUG_HI23: return ELF::R_P2_AUG_HI23;
    case P2::fixup_P2_AUGS_LO9: return ELF::R_P2_AUGS_LO9;
    case P2::fixup_P2_AUGD_LO9: return ELF::R_P2_AUGD_LO9;
    case FK_Data_4:
    case P2::fixup_P2_32:
        Type = ELF::R_P2_32;
        break;
    case P2::fixup_P2_20:
        Type = ELF::R_P2_20;
        break;
    case P2::fixup_P2_PC32:
        Type = ELF::R_P2_PC32;
        break;
    case P2::fixup_P2_PC20:
        Type = ELF::R_P2_PC20;
        break;
    case P2::fixup_P2_AUG20:
        Type = ELF::R_P2_AUG20;
        break;
    case P2::fixup_P2_COG9:
        Type = ELF::R_P2_COG9;
        break;
    case P2::fixup_P2_PCCOG9:
        Type = ELF::R_P2_PCCOG9;
        break;
    }

    return Type;
}

std::unique_ptr<MCObjectTargetWriter> llvm::createP2ELFObjectWriter(uint8_t OSABI) {
    return std::make_unique<P2ELFObjectWriter>(OSABI);
}