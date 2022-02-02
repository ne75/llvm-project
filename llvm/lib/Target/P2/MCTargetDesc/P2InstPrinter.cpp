//===- P2InstPrinter.cpp - P2 MCInst to assembly syntax -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This class prints an P2 MCInst to a .s file.
//
//===----------------------------------------------------------------------===//

#include "P2InstPrinter.h"
#include "P2BaseInfo.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "p2-asm-printer"

#include "P2GenAsmWriter.inc"

static bool isMIRandomAccess(const MCInst *MI) {
    auto opc = MI->getOpcode();

    if (opc == P2::RDBYTEri || opc == P2::RDWORDri || opc == P2::RDLONGri ||
        opc == P2::WRBYTEri || opc == P2::WRWORDri || opc == P2::WRLONGri ||
        opc == P2::WRBYTEii || opc == P2::WRWORDii || opc == P2::WRLONGii) 
        return true;

    return false;
}

static bool isMICall(const MCInst *MI) {
    auto opc = MI->getOpcode();

    if (opc == P2::CALLAa || opc == P2::CALLa) return true;

    return false;
}

static bool has20BitAbsAddr(const MCInst *MI) {
    auto opc = MI->getOpcode();

    if (opc == P2::JMPa || opc == P2::CALLa || opc == P2::CALLAa)
        return true;

    return false;
}

void P2InstPrinter::printRegName(raw_ostream &OS, unsigned RegNo) const {
    auto reg_val = MRI.getEncodingValue(RegNo);
    if (reg_val < 0x1d0) {
        OS << "$" << format_hex(reg_val, 5);
    } else {
        OS << StringRef(getRegisterName(RegNo)).lower();
    }
}

void P2InstPrinter::printCondition(const MCInst *MI, int OpNum, raw_ostream &O) {
    O << P2::cond_string_lut[MI->getOperand(OpNum).getImm() & 0xf];
}

void P2InstPrinter::printEffect(const MCInst *MI, int OpNum, raw_ostream &O) {
    O << P2::effect_string_lut[MI->getOperand(OpNum).getImm() & 0x3];
}


void P2InstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                StringRef Annot, const MCSubtargetInfo &STI,
                                raw_ostream &O) {
    printInstruction(MI, Address, O);
    printAnnotation(O, Annot);
}

static void printExpr(const MCExpr *Expr, const MCAsmInfo *MAI, raw_ostream &OS) {
    const MCSymbolRefExpr *SRE;

    if (const auto *CE = dyn_cast<MCConstantExpr>(Expr)) {
        OS << "0x";
        OS.write_hex(CE->getValue());
        return;
    }

    if (const auto *BE = dyn_cast<MCBinaryExpr>(Expr)) {
        // can probably remove this -- there are no binary expressions in the P2 architecture
        SRE = dyn_cast<MCSymbolRefExpr>(BE->getLHS());
        const auto *CE = dyn_cast<MCConstantExpr>(BE->getRHS());
        assert(SRE && CE && "Binary expression must be sym+const.");
        //Offset = CE->getValue();
    } else {
        SRE = dyn_cast<MCSymbolRefExpr>(Expr);
        assert(SRE && "Unexpected MCExpr type.");
    }
    assert(SRE->getKind() == MCSymbolRefExpr::VK_None);

    SRE->getSymbol().print(OS, MAI);
}

void P2InstPrinter::printOperand(const MCInst *MI, unsigned OpNum, raw_ostream &O) {
    const MCOperand &Op = MI->getOperand(OpNum);

    if (Op.isReg()) {
        printRegName(O, Op.getReg());
        return;
    }

    if (Op.isImm()) {
        // handle random access instructions which might use a PTRA expression
        if (isMIRandomAccess(MI)) {
            if (Op.getImm() == P2::PTRA_POSTINC) {
                O << "ptra++";
                return;
            }

            if (Op.getImm() == P2::PTRA_PREDEC) {
                O << "--ptra";
                return;
            }   

            // this is a D operand, so don't try to convert to a special immediate
            bool OpIsD = P2::getDNum(MII.get(MI->getOpcode()).TSFlags) == OpNum;
            if (!OpIsD && (Op.getImm() & 0x1c0) == P2::PTRA_INDEX6) {
                int idx = Op.getImm() & 0x3f;
                if (idx > 31) idx -= 64;

                O << "ptra[" << idx << "]";
                return;
            }

            // this is a plain immediate, it'll print below
        }

        if (has20BitAbsAddr(MI)) {
            O << "#\\" << Op.getImm();  
            return;
        }

        if (!isUInt<9>(Op.getImm()) && !isInt<9>(Op.getImm())) O << "#";
        O << "#" << Op.getImm();
        return;
    }

    assert(Op.isExpr() && "unknown operand kind in printOperand");

    if (isMICall(MI)) {
        O << "#\\";
    }
    printExpr(Op.getExpr(), &MAI, O);
}

void P2InstPrinter::printOperand(const MCInst *MI, uint64_t addr, unsigned OpNo, raw_ostream &O) {
    printOperand(MI, OpNo, O);
}
