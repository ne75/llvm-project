; RUN: llc -march=p2 < %s | FileCheck %s

define void @inline_asm() {
    ; CHECK-LABEL inline_asm:
    ; CHECK: add r0, r1
    ; CHECK: add r0, #1
    ; CHECK: wrlong r0, ptra++
    ; CHECK: rdlong r0, --ptra
    call void asm sideeffect "add r0, r1", ""()
    call void asm sideeffect "augs #12345", ""()
    call void asm sideeffect "add r0, #1", ""()
    call void asm sideeffect "wrlong r0, #353", ""()
    call void asm sideeffect "wrlong r0, #319", ""()
    call void asm sideeffect "wrlong r0, #258", ""()
    call void asm sideeffect "rdlong r0, #351", ""()
    ret void
}