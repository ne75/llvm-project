//===-- P2AsmBackend.cpp - P2 Asm Backend  ----------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the P2AsmBackend class.
//
//===----------------------------------------------------------------------===//
//

#include "MCTargetDesc/P2FixupKinds.h"
#include "MCTargetDesc/P2AsmBackend.h"
#include "MCTargetDesc/P2MCTargetDesc.h"

#include "P2Subtarget.h"

#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/MC/MCValue.h"
#include "llvm/MC/MCDirectives.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Debug.h"

#define DEBUG_TYPE "p2-asm-backend"

using namespace llvm;
// RELA addends live in relocation records; unresolved fields stay zero.
// Resolved PC-relative instruction fields are measured from the following PC.
static uint64_t adjustFixupValue(const MCFixup &Fixup, uint64_t Value) {
    switch (Fixup.getKind()) {
    case P2::fixup_P2_PC20: return Value - 4;
    case P2::fixup_P2_PCCOG9: return uint64_t(int64_t(Value - 4) / 4);
    case P2::fixup_P2_AUG_HI23: return Value >> 9;
    default: return Value;
    }
}


std::unique_ptr<MCObjectTargetWriter> P2AsmBackend::createObjectTargetWriter() const {
    return createP2ELFObjectWriter(MCELFObjectTargetWriter::getOSABI(OSType));
}

void P2AsmBackend::applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                        const MCValue &Target, MutableArrayRef<char> Data,
                        uint64_t Value, bool IsResolved,
                        const MCSubtargetInfo *STI) const {

    MCFixupKind Kind = Fixup.getKind();
    const auto &Info = getFixupKindInfo(Kind);
    if (IsResolved) {
        if (Kind == P2::fixup_P2_PCCOG9 &&
            ((Value - 4) % 4 || !isInt<9>(int64_t(Value - 4) / 4))) {
            Asm.getContext().reportError(Fixup.getLoc(),
                "short branch target is unaligned or out of range [-256, 255]");
            return;
        }
        if (Kind == P2::fixup_P2_PC20 && !isInt<20>(Value - 4)) {
            Asm.getContext().reportError(Fixup.getLoc(), "relative branch target is out of range");
            return;
        }
        Value = adjustFixupValue(Fixup, Value);
    } else {
        Value = 0;
    }
    uint64_t Mask = (UINT64_MAX >> (64 - Info.TargetSize)) << Info.TargetOffset;
    unsigned Offset = Fixup.getOffset();
    unsigned NumBytes = (Info.TargetOffset + Info.TargetSize + 7) / 8;
    if (Offset + NumBytes > Data.size()) {
        Asm.getContext().reportError(Fixup.getLoc(), "fixup extends beyond its fragment");
        return;
    }
    uint64_t Current = 0;
    for (unsigned I = 0; I < NumBytes; ++I)
        Current |= uint64_t(uint8_t(Data[Offset + I])) << (8 * I);
    Current = (Current & ~Mask) | ((Value << Info.TargetOffset) & Mask);
    for (unsigned I = 0; I < NumBytes; ++I)
        Data[Offset + I] = uint8_t(Current >> (8 * I));
}

const MCFixupKindInfo &P2AsmBackend::getFixupKindInfo(MCFixupKind Kind) const {
    const static MCFixupKindInfo Infos[P2::NumTargetFixupKinds] = {
        // This table *must* be in same the order of fixup_* kinds in
        // P2FixupKinds.h.
        //
        // name                 offset  bits  flags
        { "fixup_P2_32",        0,      32,   0},
        { "fixup_P2_PC32",      0,      32,   MCFixupKindInfo::FKF_IsPCRel},
        { "fixup_P2_20",        0,      20,   0},
        { "fixup_P2_PC20",      0,      20,   MCFixupKindInfo::FKF_IsPCRel},
        { "fixup_P2_AUG20",     0,      20,   0},
        { "fixup_P2_COG9",      0,      9,    0},
        { "fixup_P2_PCCOG9",    0,      9,    MCFixupKindInfo::FKF_IsPCRel},
        { "fixup_P2_AUG_HI23",  0,      23,   0},
        { "fixup_P2_AUGS_LO9",  0,      9,    0},
        { "fixup_P2_AUGD_LO9",  9,      9,    0},
        { "fixup_P2_AUG23",     0,      23,   0}
    };

    if (Kind < FirstTargetFixupKind)
        return MCAsmBackend::getFixupKindInfo(Kind);

    assert(unsigned(Kind - FirstTargetFixupKind) < getNumFixupKinds() && "Invalid kind!");
    return Infos[Kind - FirstTargetFixupKind];
}

bool P2AsmBackend::writeNopData(raw_ostream &OS, uint64_t Count, const MCSubtargetInfo *STI) const {
    if (Count % 4 != 0) return false;

    OS.write_zeros(Count);
    return true;
}

MCAsmBackend *llvm::createP2AsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                  const MCRegisterInfo &MRI,
                                  const llvm::MCTargetOptions &TO) {
  return new P2AsmBackend(STI.getTargetTriple().getOS());
}
