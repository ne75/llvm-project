//===- P2Disassembler.cpp - Disassembler for P2 ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file is part of the P2 Disassembler.
//
//===----------------------------------------------------------------------===//

#include "P2.h"
#include "P2RegisterInfo.h"
#include "P2Subtarget.h"
#include "TargetInfo/P2TargetInfo.h"
#include "MCTargetDesc/P2MCTargetDesc.h"
#include "MCTargetDesc/P2BaseInfo.h"

#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCDisassembler/MCDisassembler.h"
#include "llvm/MC/MCFixedLenDisassembler.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "p2-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {

//===----------------------------------------------------------------------===//
// Class Definitions
//===----------------------------------------------------------------------===//

class P2Disassembler : public MCDisassembler {
    public:
    	P2Disassembler(const MCSubtargetInfo &STI, MCContext &Ctx) : MCDisassembler(STI, Ctx) {}
    	virtual ~P2Disassembler() {}

    	DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                                    ArrayRef<uint8_t> Bytes, uint64_t Address,
                                    raw_ostream &CStream) const override;
    };
}

class P2Symbolizer : public MCSymbolizer {
private:
    void *DisInfo;

public:
    P2Symbolizer(MCContext &Ctx, std::unique_ptr<MCRelocationInfo> &&RelInfo,
                    void *disInfo)
                    : MCSymbolizer(Ctx, std::move(RelInfo)), DisInfo(disInfo) {}

    bool tryAddingSymbolicOperand(MCInst &Inst, raw_ostream &cStream,
                                int64_t Value, uint64_t Address,
                                bool IsBranch, uint64_t Offset,
                                uint64_t InstSize) override;

    void tryAddingPcLoadReferenceComment(raw_ostream &cStream,
                                        int64_t Value,
                                        uint64_t Address) override;
};

//===----------------------------------------------------------------------===//
// Initialization
//===----------------------------------------------------------------------===//

static MCDisassembler *createP2Disassembler(const Target &T, const MCSubtargetInfo &STI, MCContext &Ctx) {
	return new P2Disassembler(STI, Ctx);
}

static MCSymbolizer *createP2Symbolizer(const Triple &/*TT*/,
                              LLVMOpInfoCallback GetOpInfo,
                              LLVMSymbolLookupCallback /*SymbolLookUp*/,
                              void *DisInfo,
                              MCContext *Ctx,
                              std::unique_ptr<MCRelocationInfo> &&RelInfo) {
  return new P2Symbolizer(*Ctx, std::move(RelInfo), DisInfo);
}


extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeP2Disassembler() {
	// Register the disassembler.
	TargetRegistry::RegisterMCDisassembler(getTheP2Target(), createP2Disassembler);
    TargetRegistry::RegisterMCSymbolizer(getTheP2Target(), createP2Symbolizer);
}

//===----------------------------------------------------------------------===//
// P2Disassembler
//===----------------------------------------------------------------------===//

static const uint16_t GPRDecoderTable[] = {
    P2::R0, P2::R1, P2::R2, P2::R3, P2::R4, P2::R5, P2::R6, P2::R7,
    P2::R8, P2::R9, P2::R10, P2::R11, P2::R12, P2::R13, P2::R14, P2::R15,
    P2::R16, P2::R17, P2::R18, P2::R19, P2::R20, P2::R21, P2::R22, P2::R23,
    P2::R24, P2::R25, P2::R26, P2::R27, P2::R28, P2::R29, P2::R30, P2::R31,
    P2::IJMP3, P2::IRET3, P2::IJMP2, P2::IRET2, P2::IJMP1, P2::IRET1,
    P2::PA, P2::PB, P2::PTRA, P2::PTRB, P2::DIRA, P2::DIRB, P2::OUTA, P2::OUTB,
    P2::INA, P2::INB
};

static uint16_t getRegForField(uint16_t r) {
    int reg_start = 0x1d0;
    if (r > 0x1ff) {
        LLVM_DEBUG(errs() << "register address: " << r << "\n");
        llvm_unreachable("bad register address!");
    } else if (r >= reg_start) {
        return GPRDecoderTable[r-reg_start];
    } else {
        return P2::C0 + r; // slightly fragile-- as this assumes tablegen put all the Cx registers in order
    }
}

static DecodeStatus DecodeP2GPRRegisterClass(MCInst &Inst, unsigned RegNo, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeIOInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeJumpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeTJInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeCmpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeCordicInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeGetQInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);
static DecodeStatus DecodeCallInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);

static DecodeStatus decodeJump9Target(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder);

#include "P2GenDisassemblerTables.inc"

static MCOperand getConditionOperand(unsigned inst) {
    int c = fieldFromInstruction(inst, 28, 4);
    return MCOperand::createImm(c);
}

static DecodeStatus DecodeP2GPRRegisterClass(MCInst &Inst, unsigned RegNo, uint64_t Address, const void *Decoder) {
    auto disasm = static_cast<const MCDisassembler *>(Decoder);
    if (!disasm) return MCDisassembler::Fail;

    unsigned Register = *(disasm->getContext().getRegisterInfo()->getRegClass(P2::P2GPRRegClassID).begin() + RegNo);
	Inst.addOperand(MCOperand::createReg(Register));
    
	return MCDisassembler::Success;
}

static DecodeStatus decodeJump9Target(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    int32_t s_field = fieldFromInstruction(Insn, 0, 9);
    if (s_field > 0xff) {
        s_field = -((~s_field & 0x1ff) + 1);
    }
    Inst.addOperand(MCOperand::createImm(s_field));
    return MCDisassembler::Success;
}

static DecodeStatus DecodeCallInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    uint32_t a_field = fieldFromInstruction(Insn, 0, 20);
    uint32_t d_field = fieldFromInstruction(Insn, 9, 9);

    unsigned opc = Inst.getOpcode();
    if (opc == P2::CALLa || opc == P2::CALLAa) {
        uint32_t call_addr = a_field;

        if (a_field >= 0x200 && a_field < 0x400) {
            // this is a call to a LUT address, adjust it before trying to create a symbol.
            call_addr = 4*(a_field - 0x200) + 0x200;
        }

        auto *Dis = static_cast<const MCDisassembler*>(Decoder);
        if (!Dis->tryAddingSymbolicOperand(Inst, call_addr, Address, true, 0, 1)) {
            Inst.addOperand(MCOperand::createImm(a_field));
        }
    } else if (opc == P2::CALL) {
        Inst.addOperand(MCOperand::createImm(a_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(d_field)));
    }

    Inst.addOperand(getConditionOperand(Insn));

    if (opc == P2::CALLr || opc == P2::CALLAr) {
        unsigned eff = fieldFromInstruction(Insn, 19, 2);
        Inst.addOperand(MCOperand::createImm(eff));
    }

    return MCDisassembler::Success;
}

static DecodeStatus DecodeJumpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    LLVM_DEBUG(errs() << "decode jump instruction\n");

    // for readability, print negatives out
    int32_t a_field = fieldFromInstruction(Insn, 0, 20);
    if (a_field > 0x7ffff) {
        a_field = -((~a_field & 0xfffff) + 1);
    }
    Inst.addOperand(MCOperand::createImm(a_field)); // turn this into a symbol instead of immediate. make a decoder for calls and do the same
    Inst.addOperand(MCOperand::createReg(P2::SW));
    Inst.addOperand(getConditionOperand(Insn));

    return MCDisassembler::Success;
}

static DecodeStatus DecodeTJInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    LLVM_DEBUG(errs() << "decode tj instruction\n");

    // for readability, print negatives out
    unsigned d_field = fieldFromInstruction(Insn, 9, 9);
    unsigned s_field = fieldFromInstruction(Insn, 0, 9);
    unsigned is_imm = fieldFromInstruction(Insn, 18, 1);
    
    Inst.addOperand(MCOperand::createReg(getRegForField(d_field))); // turn this into a symbol instead of immediate. make a decoder for calls and do the same
    
    if (is_imm) {
        Inst.addOperand(MCOperand::createImm(s_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(s_field)));
    }

    Inst.addOperand(getConditionOperand(Insn));

    return MCDisassembler::Success;
}

static DecodeStatus DecodeIOInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {

    LLVM_DEBUG(errs() << "decode IO instruction\n");

    //unsigned s_field = fieldFromInstruction(Insn, 0, 9);
    unsigned d_field = fieldFromInstruction(Insn, 9, 9);
    unsigned is_imm = fieldFromInstruction(Insn, 18, 1);
    unsigned eff = fieldFromInstruction(Insn, 19, 2);

    // if we have wc or wz, this is the "testpx" instruction, which has the same op codes as other pin
    // instructions, and it uses wc/wz as part of the opcode. check for the opposite of that here, if effect
    // is wcz or nothing.
    if (eff == (unsigned)P2::effect_string_map["wcz"] || eff == (unsigned)P2::effect_string_map[""]) {
        // this is a normal pin instruction, not a test instruction, so do things for normal pins

        // first add the operand that is getting implicitly written, which is either DIRA/B or OUTA/B.
        // FIXME: we don't actually care what that is, so for now, always write to OUTA. this could eventually be a problem, but TBD how
        // (probably when optimization becomes involved.) Should actually look at the opcode and set the register to an implicit 64-bit
        // "register" that is the combination of A and B portions of OUT, DIR, and IN.
        // Inst.addOperand(MCOperand::createReg(P2::OUTA)); // don't do this for now, since we changed how instructions are set up. 
    }

    if (is_imm) {
        Inst.addOperand(MCOperand::createImm(d_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(d_field)));
    }

    Inst.addOperand(getConditionOperand(Insn));
    Inst.addOperand(MCOperand::createImm(eff));

    return MCDisassembler::Success;
}

static DecodeStatus DecodeCmpInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {

    LLVM_DEBUG(errs() << "decode CMP instruction\n");

    unsigned d_field = fieldFromInstruction(Insn, 9, 9);
    unsigned s_field = fieldFromInstruction(Insn, 0, 9);
    unsigned is_imm = fieldFromInstruction(Insn, 18, 1);

    // first add the operand that is getting implicitly written, which in our case is the status flags.
    // similar to above with I/O.
    Inst.addOperand(MCOperand::createReg(P2::SW));

    Inst.addOperand(MCOperand::createReg(getRegForField(d_field)));

    if (is_imm) {
        
        Inst.addOperand(MCOperand::createImm(s_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(s_field)));
    }

    Inst.addOperand(getConditionOperand(Insn));
    int eff = fieldFromInstruction(Insn, 19, 2);
    Inst.addOperand(MCOperand::createImm(eff));

    return MCDisassembler::Success;
}

static DecodeStatus DecodeCordicInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    LLVM_DEBUG(errs() << "Cordic decode\n");

    unsigned d_field = fieldFromInstruction(Insn, 9, 9);
    unsigned s_field = fieldFromInstruction(Insn, 0, 9);
    unsigned d_is_imm = fieldFromInstruction(Insn, 19, 1);
    unsigned s_is_imm = fieldFromInstruction(Insn, 18, 1);

    LLVM_DEBUG(errs() << "d = " << d_field << "; L = " << d_is_imm << "\n");
    LLVM_DEBUG(errs() << "s = " << s_field << "; I = " << s_is_imm << "\n");

    if (d_is_imm) {
        Inst.addOperand(MCOperand::createImm(d_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(d_field)));
    }

    if (s_is_imm) {
        Inst.addOperand(MCOperand::createImm(s_field));
    } else {
        Inst.addOperand(MCOperand::createReg(getRegForField(s_field)));
    }

    Inst.addOperand(getConditionOperand(Insn));
    int eff = fieldFromInstruction(Insn, 19, 2);
    Inst.addOperand(MCOperand::createImm(eff));

    return MCDisassembler::Success;
}

static DecodeStatus DecodeGetQInstruction(MCInst &Inst, unsigned Insn, uint64_t Address, const void *Decoder) {
    LLVM_DEBUG(errs() << "getq decode\n");

    unsigned d_field = fieldFromInstruction(Insn, 9, 9);

    Inst.addOperand(MCOperand::createReg(getRegForField(d_field)));
    Inst.addOperand(MCOperand::createReg(P2::GETQX));

    Inst.addOperand(getConditionOperand(Insn));
    int eff = fieldFromInstruction(Insn, 19, 2);
    Inst.addOperand(MCOperand::createImm(eff));

    return MCDisassembler::Success;
}

static DecodeStatus readInstruction(ArrayRef<uint8_t> Bytes, uint64_t Address, uint64_t &Size, uint32_t &Insn) {

	if (Bytes.size() < 4) {
		Size = 0;
		return MCDisassembler::Fail;
	}

	Size = 4;
	Insn = (Bytes[0] << 0) | (Bytes[1] << 8) | (Bytes[2] << 16) | (Bytes[3] << 24); // instructions are little endian

	return MCDisassembler::Success;
}

DecodeStatus P2Disassembler::getInstruction(MCInst &Instr, uint64_t &Size, ArrayRef<uint8_t> Bytes,
                                            uint64_t Address, raw_ostream &CStream) const {

	uint32_t Insn;
	DecodeStatus Result;

	Result = readInstruction(Bytes, Address, Size, Insn);
	if (Result == MCDisassembler::Fail) return MCDisassembler::Fail;

    LLVM_DEBUG(errs() << "get instruction: " << Insn << "\n");

	Result = decodeInstruction(DecoderTableP232, Instr, Insn, Address, this, STI);

	if (Result != MCDisassembler::Fail) {
        LLVM_DEBUG(errs() << Result << "\n");
		return Result;
	}

	return MCDisassembler::Fail;
}

typedef DecodeStatus (*DecodeFunc)(MCInst &MI, unsigned insn, uint64_t Address, const void *Decoder);

//===----------------------------------------------------------------------===//
// P2Symbolizer
//===----------------------------------------------------------------------===//

// Try to find symbol name for specified label
// it only works for complete elfs--anything that's a relocation doesn't work correctly
bool P2Symbolizer::tryAddingSymbolicOperand(MCInst &Inst,
                                raw_ostream &/*cStream*/, int64_t Value,
                                uint64_t Address, bool IsBranch,
                                uint64_t /*Offset*/, uint64_t /*InstSize*/) {

    if (!IsBranch) { // only symbolize branches/calls
        return false;
    }

    if (Value == 0) {
        // If we are disassembling a complete program, branches to 0 are not possible, (except for in custom COG code)
        // so leave it as 0.
        // If we are disassembling an object file with fixups, I don't know how to get that data in this function, 
        // so don't try to create a symbol.
        return false;
    }

    auto *Symbols = static_cast<SectionSymbolsTy *>(DisInfo);
    if (!Symbols) {
        return false;
    }

    auto Result = llvm::find_if(*Symbols, [Value](const SymbolInfoTy &Val) {
        return Val.Addr == static_cast<uint64_t>(Value) && Val.Type == ELF::STT_FUNC;
    });

    if (Result != Symbols->end()) {
        auto *Sym = Ctx.getOrCreateSymbol(Result->Name);
        const auto *Add = MCSymbolRefExpr::create(Sym, Ctx);
        Inst.addOperand(MCOperand::createExpr(Add));
        return true;
    }
    
    return false;
}

void P2Symbolizer::tryAddingPcLoadReferenceComment(raw_ostream &cStream,
                                                       int64_t Value,
                                                       uint64_t Address) {
    llvm_unreachable("unimplemented");
}
