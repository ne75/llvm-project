; RUN: llc -march=p2 -verify-machineinstrs < %s | FileCheck %s
; Hardware observations: tests/hardware/arithmetic-driver.c in the parent repo.
declare { i32, i1 } @llvm.smul.with.overflow.i32(i32, i32)
declare i32 @llvm.ctlz.i32(i32, i1 immarg)

define i32 @load_boolean(i1* %p) {
  %v = load i1, i1* %p, align 1
  %r = zext i1 %v to i32
  ret i32 %r
}
; CHECK-LABEL: load_boolean:
; CHECK: rdbyte {{r[0-9]+}}, r0

define i32 @signed_compare(i64 %a, i64 %b) {
  %c = icmp slt i64 %a, %b
  %r = zext i1 %c to i32
  ret i32 %r
}
; CHECK-LABEL: signed_compare:
; CHECK: cmp r0, r2
; CHECK-NEXT: {{.*}}cmpsx r1, r3

define i32 @signed_overflow(i32 %a, i32 %b) {
  %pair = call { i32, i1 } @llvm.smul.with.overflow.i32(i32 %a, i32 %b)
  %flag = extractvalue { i32, i1 } %pair, 1
  %r = zext i1 %flag to i32
  ret i32 %r
}
define i32 @count_leading_zeros(i32 %a) {
  %r = call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  ret i32 %r
}
; CHECK-LABEL: count_leading_zeros:
; CHECK: #32

define i32 @indirect_branch(i32 %x) {
entry:
  %c = icmp eq i32 %x, 0
  %target = select i1 %c, i8* blockaddress(@indirect_branch, %zero), i8* blockaddress(@indirect_branch, %other)
  indirectbr i8* %target, [label %zero, label %other]
zero:
  ret i32 19
other:
  ret i32 23
}
; CHECK-LABEL: indirect_branch:
; CHECK-NOT: _ret_
; CHECK: jmp r
