; RUN: llc < %s -march=p2 -verify-machineinstrs | FileCheck %s
declare i32 @callee(i32)
define i32 @preserve_across_call(i32 %x) {
  %r = call i32 @callee(i32 %x)
  %v = add i32 %r, %x
  ret i32 %v
}
; CHECK-LABEL: preserve_across_call:
; CHECK: wrlong {{r[0-9]+}}, ptra++
; CHECK: calla
; CHECK: rdlong {{r[0-9]+}}, --ptra
; CHECK: reta
