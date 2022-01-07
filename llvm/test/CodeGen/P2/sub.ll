; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @sub32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: sub32_rr:
; CHECK: sub r0, r1
    %r = sub i32 %a, %b
    ret i32 %r
}

define i32 @sub32_ri(i32 %a) {
; CHECK-LABEL: sub32_ri:
; CHECK: sub r0, #1
    %r = sub i32 %a, 1
    ret i32 %r
}

define i64 @sub64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  sub64_rr:
; CHECK:        sub r0, r2 wc
; CHECK-NEXT:   subx r1, r3
    %r = sub i64 %a, %b
    ret i64 %r
}