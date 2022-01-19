; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @sdiv32_rr(i32 %a, i32 %b) {
; CHECK-LABEL:  sdiv32_rr:
; CHECK:        calla __divsi3
    %r = sdiv i32 %a, %b
    ret i32 %r
}

define i64 @sdiv64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  sdiv64_rr:
; CHECK:        calla __divdi3
    %r = sdiv i64 %a, %b
    ret i64 %r
}