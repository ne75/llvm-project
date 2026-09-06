; RUN: not llc -march=p2 %s -o /dev/null 2>&1 | FileCheck %s
; CHECK: error: P2 does not support variable-sized stack allocation
; Negative capability test: no executable firmware can be generated.
define void @vla(i32 %n) {
  %p = alloca i8, i32 %n, align 1
  call void @use(i8* %p)
  ret void
}
declare void @use(i8*)
