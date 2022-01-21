; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @mul32_rr(i32 %a, i32 %b) {
; CHECK-LABEL:  mul32_rr:
; CHECK:        qmul r0, r1
; CHECK-NEXT:   getqx r31
    %r = mul i32 %a, %b
    ret i32 %r
}

define i64 @mul64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  mul64_rr:
; CHECK:        calla #\__muldi3
    %r = mul i64 %a, %b
    ret i64 %r
}