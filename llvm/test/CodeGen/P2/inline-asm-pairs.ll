; RUN: llc -march=p2 -verify-machineinstrs %s -o - | FileCheck %s
; RUN: llc -march=p2 -verify-machineinstrs -filetype=obj %s -o %t.o
; Executable equivalents are in tests/hardware/inline-pair-driver.c.

define i64 @pair_constant() {
; CHECK-LABEL: pair_constant:
; CHECK-NOT: calla
; CHECK: mov r30, #1
; CHECK-NEXT: mov r31, #2
; CHECK-NOT: calla
; CHECK: reta
  %r = call i64 asm sideeffect "mov ${0:L}, #1\0Amov ${0:H}, #2", "={r30_r31}"()
  ret i64 %r
}

define i64 @pair_add(i64 %a, i64 %b) {
; CHECK-LABEL: pair_add:
; CHECK-NOT: calla
; CHECK: add r0, r2{{.*}}wc
; CHECK-NEXT: addx r1, r3
; CHECK-NOT: calla
; CHECK: reta
  %r = call i64 asm "add ${0:L}, ${2:L} wc\0Aaddx ${0:H}, ${2:H}", "=&r,0,r,~{cc}"(i64 %a, i64 %b)
  ret i64 %r
}
