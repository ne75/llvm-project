; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @lshr32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: lshr32_rr:
; CHECK: shr r0, r1
    %r = lshr i32 %a, %b
    ret i32 %r
}

define i32 @lshr32_ri(i32 %a) {
; CHECK-LABEL: lshr32_ri:
; CHECK: shr r0, #1
    %r = lshr i32 %a, 1
    ret i32 %r
}

define i64 @lshr64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  lshr64_rr:
; CHECK:        calla #__lshrdi3
    %r = lshr i64 %a, %b
    ret i64 %r
}