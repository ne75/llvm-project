; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @xor32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: xor32_rr:
; CHECK: xor r0, r1
    %r = xor i32 %a, %b
    ret i32 %r
}

define i32 @xor32_ri(i32 %a) {
; CHECK-LABEL: xor32_ri:
; CHECK: xor r0, #1
    %r = xor i32 %a, 1
    ret i32 %r
}

define i64 @xor64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  xor64_rr:
; CHECK:        xor r0, r2
; CHECK-NEXT:   xor r1, r3
    %r = xor i64 %a, %b
    ret i64 %r
}