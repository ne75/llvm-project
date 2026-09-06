; RUN: not llc -march=p2 %s -o /dev/null 2>&1 | FileCheck %s
; CHECK: invalid P2 register name: missing
; Negative capability test; no firmware exists for an invalid register name.
declare i32 @llvm.read_register.i32(metadata)
define i32 @read_invalid() {
  %v = call i32 @llvm.read_register.i32(metadata !0)
  ret i32 %v
}
!0 = !{!"missing"}
