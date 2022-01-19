; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @udiv32_rr(i32 %a, i32 %b) {
; CHECK-LABEL:  udiv32_rr:
; CHECK:        qdiv r0, r1
; CHECK-NEXT:   getqx r31
    %r = udiv i32 %a, %b
    ret i32 %r
}

define i64 @udiv64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  udiv64_rr:
; CHECK:        calla __udivdi3
    %r = udiv i64 %a, %b
    ret i64 %r
}