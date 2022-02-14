//===- P2InstrInfo.td - Target Description for P2 Target -*- tablegen -*-=//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

include "P2InstrFormats.td"

/*--------------------------------*/
/* General type definitions       */
/*--------------------------------*/

def SDT_P2Call : SDTypeProfile<0, -1, [SDTCisVT<0, iPTR>]>;
def SDT_P2Mov : SDTypeProfile<1, 1, [SDTCisSameAs<0, 1>]>;
def SDT_P2CallSeqStart : SDCallSeqStart<[SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;
def SDT_P2CallSeqEnd : SDCallSeqEnd<[SDTCisVT<0, i32>, SDTCisVT<1, i32>]>;

def P2RelAddrOperand : AsmOperandClass {
    let Name = "RelAddr";
    let PredicateMethod = "isImm";
    let RenderMethod = "addImmOperands";
}

def P2AbsAddrOperand : AsmOperandClass {
    let Name = "AbsAddr";
    let PredicateMethod = "isAbsAddr";
    let RenderMethod = "addImmOperands";
}

def absjmptarget    : Operand<OtherVT> {
    let EncoderMethod = "getJumpTargetOpValue";
    let OperandType = "OPERAND_IMMEDIATE";
    let ParserMatchClass = P2AbsAddrOperand;
}

def reljmptarget    : Operand<OtherVT> {
    let EncoderMethod = "getJumpTargetOpValue";
    let OperandType = "OPERAND_IMMEDIATE";
    let ParserMatchClass = P2RelAddrOperand;
}

def jmp9target    : Operand<OtherVT> {
    let EncoderMethod = "getJump9TargetOpValue";
    let DecoderMethod = "decodeJump9Target";
    let OperandType = "OPERAND_IMMEDIATE";
}

def abscalltarget : Operand<iPTR> {
    let EncoderMethod = "encodeCallTarget";
    let ParserMatchClass = P2AbsAddrOperand;
}

def relcalltarget : Operand<iPTR> {
    let EncoderMethod = "encodeCallTarget";
    let ParserMatchClass = P2RelAddrOperand;
}

def NegateImm : SDNodeXForm<imm, [{return CurDAG->getConstant(-N->getSExtValue(), SDLoc(N), MVT::i32, true);}]>;
def NegSubInlineConst32 : ImmLeaf<i32, [{return Imm < 0;}], NegateImm>;
def i32immleaf : ImmLeaf<i32, [{return isInt<32>(Imm);}]>;
def i64immleaf : ImmLeaf<i64, [{return isInt<64>(Imm);}]>;

def addr : ComplexPattern<iPTR, 1, "selectAddr", [], []>;

/*--------------------------------*/
/* custom nodes                   */
/*--------------------------------*/
// this is used for loading global addresses
def P2GAWrapper    : SDNode<"P2ISD::GAWRAPPER", SDT_P2Mov>;

def P2callseq_start : SDNode<"ISD::CALLSEQ_START", SDT_P2CallSeqStart, [SDNPHasChain, SDNPOutGlue]>;
def P2callseq_end : SDNode<"ISD::CALLSEQ_END", SDT_P2CallSeqEnd, [SDNPHasChain, SDNPOptInGlue, SDNPOutGlue]>;

def P2RDLUT  : SDNode<"P2ISD::RDLUT", SDTLoad, [SDNPHasChain, SDNPMayLoad, SDNPMemOperand]>;
def P2WRLUT  : SDNode<"P2ISD::WRLUT", SDTStore, [SDNPHasChain, SDNPMayStore, SDNPMemOperand]>;

def P2RET   : SDNode<"P2ISD::RET", SDTNone, [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;
def P2CALL  : SDNode<"P2ISD::CALL", SDT_P2Call, [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue, SDNPVariadic]>;

def rdlut : PatFrag<(ops node:$ptr), (P2RDLUT node:$ptr)> {
    let IsNonExtLoad = 1;
    let IsUnindexed = 1;
}

def wrlut : PatFrag<(ops node:$val, node:$ptr), (P2WRLUT node:$val, node:$ptr)> {
    let IsTruncStore = 0;
    let IsUnindexed = 1;
}

/*--------------------------------*/
/* basic math and logic           */
/*--------------------------------*/

// place this first so that the below pattern matches before the standard addition pattern matches
defm SUB : P2InstCZIDS2i1om<0b0001100, "sub">;

// convert add -c to sub c
def : Pat<(sub P2GPR:$src1, P2GPR:$s), (SUBrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(sub P2GPR:$src1, imm:$s), (SUBri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(add i32:$d, NegSubInlineConst32:$s), (SUBri $d, NegSubInlineConst32:$s, always, noeff)>;


defm ROR    : P2InstCZIDS2i1om<0b0000000, "ror">;
defm ROL    : P2InstCZIDS2i1om<0b0000001, "rol">;
defm SHR    : P2InstCZIDS2i1om<0b0000010, "shr">;
defm SHL    : P2InstCZIDS2i1om<0b0000011, "shl">;
defm RCR    : P2InstCZIDS2i1om<0b0000100, "rcr">;
defm RCL    : P2InstCZIDS2i1om<0b0000101, "rcl">;
defm SAR    : P2InstCZIDS2i1om<0b0000110, "sar">;
defm SAL    : P2InstCZIDS2i1om<0b0000111, "sal">;
defm ADD    : P2InstCZIDS2i1om<0b0001000, "add">;
defm ADDX   : P2InstCZIDS2i1om<0b0001001, "addx">;
defm ADDS   : P2InstCZIDS2i1om<0b0001010, "adds">;
defm ADDSX  : P2InstCZIDS2i1om<0b0001011, "addsx">;
defm SUBX   : P2InstCZIDS2i1om<0b0001101, "subx">;
defm SUBS   : P2InstCZIDS2i1om<0b0001110, "subs">;
defm SUBSX  : P2InstCZIDS2i1om<0b0001111, "subsx">;
defm SUBR   : P2InstCZIDS2i1om<0b0010110, "subr">;
defm AND    : P2InstCZIDS2i1om<0b0101000, "and">;
defm OR     : P2InstCZIDS2i1om<0b0101010, "or">;
defm XOR    : P2InstCZIDS2i1om<0b0101011, "xor">;
defm SIGNX  : P2InstCZIDS2i1om<0b0111011, "signx">;

let Constraints = "$s1 = $d", s_num = 2 in {
    defm MUL    : P2InstZIDSm<0b10100000, (ins P2GPR:$s1), "mul">;
    defm MULS   : P2InstZIDSm<0b10100001, (ins P2GPR:$s1), "muls">;
}

defm NOT    : P2InstCZIDSm<0b0110001, "not">;
defm ABS    : P2InstCZIDSm<0b0110010, "abs">;
defm NEG    : P2InstCZIDSm<0b0110011, "neg">;

let Constraints = "$s = $d" in {
    def REV    : P2InstD<0b1101011, 0b001101001, (outs P2GPR:$d), (ins P2GPR:$s), "rev $d">;
}

defm ENCOD  : P2InstCZIDSm<0b0111100, "encod">;
defm DECOD  : P2InstIDSm<0b100111000, "decod">;
defm ONES   : P2InstCZIDSm<0b0111101, "ones">;

// 64 bit pseudos
let Constraints = "$s1 = $d" in {
    def ADD64rr     : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, P2GPRPair:$s), "add64 $d, $s">;
    def SUB64rr     : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, P2GPRPair:$s), "sub64 $d, $s">;
    def AND64rr     : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, P2GPRPair:$s), "and64 $d, $s">;
    def OR64rr      : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, P2GPRPair:$s), "or64 $d, $s">;
    def XOR64rr     : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, P2GPRPair:$s), "xor64 $d, $s">;

    def ADD64ri     : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s1, P2GPRPair:$s), "add64 $d, $s">;
    def SUB64ri     : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s1, P2GPRPair:$s), "sub64 $d, $s">;
    def AND64ri     : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s1, P2GPRPair:$s), "and64 $d, $s">;
    def OR64ri      : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s1, P2GPRPair:$s), "or64 $d, $s">;
    def XOR64ri     : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s1, P2GPRPair:$s), "xor64 $d, $s">;

    def SEXTIR64    : Pseudo<(outs P2GPRPair:$d), (ins P2GPRPair:$s1, i8imm:$s), "sextir64 $d, #$s">;
}

def SEXT64      : Pseudo<(outs P2GPRPair:$d), (ins P2GPR:$s), "sext64 $d, $s">;
def ZEXT64      : Pseudo<(outs P2GPRPair:$d), (ins P2GPR:$s), "zext64 $d, $s">;

def : Pat<(rotl P2GPR:$src1, P2GPR:$s), (ROLrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(rotl P2GPR:$src1, i32immleaf:$s), (ROLri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(rotr P2GPR:$src1, P2GPR:$s), (RORrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(rotr P2GPR:$src1, i32immleaf:$s), (RORri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(srl P2GPR:$src1, P2GPR:$s), (SHRrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(srl P2GPR:$src1, i32immleaf:$s), (SHRri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(shl P2GPR:$src1, P2GPR:$s), (SHLrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(shl P2GPR:$src1, i32immleaf:$s), (SHLri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(sra P2GPR:$src1, P2GPR:$s), (SARrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(sra P2GPR:$src1, i32immleaf:$s), (SARri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(add P2GPR:$src1, P2GPR:$s), (ADDrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(add P2GPR:$src1, i32immleaf:$s), (ADDri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(add P2GPR:$src1, P2GPR:$s), (ADDXrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(add P2GPR:$src1, i32immleaf:$s), (ADDXri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(and P2GPR:$src1, P2GPR:$s), (ANDrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(and P2GPR:$src1, i32immleaf:$s), (ANDri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(or P2GPR:$src1, P2GPR:$s), (ORrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(or P2GPR:$src1, i32immleaf:$s), (ORri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(xor P2GPR:$src1, P2GPR:$s), (XORrr P2GPR:$src1, P2GPR:$s, always, noeff)>;
def : Pat<(xor P2GPR:$src1, i32immleaf:$s), (XORri P2GPR:$src1, imm:$s, always, noeff)>;
def : Pat<(not P2GPR:$s), (NOTrr P2GPR:$s, always, noeff)>;
def : Pat<(not i32immleaf:$s), (NOTri imm:$s, always, noeff)>;
def : Pat<(abs P2GPR:$s), (ABSrr P2GPR:$s, always, noeff)>;
def : Pat<(abs i32immleaf:$s), (ABSri imm:$s, always, noeff)>;
def : Pat<(ineg P2GPR:$s), (NEGrr P2GPR:$s, always, noeff)>;
def : Pat<(ineg i32immleaf:$s), (NEGri imm:$s, always, noeff)>;
def : Pat<(bitreverse P2GPR:$s), (REV P2GPR:$s, always)>;

def : Pat<(sext_inreg P2GPR:$d, i1), (SIGNXri P2GPR:$d, 0, always, noeff)>;
def : Pat<(sext_inreg P2GPR:$d, i8), (SIGNXri P2GPR:$d, 7, always, noeff)>;
def : Pat<(sext_inreg P2GPR:$d, i16), (SIGNXri P2GPR:$d, 15, always, noeff)>;

def : Pat<(i32 (ctlz P2GPR:$s)), (SUBRri (ENCODrr $s, always, noeff), 31, always, noeff)>;
def : Pat<(i32 (ctpop P2GPR:$s)), (ONESrr $s, always, noeff)>;

// basic 64 bit support. everything else should either expand or be a libcall
def : Pat<(add P2GPRPair:$s1, P2GPRPair:$s), (ADD64rr P2GPRPair:$s1, P2GPRPair:$s)>;
def : Pat<(add P2GPRPair:$s1, i64immleaf:$s), (ADD64ri P2GPRPair:$s1, imm:$s)>;
def : Pat<(sub P2GPRPair:$s1, P2GPRPair:$s), (SUB64rr P2GPRPair:$s1, P2GPRPair:$s)>;
def : Pat<(sub P2GPRPair:$s1, i64immleaf:$s), (SUB64ri P2GPRPair:$s1, imm:$s)>;
def : Pat<(and P2GPRPair:$s1, P2GPRPair:$s), (AND64rr P2GPRPair:$s1, P2GPRPair:$s)>;
def : Pat<(and P2GPRPair:$s1, i64immleaf:$s), (AND64ri P2GPRPair:$s1, imm:$s)>;
def : Pat<(or P2GPRPair:$s1, P2GPRPair:$s), (OR64rr P2GPRPair:$s1, P2GPRPair:$s)>;
def : Pat<(or P2GPRPair:$s1, i64immleaf:$s), (OR64ri P2GPRPair:$s1, imm:$s)>;
def : Pat<(xor P2GPRPair:$s1, P2GPRPair:$s), (XOR64rr P2GPRPair:$s1, P2GPRPair:$s)>;
def : Pat<(xor P2GPRPair:$s1, i64immleaf:$s), (XOR64ri P2GPRPair:$s1, imm:$s)>;

def : Pat<(i64 (sext P2GPR:$s)), (SEXT64 P2GPR:$s)>;
def : Pat<(i64 (zext P2GPR:$s)), (ZEXT64 P2GPR:$s)>;
def : Pat<(i64 (anyext P2GPR:$s)), (ZEXT64 P2GPR:$s)>;

def : Pat<(sext_inreg P2GPRPair:$d, i8), (SEXTIR64 P2GPRPair:$d, 7)>;
def : Pat<(sext_inreg P2GPRPair:$d, i16), (SEXTIR64 P2GPRPair:$d, 15)>;
def : Pat<(sext_inreg P2GPRPair:$d, i32), (SEXTIR64 P2GPRPair:$d, 31)>;

//subregisters, a register providing an insert value, and a subregister index
/*--------------------------------*/
/* More complicated math          */
/*--------------------------------*/

let DecoderMethod = "DecodeGetQInstruction" in {
    def GETQX   : P2InstCZD<0b1101011, 0b000011000, (outs P2GPR:$d), (ins P2Implicit:$qx), "getqx $d">;
    def GETQY   : P2InstCZD<0b1101011, 0b000011001, (outs P2GPR:$d), (ins P2Implicit:$qy), "getqy $d">;
}

let DecoderMethod = "DecodeCordicInstruction" in {
    defm QMUL   : P2InstLIDSm<0b11010000, "qmul">;
    defm QDIV   : P2InstLIDSm<0b11010001, "qdiv">;
}

def QUDIV   : Pseudo<(outs P2GPR:$dst), (ins P2GPR:$src1, P2GPR:$src2), "udiv $dst, $src1, $src2">;
def QUREM   : Pseudo<(outs P2GPR:$dst), (ins P2GPR:$src1, P2GPR:$src2), "urem $dst, $src1, $src2">;

def : Pat<(udiv P2GPR:$src1, P2GPR:$src2), (QUDIV P2GPR:$src1, P2GPR:$src2)>;
def : Pat<(urem P2GPR:$src1, P2GPR:$src2), (QUREM P2GPR:$src1, P2GPR:$src2)>;

/*--------------------------------*/
/* branching and conditionals     */
/*--------------------------------*/

// how branching will work:
// define branch instruction for various compare branches (equal, not equal, etc), they will probably be all subclasses of common branch with different effects stuck to it.
// define a pattern that matched a compare instruction output inputting to one of the branch instructions for various IR conditional branch patterns

let DecoderMethod = "DecodeCmpInstruction", s_num = 2, d_num = 1 in {
    // don't use the multiclass for this because these don't output to d
    def CMPrr   : P2InstCZIDS<0b0010000, 0b0, (outs P2Implicit:$cmp), (ins P2GPR:$d, P2GPR:$s), "cmp $d, $s">;
    def CMPri   : P2InstCZIDS<0b0010000, 0b1, (outs P2Implicit:$cmp), (ins P2GPR:$d, i32imm:$s), "cmp $d, $s">;
    def CMPRrr  : P2InstCZIDS<0b0010100, 0b0, (outs P2Implicit:$cmp), (ins P2GPR:$d, P2GPR:$s), "cmpr $d, $s">;
    def CMPRri  : P2InstCZIDS<0b0010100, 0b1, (outs P2Implicit:$cmp), (ins P2GPR:$d, i32imm:$s), "cmpr $d, $s">;  
    def CMPXrr  : P2InstCZIDS<0b0010001, 0b0, (outs P2Implicit:$cmp), (ins P2GPR:$d, P2GPR:$s), "cmpx $d, $s">;
    def CMPXri  : P2InstCZIDS<0b0010001, 0b1, (outs P2Implicit:$cmp), (ins P2GPR:$d, i32imm:$s), "cmpx $d, $s">;
    
    def CMPSrr  : P2InstCZIDS<0b0010010, 0b0, (outs P2Implicit:$cmp), (ins P2GPR:$d, P2GPR:$s), "cmps $d, $s">;
    def CMPSri  : P2InstCZIDS<0b0010010, 0b1, (outs P2Implicit:$cmp), (ins P2GPR:$d, i32imm:$s), "cmps $d, $s">;
    def CMPSXrr : P2InstCZIDS<0b0010011, 0b0, (outs P2Implicit:$cmp), (ins P2GPR:$d, P2GPR:$s), "cmpsx $d, $s">;
    def CMPSXri : P2InstCZIDS<0b0010011, 0b1, (outs P2Implicit:$cmp), (ins P2GPR:$d, i32imm:$s), "cmpsx $d, $s">;
}

def JMPr        : P2InstCZD<0b1101011, 0b000101100, (outs), (ins P2GPR:$d), "jmp $d">;

let DecoderMethod = "DecodeJumpInstruction", isBarrier = 1, isBranch = 1, isTerminator = 1 in {
    def JMP     : P2InstRA<0b1101100, 0b1, (outs), (ins reljmptarget:$d, P2Implicit:$cmp), "jmp $d">; // relative address jump
    def JMPa    : P2InstRA<0b1101100, 0b0, (outs), (ins absjmptarget:$d, P2Implicit:$cmp), "jmp $d">; // absolute address jump.
}

let DecoderMethod = "DecodeTJInstruction", isBranch = 1, isBarrier = 1, isTerminator = 1 in {
    // don't use multiclass here because we don't want to use the imm operand type
    def TJZrr   : P2InstIDS<0b101110010, 0b0, (outs), (ins P2GPR:$d, P2GPR:$s), "tjz $d, $s">;
    def TJZri   : P2InstIDS<0b101110010, 0b1, (outs), (ins P2GPR:$d, jmp9target:$s), "tjz $d, $s">;

    def TJNZrr  : P2InstIDS<0b101110011, 0b0, (outs), (ins P2GPR:$d, P2GPR:$s), "tjnz $d, $s">;
    def TJNZri  : P2InstIDS<0b101110011, 0b1, (outs), (ins P2GPR:$d, jmp9target:$s), "tjnz $d, $s">;
}

let Constraints = "$s1 = $d", s_num = 2 in {
    // don't use multiclass here because we don't want to use the imm operand type
    def DJNZrr  : P2InstIDS<0b101101101, 0b0, (outs P2GPR:$d), (ins P2GPR:$s1, P2GPR:$s), "djnz $d, $s">;
    def DJNZri  : P2InstIDS<0b101101101, 0b1, (outs P2GPR:$d), (ins P2GPR:$s1, jmp9target:$s), "djnz $d, $s">;
}

defm REP    : P2InstLIDSm<0b11001101, "rep">;

defm TEST   : P2InstCZIDSm<0b0111110, "test">;

// Patterns for various branch conditions and types of branch instructions
// unsigned comparison
def : Pat<(brcc SETUEQ, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_z)>;
def : Pat<(brcc SETUEQ, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_z)>;

def : Pat<(brcc SETUNE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nz)>;
def : Pat<(brcc SETUNE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_nz)>;

def : Pat<(brcc SETULT, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_c)>;
def : Pat<(brcc SETULT, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_c)>;

def : Pat<(brcc SETUGT, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nc_and_nz)>;
def : Pat<(brcc SETUGT, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_nc_and_nz)>;

def : Pat<(brcc SETULE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_c_or_z)>;
def : Pat<(brcc SETULE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_c_or_z)>;

def : Pat<(brcc SETUGE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nc)>;
def : Pat<(brcc SETUGE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPri P2GPR:$lhs, imm:$rhs, always, wcz), if_nc)>;

// signed comparison
def : Pat<(brcc SETEQ, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_z)>;
def : Pat<(brcc SETEQ, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_z)>;

def : Pat<(brcc SETNE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nz)>;
def : Pat<(brcc SETNE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_nz)>;

def : Pat<(brcc SETLT, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_c)>;
def : Pat<(brcc SETLT, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_c)>;

def : Pat<(brcc SETGE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nc)>;
def : Pat<(brcc SETGE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_nc)>;

def : Pat<(brcc SETGT, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_nc_and_nz)>;
def : Pat<(brcc SETGT, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_nc_and_nz)>;

def : Pat<(brcc SETLE, P2GPR:$lhs, P2GPR:$rhs, bb:$target), (JMP bb:$target, (CMPSrr P2GPR:$lhs, P2GPR:$rhs, always, wcz), if_c_or_z)>;
def : Pat<(brcc SETLE, P2GPR:$lhs, imm:$rhs, bb:$target), (JMP bb:$target, (CMPSri P2GPR:$lhs, imm:$rhs, always, wcz), if_c_or_z)>;

// if (c) branch => jump if not 0
def : Pat<(brcond P2GPR:$c, bb:$target), (TJNZri P2GPR:$c, bb:$target, always)>;

// unconditional jump
def : Pat<(br bb:$target), (JMP bb:$target, 1, always)>;

// indirect branch
def : Pat<(brind P2GPR:$d), (JMPr P2GPR:$d, noeff, always)>;

// these patterns break jump analysis, so might need to do it as a pass later to replace, or update the jump analysis
// to select these instructions when appropriate
// test and jump if 0
def : Pat<(brcc SETEQ, P2GPR:$lhs, 0, bb:$target), (TJZri P2GPR:$lhs, bb:$target, always)>;
// test and jump if not 0
def : Pat<(brcc SETNE, P2GPR:$lhs, 0, bb:$target), (TJNZri P2GPR:$lhs, bb:$target, always)>;

/*--------------------------------*/
/* moving data                    */
/*--------------------------------*/

// compare 32 bit values and select a 32 bit value
def SELECTCC    : Pseudo<(outs P2GPR:$d), (ins P2GPR:$lhs, i32imm:$rhs, i32imm:$t, i32imm:$f, i8imm:$cc), "selectcc $d, $lhs, $rhs, $t, $f, $cc">;

// compare 64 bit values and select a 64 bit value
def SELECTCC64  : Pseudo<(outs P2GPR:$d), (ins P2GPRPair:$lhs, P2GPRPair:$rhs, i32imm:$t, i32imm:$f, i8imm:$cc), "selectcc64 $d, $lhs, $rhs, $t, $f, $cc">;

// compare 64 bit and select 64 bit is lowered to 2 SELECTCCs, so no pseudo exists

multiclass sel_cc<CondCode c, int cc> {
    def : Pat<(selectcc P2GPR:$lhs, imm:$rhs, imm:$t, imm:$f, c),       (SELECTCC P2GPR:$lhs, imm:$rhs, imm:$t, imm:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, imm:$rhs, P2GPR:$t, imm:$f, c),     (SELECTCC P2GPR:$lhs, imm:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, imm:$rhs, P2GPR:$t, imm:$f, c),     (SELECTCC P2GPR:$lhs, imm:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, imm:$rhs, P2GPR:$t, P2GPR:$f, c),   (SELECTCC P2GPR:$lhs, imm:$rhs, P2GPR:$t, P2GPR:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, P2GPR:$rhs, imm:$t, imm:$f, c),     (SELECTCC P2GPR:$lhs, P2GPR:$rhs, imm:$t, imm:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, P2GPR:$rhs, imm:$t, P2GPR:$f, c),   (SELECTCC P2GPR:$lhs, P2GPR:$rhs, imm:$t, P2GPR:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, P2GPR:$rhs, P2GPR:$t, imm:$f, c),   (SELECTCC P2GPR:$lhs, P2GPR:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc P2GPR:$lhs, P2GPR:$rhs, P2GPR:$t, P2GPR:$f, c), (SELECTCC P2GPR:$lhs, P2GPR:$rhs, P2GPR:$t, P2GPR:$f, cc)>;

    
    def : Pat<(selectcc i64:$lhs, imm:$rhs, imm:$t, imm:$f, c),             (SELECTCC64 P2GPRPair:$lhs, imm:$rhs, imm:$t, imm:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, imm:$rhs, P2GPR:$t, imm:$f, c),           (SELECTCC64 P2GPRPair:$lhs, imm:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, imm:$rhs, P2GPR:$t, imm:$f, c),           (SELECTCC64 P2GPRPair:$lhs, imm:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, imm:$rhs, P2GPR:$t, P2GPR:$f, c),         (SELECTCC64 P2GPRPair:$lhs, imm:$rhs, P2GPR:$t, P2GPR:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, P2GPRPair:$rhs, imm:$t, imm:$f, c),       (SELECTCC64 P2GPRPair:$lhs, P2GPRPair:$rhs, imm:$t, imm:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, P2GPRPair:$rhs, imm:$t, P2GPR:$f, c),     (SELECTCC64 P2GPRPair:$lhs, P2GPRPair:$rhs, imm:$t, P2GPR:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, P2GPRPair:$rhs, P2GPR:$t, imm:$f, c),     (SELECTCC64 P2GPRPair:$lhs, P2GPRPair:$rhs, P2GPR:$t, imm:$f, cc)>;
    def : Pat<(selectcc i64:$lhs, P2GPRPair:$rhs, P2GPR:$t, P2GPR:$f, c),   (SELECTCC64 P2GPRPair:$lhs, P2GPRPair:$rhs, P2GPR:$t, P2GPR:$f, cc)>;
}

defm SELECTueq   : sel_cc<SETUEQ, 0>;
defm SELECTune   : sel_cc<SETUNE, 1>;
defm SELECTule   : sel_cc<SETULE, 2>;
defm SELECTult   : sel_cc<SETULT, 3>;
defm SELECTugt   : sel_cc<SETUGT, 4>;
defm SELECTuge   : sel_cc<SETUGE, 5>;
defm SELECTeq   : sel_cc<SETEQ, 6>;
defm SELECTne   : sel_cc<SETNE, 7>;
defm SELECTle   : sel_cc<SETLE, 8>;
defm SELECTlt   : sel_cc<SETLT, 9>;
defm SELECTgt   : sel_cc<SETGT, 10>;
defm SELECTge   : sel_cc<SETGE, 11>;

def : Pat<(select P2GPR:$c, P2GPR:$t, P2GPR:$f), (SELECTCC P2GPR:$c, 0, P2GPR:$t, P2GPR:$f, 1)>;
def : Pat<(select P2GPR:$c, P2GPR:$t, imm:$f), (SELECTCC P2GPR:$c, 0, P2GPR:$t, imm:$f, 1)>;
def : Pat<(select P2GPR:$c, imm:$t, P2GPR:$f), (SELECTCC P2GPR:$c, 0, imm:$t, P2GPR:$f, 1)>;
def : Pat<(select P2GPR:$c, imm:$t, imm:$f), (SELECTCC P2GPR:$c, 0, imm:$t, imm:$f, 1)>;

defm MOV        : P2InstCZIDSm<0b0110000, "mov">;

def MOVi64      : Pseudo<(outs P2GPRPair:$d), (ins i64imm:$s), "mov64 $d, $s">;

def : Pat<(i64immleaf:$s), (MOVi64 imm:$s)>;
def : Pat<(imm:$s), (MOVri imm:$s, always, noeff)>;

defm RDBYTE     : P2InstCZIDSm<0b1010110, "rdbyte">;
defm RDWORD     : P2InstCZIDSm<0b1010111, "rdword">;
defm RDLONG     : P2InstCZIDSm<0b1011000, "rdlong">;

defm WRBYTE     : P2InstLIDSm<0b11000100, "wrbyte">;
defm WRWORD     : P2InstLIDSm<0b11000101, "wrword">;
defm WRLONG     : P2InstLIDSm<0b11000110, "wrlong">;

def RFBYTE      : P2InstCZD<0b1101011, 0b000010000, (outs P2GPR:$d), (ins), "rfbyte $d">;
def RFWORD      : P2InstCZD<0b1101011, 0b000010001, (outs P2GPR:$d), (ins), "rfword $d">;
def RFLONG      : P2InstCZD<0b1101011, 0b000010010, (outs P2GPR:$d), (ins), "rflong $d">;

defm SETQ       : P2InstLDm<0b1101011, 0b000101000, "setq">;
defm SETQ2      : P2InstLDm<0b1101011, 0b000101001, "setq2">;

defm RDLUT      : P2InstCZIDSm<0b1010101, "rdlut">;
defm WRLUT      : P2InstLIDSm<0b11000011, "wrlut">;

defm RDFAST     : P2InstLIDSm<0b11000111, "rdfast">;
defm WRFAST     : P2InstLIDSm<0b11001000, "wrfast">;

// these have an output and no input, leave without multiclass for now
def WFBYTEr     : P2InstLD<0b1101011, 0b000010101, 0b0, (outs P2GPR:$d), (ins), "wfbyte $d">;
def WFBYTEi     : P2InstLD<0b1101011, 0b000010101, 0b1, (outs i32imm:$d), (ins), "wfbyte $d">;
def WFWORDr     : P2InstLD<0b1101011, 0b000010110, 0b0, (outs P2GPR:$d), (ins), "wfword $d">;
def WFWORDi     : P2InstLD<0b1101011, 0b000010110, 0b1, (outs i32imm:$d), (ins), "wfword $d">;
def WFLONGr     : P2InstLD<0b1101011, 0b000010111, 0b0, (outs P2GPR:$d), (ins), "wflong $d">;
def WFLONGi     : P2InstLD<0b1101011, 0b000010111, 0b1, (outs i32imm:$d), (ins), "wflong $d">;

def RDDLONG     : Pseudo<(outs P2GPRPair:$reg), (ins P2GPR:$addr), "rddlong $reg, $addr">;
def WRDLONG     : Pseudo<(outs), (ins P2GPRPair:$reg, P2GPR:$addr), "wrdlong $reg, $addr">;

def : Pat<(i64 (load addr:$s)), (RDDLONG P2GPR:$s)>;

def : Pat<(zextloadi8 imm:$s), (RDBYTEri imm:$s, always, noeff)>;
def : Pat<(zextloadi8 addr:$s), (RDBYTErr P2GPR:$s, always, noeff)>;
def : Pat<(zextloadi16 imm:$s), (RDWORDri imm:$s, always, noeff)>;
def : Pat<(zextloadi16 addr:$s), (RDWORDrr P2GPR:$s, always, noeff)>;
def : Pat<(load imm:$s), (RDLONGri imm:$s, always, noeff)>;
def : Pat<(i32 (load addr:$s)), (RDLONGrr P2GPR:$s, always, noeff)>;

def : Pat<(truncstorei8 P2GPR:$d, addr:$s), (WRBYTErr P2GPR:$d, P2GPR:$s, always)>;
def : Pat<(truncstorei8 i32immleaf:$d, addr:$s), (WRBYTEir imm:$d, P2GPR:$s, always)>;
def : Pat<(truncstorei16 P2GPR:$d, addr:$s), (WRWORDrr P2GPR:$d, P2GPR:$s, always)>;
def : Pat<(truncstorei16 i32immleaf:$d, addr:$s), (WRWORDir imm:$d, P2GPR:$s, always)>;

def : Pat<(store P2GPR:$d, imm:$s), (WRLONGri P2GPR:$d, imm:$s, always)>;
def : Pat<(store i32immleaf:$d, imm:$s), (WRLONGii imm:$d, imm:$s, always)>;
def : Pat<(store P2GPR:$d, addr:$s), (WRLONGrr P2GPR:$d, P2GPR:$s, always)>;
def : Pat<(store i32immleaf:$d, addr:$s), (WRLONGir imm:$d, P2GPR:$s, always)>;
def : Pat<(store i64:$d, addr:$s), (WRDLONG P2GPRPair:$d, P2GPR:$s)>;

def : Pat<(extloadi8 addr:$s), (RDBYTErr P2GPR:$s, always, noeff)>;
def : Pat<(extloadi16 addr:$s), (RDWORDrr P2GPR:$s, always, noeff)>;

def : Pat<(sextloadi1 addr:$s), (SIGNXri (RDBYTErr P2GPR:$s, always, noeff), 1, always, noeff)>;
def : Pat<(sextloadi8 addr:$s), (SIGNXri (RDBYTErr P2GPR:$s, always, noeff), 7, always, noeff)>;
def : Pat<(sextloadi16 addr:$s), (SIGNXri (RDWORDrr P2GPR:$s, always, noeff), 15, always, noeff)>;

def : Pat<(i32 (trunc P2GPRPair:$s)), (EXTRACT_SUBREG P2GPRPair:$s, sub0)>;

/*--------------------------------*/
/* Register indirection           */
/*--------------------------------*/

let hasSideEffects = 1 in {
    defm ALTS   : P2InstIDSm<0b100110010, "alts">;
}

/*--------------------------------*/
/* function calling and globals   */
/*--------------------------------*/

let isTerminator = 1, isReturn = 1, isBarrier = 1 in {
    def RET     : P2InstCZ<0b11010111, 0b000000000, 0b000101101, (outs), (ins), "ret">;
    def RETA    : P2InstCZ<0b11010111, 0b000000000, 0b000101110, (outs), (ins), "reta">; // primarily use this for returns
}

let isCall = 1, Uses = [PTRA], DecoderMethod = "DecodeCallInstruction" in {
    def CALL    : P2InstRA<0b1101101, 0b1, (outs), (ins relcalltarget:$a), "call $a">; // use this for relative function calls in cog mode.
    def CALLa   : P2InstRA<0b1101101, 0b0, (outs), (ins abscalltarget:$a), "call $a">; // use this for absolute function calls in cog mode.
    def CALLAa   : P2InstRA<0b1101110, 0b0, (outs), (ins abscalltarget:$a), "calla $a">; // mainly use this for direct function calls
    def CALLr    : P2InstCZD<0b1101011, 0b000101101, (outs), (ins P2GPR:$d), "call $d">;
    def CALLAr   : P2InstCZD<0b1101011, 0b000101110, (outs), (ins P2GPR:$d), "calla $d">; // mainly use this for function calls with register input
}

let Defs = [PTRA], Uses = [PTRA] in {
    def ADJCALLSTACKUP      : Pseudo<(outs), (ins i32imm:$amt1, i32imm:$amt2), "ADJCALLSTACKUP">;
    def ADJCALLSTACKDOWN    : Pseudo<(outs), (ins i32imm:$amt, i32imm:$amt2), "ADJCALLSTACKDOWN">;
}

def : Pat<(P2RET), (RETA always, noeff)>;
def : Pat<(P2callseq_start timm:$amt1, timm:$amt2), (ADJCALLSTACKUP i32imm:$amt1, i32imm:$amt2)>;
def : Pat<(P2callseq_end timm:$amt1, timm:$amt2), (ADJCALLSTACKDOWN i32imm:$amt1, i32imm:$amt2)>;

def : Pat<(P2GAWrapper tglobaladdr:$addr), (MOVri tglobaladdr:$addr, always, noeff)>;
def : Pat<(P2GAWrapper tjumptable:$addr), (MOVri tjumptable:$addr, always, noeff)>;

def : Pat<(P2CALL (i32 tglobaladdr:$dst)), (CALLAa tglobaladdr:$dst, always)>;
def : Pat<(P2CALL (i32 texternalsym:$dst)), (CALLAa texternalsym:$dst, always)>;
def : Pat<(P2CALL (i32 P2GPR:$d)), (CALLAr P2GPR:$d, always, noeff)>;

/*--------------------------------*/
/* I/O and hardware control       */
/*--------------------------------*/

let DecoderMethod = "DecodeIOInstruction", hasSideEffects = 1 in {

    defm DIRL       : P2InstCZLDm<0b1101011, 0b001000000, "dirl">;
    defm DIRH       : P2InstCZLDm<0b1101011, 0b001000001, "dirh">;
    defm DIRNOT     : P2InstCZLDm<0b1101011, 0b001000111, "dirnot">;
    defm OUTL       : P2InstCZLDm<0b1101011, 0b001001000, "outl">;
    defm OUTH       : P2InstCZLDm<0b1101011, 0b001001001, "outh">;
    defm OUTNOT     : P2InstCZLDm<0b1101011, 0b001001111, "outnot">;
    defm DRVL       : P2InstCZLDm<0b1101011, 0b001011000, "drvl">;
    defm DRVH       : P2InstCZLDm<0b1101011, 0b001011001, "drvh">;
    defm DRVNOT     : P2InstCZLDm<0b1101011, 0b001011111, "drvnot">;
    defm FLTL       : P2InstCZLDm<0b1101011, 0b001010000, "fltl">;
    defm FLTH       : P2InstCZLDm<0b1101011, 0b001010001, "flth">;
    defm FLTNOT     : P2InstCZLDm<0b1101011, 0b001010111, "fltnot">;

    let cz = 0b10 in defm TESTPc      : P2InstCZLDm<0b1101011, 0b001000000, "testp">;
    let cz = 0b01 in defm TESTPz      : P2InstCZLDm<0b1101011, 0b001000000, "testp">;

    let cz = 0b10 in defm TESTPNc     : P2InstCZLDm<0b1101011, 0b001000001, "testpn">;
    let cz = 0b01 in defm TESTPNz     : P2InstCZLDm<0b1101011, 0b001000001, "testpn">;
}

// Special test instructions that require c or z
let cz = 0b10 in defm TESTBc    : P2InstCZIDS2im<0b0100000, "testb">;
let cz = 0b01 in defm TESTBz    : P2InstCZIDS2im<0b0100000, "testb">;

let cz = 0b10 in defm TESTBNc   : P2InstCZIDS2im<0b0100001, "testbn">;
let cz = 0b01 in defm TESTBNz   : P2InstCZIDS2im<0b0100001, "testbn">;

// no multiclass, since this is an output instead of an input
def COGIDr      : P2InstCLD<0b1101011, 0b000000001, 0b0, (outs P2GPR:$d), (ins), "cogid $d">;
def GETCT       : P2InstCZD<0b1101011, 0b000011010, (outs P2GPR:$d), (ins), "getct $d">;

defm COGINIT    : P2InstCLIDSm<0b1100111, "coginit">;
defm COGSTOP    : P2InstLDm<0b1101011, 0b000000011, "cogstop">;
defm WAITX      : P2InstCZLDm<0b1101011, 0b000011111, "waitx">;
defm HUBSET     : P2InstLDm<0b1101011, 0b000000000, "hubset">;

defm WRPIN      : P2InstLIDSm<0b11000000, "wrpin">;
defm WXPIN      : P2InstLIDSm<0b11000001, "wxpin">;
defm WYPIN      : P2InstLIDSm<0b11000010, "wypin">;

// no multiclass, since there's an output
def RQPINrr     : P2InstCIDS<0b10101000, 0b0, (outs P2GPR:$d), (ins P2GPR:$s), "rqpin $d, $s">;
def RQPINri     : P2InstCIDS<0b10101000, 0b1, (outs P2GPR:$d), (ins i32imm:$s), "rqpin $d, $s">;
def RDPINrr     : P2InstCIDS<0b10101001, 0b0, (outs P2GPR:$d), (ins P2GPR:$s), "rdpin $d, $s">;
def RDPINri     : P2InstCIDS<0b10101001, 0b1, (outs P2GPR:$d), (ins i32imm:$s), "rdpin $d, $s">;

def LOCKNEW     : P2InstCLD<0b1101011, 0b000000100, 0b0, (outs P2GPR:$d), (ins), "locknew $d">; // this instruction has no L=1 variant
defm LOCKRET    : P2InstLDm<0b1101011, 0b000000101, "lockret">;
defm LOCKTRY    : P2InstCLDm<0b1101011, 0b000000110, "locktry">;
defm LOCKREL    : P2InstCLDm<0b1101011, 0b000000111, "lockrel">;

defm SETXFRQ    : P2InstLDm<0b1101011, 0b000011101, "setxfrq">;

defm XINIT      : P2InstLIDSm<0b11001010, "xinit">;
defm XCONT      : P2InstLIDSm<0b11001100, "xcont">;

/*--------------------------------*/
/* Interrupts and events          */
/*--------------------------------*/

defm SETSE1     : P2InstLDm<0b1101011, 0b000100000, "setse1">;
defm SETSE2     : P2InstLDm<0b1101011, 0b000100001, "setse2">;
defm SETSE3     : P2InstLDm<0b1101011, 0b000100010, "setse3">;
defm SETSE4     : P2InstLDm<0b1101011, 0b000100011, "setse4">;

def WAITSE1     : P2InstCZ<0b11010110, 0b000010100, 0b000100100, (outs), (ins), "waitse1">;
def WAITSE2     : P2InstCZ<0b11010110, 0b000010101, 0b000100100, (outs), (ins), "waitse2">;
def WAITSE3     : P2InstCZ<0b11010110, 0b000010110, 0b000100100, (outs), (ins), "waitse3">;
def WAITSE4     : P2InstCZ<0b11010110, 0b000010111, 0b000100100, (outs), (ins), "waitse4">;

defm ADDCT1     : P2InstIDSm<0b101001100, "addct1">;
defm ADDCT2     : P2InstIDSm<0b101001101, "addct2">;
defm ADDCT3     : P2InstIDSm<0b101001110, "addct3">;

def WAITCT1     : P2InstCZ<0b11010110, 0b000010001, 0b000100100, (outs), (ins), "waitct1">;
def WAITCT2     : P2InstCZ<0b11010110, 0b000010010, 0b000100100, (outs), (ins), "waitct2">;
def WAITCT3     : P2InstCZ<0b11010110, 0b000010011, 0b000100100, (outs), (ins), "waitct3">;

def GETBRK      : P2InstCZD<0b1101011, 0b000110101, (outs P2GPR:$d), (ins), "getbrk $d">;
defm COGBRK     : P2InstLDm<0b1101011, 0b000110101, "cogbrk">;
defm BRK        : P2InstLDm<0b1101011, 0b000110110, "brk">;

/*--------------------------------*/
/* misc instructions              */
/*--------------------------------*/

let Uses = [SW] in {
    def WRC         : P2InstD<0b1101011, 0b001101100, (outs P2GPR:$d), (ins), "wrc $d">;
    def WRNC        : P2InstD<0b1101011, 0b001101101, (outs P2GPR:$d), (ins), "wrnc $d">;
    def WRZ         : P2InstD<0b1101011, 0b001101110, (outs P2GPR:$d), (ins), "wrz $d">;
    def WRNZ        : P2InstD<0b1101011, 0b001101111, (outs P2GPR:$d), (ins), "wrnz $d">;
}

def NOP         : P2InstNOP;
def AUGS        : P2InstN<0b11110, (outs), (ins i32imm:$n23), "augs $n23">;
def AUGD        : P2InstN<0b11111, (outs), (ins i32imm:$n23), "augd $n23">;

def FRMIDX      : Pseudo<(outs P2GPR:$dst), (ins P2GPR:$src), "frmidx $dst, $src">;

/*--------------------------------*/
/* alias instructions             */
/*--------------------------------*/

def AKPINir     : InstAlias<"$cc akpin $s", (WRPINir 1, P2GPR:$s, P2Cond:$cc)>;
def AKPINii     : InstAlias<"$cc akpin $s", (WRPINii 1, i32imm:$s, P2Cond:$cc)>;