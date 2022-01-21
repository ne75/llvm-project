; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @srem32_rr(i32 %a, i32 %b) {
; CHECK-LABEL:  srem32_rr:
; CHECK:        calla #\__modsi3
    %r = srem i32 %a, %b
    ret i32 %r
}

define i64 @srem64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  srem64_rr:
; CHECK:        calla #\__moddi3
    %r = srem i64 %a, %b
    ret i64 %r
}