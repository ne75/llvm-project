; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @add32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: add32_rr:
; CHECK: add r0, r1
    %r = add i32 %a, %b
    ret i32 %r
}

define i32 @add32_ri(i32 %a) {
; CHECK-LABEL: add32_ri:
; CHECK: add r0, #1
    %r = add i32 %a, 1
    ret i32 %r
}

define i64 @add64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  add64_rr:
; CHECK:        add r0, r2 wc
; CHECK-NEXT:   addx r1, r3
    %r = add i64 %a, %b
    ret i64 %r
}