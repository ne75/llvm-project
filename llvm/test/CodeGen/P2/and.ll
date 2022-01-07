; RUN: llc -march=p2 < %s | FileCheck %s

define i32 @and32_rr(i32 %a, i32 %b) {
; CHECK-LABEL: and32_rr:
; CHECK: and r0, r1
    %r = and i32 %a, %b
    ret i32 %r
}

define i32 @and32_ri(i32 %a) {
; CHECK-LABEL: and32_ri:
; CHECK: and r0, #1
    %r = and i32 %a, 1
    ret i32 %r
}

define i64 @and64_rr(i64 %a, i64 %b) {
; CHECK-LABEL:  and64_rr:
; CHECK:        and r0, r2
; CHECK-NEXT:   and r1, r3
    %r = and i64 %a, %b
    ret i64 %r
}