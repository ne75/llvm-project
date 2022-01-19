; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @urem32_rr(i32 %a, i32 %b) {
; CHECK-LABEL:  urem32_rr:
; CHECK:        qdiv r0, r1
; CHECK-NEXT:   getqy r31
    %r = urem i32 %a, %b
    ret i32 %r
}

define i64 @urem64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  urem64_rr:
; CHECK:        calla __umoddi3
    %r = urem i64 %a, %b
    ret i64 %r
}