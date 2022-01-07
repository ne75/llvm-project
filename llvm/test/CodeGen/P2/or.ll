; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @or32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: or32_rr:
; CHECK: or r0, r1
    %r = or i32 %a, %b
    ret i32 %r
}

define i32 @or32_ri(i32 %a) {
; CHECK-LABEL: or32_ri:
; CHECK: or r0, #1
    %r = or i32 %a, 1
    ret i32 %r
}

define i64 @or64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  or64_rr:
; CHECK:        or r0, r2
; CHECK-NEXT:   or r1, r3
    %r = or i64 %a, %b
    ret i64 %r
}