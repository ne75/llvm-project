; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @shl32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: shl32_rr:
; CHECK: shl r0, r1
    %r = shl i32 %a, %b
    ret i32 %r
}

define i32 @shl32_ri(i32 %a) {
; CHECK-LABEL: shl32_ri:
; CHECK: shl r0, #1
    %r = shl i32 %a, 1
    ret i32 %r
}

define i64 @shl64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  shl64_rr:
; CHECK:        calla __ashldi3
    %r = shl i64 %a, %b
    ret i64 %r
}