//===-- P2MCCodeEmitter.cpp - Convert P2 Code to Machine Code ---------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the P2MCCodeEmitter class.
//
//===----------------------------------------------------------------------===//

#include "P2MCCodeEmitter.h"
#include "P2Subtarget.h"

#include "MCTargetDesc/P2BaseInfo.h"
#include "MCTargetDesc/P2FixupKinds.h"
#include "MCTargetDesc/P2MCTargetDesc.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/raw_ostream.h"

#define DEBUG_TYPE "mccodeemitter"

#define GET_INSTRMAP_INFO
#include "P2GenInstrInfo.inc"
#undef GET_INSTRMAP_INFO

MCCodeEmitter *llvm::createP2MCCodeEmitter(const MCInstrInfo &MCII, const MCRegisterInfo &MRI, MCContext &Ctx) {
    return new P2MCCodeEmitter(MCII, Ctx);
}

void P2MCCodeEmitter::emitByte(unsigned char C, raw_ostream &OS) const {
    OS << (char)C;
}

void P2MCCodeEmitter::emitInstruction(uint64_t Val, unsigned Size, raw_ostream &OS) const {
    // Output the instruction encoding in little endian byte order.
    for (unsigned i = 0; i < Size; ++i) {
        emitByte((Val >> i*8) & 0xff, OS);
    }
}

void P2MCCodeEmitter::encodeInstruction(const MCInst &MI, raw_ostream &OS, SmallVectorImpl<MCFixup> &Fixups, const MCSubtargetInfo &STI) const {
    LLVM_DEBUG(errs() << "==== begin encode ====\n");
    LLVM_DEBUG(MI.dump());

    uint32_t bin = getBinaryCodeForInstr(MI, Fixups, STI);

    // Check for unimplemented opcodes.
    //unsigned op_code = MI.getOpcode();
    //const MCInstrDesc &Desc = MCII.get(op_code);

    LLVM_DEBUG(errs() << "emitting instruction binary: ");
    for (int i = 0; i < 32; i++) {
        LLVM_DEBUG(errs() << ((bin >> (31-i))&1));
    }

    LLVM_DEBUG(errs() << "\n");

    // Pseudo instructions don't get encoded and shouldn't be here
    // in the first place!
    // if ((TSFlags & P2::FormMask) == P2::Pseudo)
    //     llvm_unreachable("Pseudo opcode found in encodeInstruction()");

    emitInstruction(bin, 4, OS);

    LLVM_DEBUG(errs() << "==== end encode ====\n");
}

unsigned P2MCCodeEmitter::getJumpTargetOpValue(const MCInst &MI, unsigned OpNo, SmallVectorImpl<MCFixup> &Fixups,
                                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(OpNo);
    // If the destination is an immediate, we have nothing to do.

    if (MO.isImm()) {
        LLVM_DEBUG(errs() << "jump target = " << MO.getImm() << "\n");
        return MO.getImm();
    }

    assert(MO.isExpr() && "getJumpTargetOpValue expects only expressions if not an immediate");
    LLVM_DEBUG(errs() << "--- creating fixup for jump operand\n");

    const MCExpr *Expr = MO.getExpr();
    LLVM_DEBUG(Expr->dump());
    Fixups.push_back(MCFixup::create(0, Expr, MCFixupKind(P2::fixup_P2_PC20)));

    return 0;
}

unsigned P2MCCodeEmitter::getJumpAbsTargetOpValue(const MCInst &MI, unsigned OpNo, SmallVectorImpl<MCFixup> &Fixups,
                                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(OpNo);
    // If the destination is an immediate, we have nothing to do.

    if (MO.isImm()) {
        LLVM_DEBUG(errs() << "jump target = " << MO.getImm() << "\n");
        return MO.getImm();
    }

    assert(MO.isExpr() && "getJumpAbsTargetOpValue expects only expressions if not an immediate");
    LLVM_DEBUG(errs() << "--- creating absolute fixup for jump operand\n");

    const MCExpr *Expr = MO.getExpr();
    LLVM_DEBUG(Expr->dump());
    Fixups.push_back(MCFixup::create(0, Expr, MCFixupKind(P2::fixup_P2_20)));

    return 0;
}

unsigned P2MCCodeEmitter::getJump9TargetOpValue(const MCInst &MI, unsigned OpNo, SmallVectorImpl<MCFixup> &Fixups,
                                                const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(OpNo);
    // If the destination is an immediate, we have nothing to do.

    if (MO.isImm()) {
        LLVM_DEBUG(errs() << "cog jump offset = " << MO.getImm() << "\n");
        return MO.getImm();
    }

    assert(MO.isExpr() && "getJump9TargetOpValue expects only expressions if not an immediate");

    LLVM_DEBUG(errs() << "--- creating fixup for 9-bit jump operand\n");

    const MCExpr *Expr = MO.getExpr();
    LLVM_DEBUG(Expr->dump());
    Fixups.push_back(MCFixup::create(0, Expr, MCFixupKind(P2::fixup_P2_PCCOG9)));
    return 0;
}

unsigned P2MCCodeEmitter::encodeCallTarget(const MCInst &MI, unsigned OpNo,
    SmallVectorImpl<MCFixup> &Fixups, const MCSubtargetInfo &STI) const {
    return getJumpTargetOpValue(MI, OpNo, Fixups, STI);
}

unsigned P2MCCodeEmitter::encodeAbsCallTarget(const MCInst &MI, unsigned OpNo,
    SmallVectorImpl<MCFixup> &Fixups, const MCSubtargetInfo &STI) const {
    // The linker determines execution placement from the defining section,
    // never from the callee's spelling (e.g. an ordinary HUB function sqrt).
    return getJumpAbsTargetOpValue(MI, OpNo, Fixups, STI);
}

/// getMachineOpValue - Return binary encoding of operand. If the machine
/// operand requires relocation, record the relocation and return zero.
unsigned P2MCCodeEmitter::getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                                            SmallVectorImpl<MCFixup> &Fixups,
                                            const MCSubtargetInfo &STI) const {
    if (MO.isReg()) {
        unsigned Reg = MO.getReg();
        unsigned RegNo = Ctx.getRegisterInfo()->getEncodingValue(Reg);
        LLVM_DEBUG(errs() << "-- register number is " << RegNo << " for reg " << Reg << "\n");
        return RegNo;
    } else if (MO.isImm()) {
        LLVM_DEBUG(errs() << "-- immediate operand is " << MO.getImm() << "\n");
        return static_cast<unsigned>(MO.getImm());
    }

    LLVM_DEBUG(errs() << " -- operand is an expression\n");

    // MO must be an Expr.
    assert(MO.isExpr());
    unsigned Kind;
    const MCExpr *Expr = MO.getExpr();
    if (MI.getOpcode() == P2::AUGS || MI.getOpcode() == P2::AUGD) {
        Kind = P2::fixup_P2_AUG23;
        if (const auto *Shift = dyn_cast<MCBinaryExpr>(Expr)) {
            const auto *Amount = dyn_cast<MCConstantExpr>(Shift->getRHS());
            if ((Shift->getOpcode() == MCBinaryExpr::LShr ||
                 Shift->getOpcode() == MCBinaryExpr::AShr) &&
                Amount && Amount->getValue() == 9) {
                Expr = Shift->getLHS();
                Kind = P2::fixup_P2_AUG_HI23;
            }
        }
    } else {
        unsigned OpNo = 0;
        while (&MI.getOperand(OpNo) != &MO)
            ++OpNo;
        Kind = OpNo == P2::getDNum(MCII.get(MI.getOpcode()).TSFlags)
                   ? P2::fixup_P2_AUGD_LO9 : P2::fixup_P2_AUGS_LO9;
    }
    // Preserve the entire expression and signed addend in RELA. Evaluating
    // only its children loses subtraction and carries across the 9-bit split.
    Fixups.push_back(MCFixup::create(0, Expr, MCFixupKind(Kind), MI.getLoc()));
    return 0;
}

/// getMemEncoding - Return binary encoding of memory related operand.
/// If the offset operand requires relocation, record the relocation.
unsigned P2MCCodeEmitter::getMemEncoding(const MCInst &MI, unsigned OpNo, SmallVectorImpl<MCFixup> &Fixups,
                                            const MCSubtargetInfo &STI) const {

    llvm_unreachable("getMemEncoding not implemented");
}

#include "P2GenMCCodeEmitter.inc"