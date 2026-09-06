; RUN: llc -march=p2 -verify-machineinstrs %s -o - | FileCheck %s
; Hardware counterpart: tests/hardware/constant-address-driver.c.
; CHECK-LABEL: constant_load:
; CHECK: mov [[ADDR:r[0-9]+]], #256
; CHECK: rdlong {{r[0-9]+}}, [[ADDR]]
define i32 @constant_load() {
  %v = load volatile i32, i32* inttoptr (i32 256 to i32*), align 4
  ret i32 %v
}
; CHECK-LABEL: constant_store:
; CHECK: mov [[ADDR:r[0-9]+]], #260
; CHECK: wrlong #123, [[ADDR]]
define void @constant_store() {
  store volatile i32 123, i32* inttoptr (i32 260 to i32*), align 4
  ret void
}
