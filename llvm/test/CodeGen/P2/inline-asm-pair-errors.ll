; RUN: split-file %s %t
; RUN: not llc -march=p2 %t/narrow.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=NARROW
; RUN: not llc -march=p2 %t/modifier.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=MODIFIER
; RUN: not llc -march=p2 %t/wide.ll -o /dev/null 2>&1 | FileCheck %s --check-prefix=WIDE
; These are malformed operands; valid counterparts have hardware fixtures.
; NARROW: couldn't allocate output register for constraint '{r30}'
; MODIFIER: invalid operand in inline asm
; WIDE: couldn't allocate output register for constraint '{r30_r31}'

;--- narrow.ll
define i64 @narrow() {
  %r = call i64 asm "getct r31 wc\0Agetct r30", "={r30}"()
  ret i64 %r
}

;--- modifier.ll
define i32 @word_modifier_on_scalar(i32 %x) {
  %r = call i32 asm "mov $0, ${1:H}", "=r,r"(i32 %x)
  ret i32 %r
}

;--- wide.ll
define i32 @pair_for_scalar() {
  %r = call i32 asm "", "={r30_r31}"()
  ret i32 %r
}
