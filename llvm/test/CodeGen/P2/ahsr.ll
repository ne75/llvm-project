; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @ashr32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: ashr32_rr:
; CHECK: sar r0, r1
    %r = ashr i32 %a, %b
    ret i32 %r
}

define i32 @ashr32_ri(i32 %a) {
; CHECK-LABEL: ashr32_ri:
; CHECK: sar r0, #1
    %r = ashr i32 %a, 1
    ret i32 %r
}

define i64 @ashr64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  ashr64_rr:
; CHECK:        calla __ashrdi3
    %r = ashr i64 %a, %b
    ret i64 %r
}