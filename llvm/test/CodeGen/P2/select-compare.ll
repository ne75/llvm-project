; RUN: llc -march=p2 -O0 -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -march=p2 -O2 -verify-machineinstrs < %s | FileCheck %s
; Executed by the root repository's select-compare hardware/host suite.

define i32 @select_slt32(i32 %a, i32 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_slt32:
; CHECK: cmps {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK: if_c {{.*}}mov
; CHECK: if_nc {{.*}}mov
  %c = icmp slt i32 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_sle32(i32 %a, i32 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_sle32:
; CHECK: cmps {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK: if_c_or_z {{.*}}mov
  %c = icmp sle i32 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_sgt32(i32 %a, i32 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_sgt32:
; CHECK: cmps {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK: if_nc_and_nz {{.*}}mov
  %c = icmp sgt i32 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_sge32(i32 %a, i32 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_sge32:
; CHECK: cmps {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK: if_nc {{.*}}mov
  %c = icmp sge i32 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_ult32(i32 %a, i32 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_ult32:
; CHECK: cmp {{r[0-9]+}}, {{r[0-9]+}} wcz
  %c = icmp ult i32 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_slt32_imm(i32 %a, i32 %t, i32 %f) {
; CHECK-LABEL: select_slt32_imm:
; CHECK: cmps {{r[0-9]+}}, #{{[0-9]+}} wcz
  %c = icmp slt i32 %a, 2
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_ult32_imm(i32 %a, i32 %t, i32 %f) {
; CHECK-LABEL: select_ult32_imm:
; CHECK: cmp {{r[0-9]+}}, #{{[0-9]+}} wcz
  %c = icmp ult i32 %a, 2
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

; Signed 64-bit comparisons must still use unsigned CMP on the low word.
define i32 @select_slt64(i64 %a, i64 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_slt64:
; CHECK: cmp {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK-NEXT: cmpsx {{r[0-9]+}}, {{r[0-9]+}} wcz
  %c = icmp slt i64 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_ult64(i64 %a, i64 %b, i32 %t, i32 %f) {
; CHECK-LABEL: select_ult64:
; CHECK: cmp {{r[0-9]+}}, {{r[0-9]+}} wcz
; CHECK-NEXT: cmpx {{r[0-9]+}}, {{r[0-9]+}} wcz
  %c = icmp ult i64 %a, %b
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}

define i32 @select_slt64_imm(i64 %a, i32 %t, i32 %f) {
; CHECK-LABEL: select_slt64_imm:
; CHECK: cmp {{r[0-9]+}}, #2 wcz
; CHECK-NEXT: cmpsx {{r[0-9]+}}, #1 wcz
  %c = icmp slt i64 %a, 4294967298
  %r = select i1 %c, i32 %t, i32 %f
  ret i32 %r
}
