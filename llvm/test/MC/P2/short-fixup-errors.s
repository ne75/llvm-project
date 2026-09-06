# RUN: not llvm-mc -triple=p2 -filetype=obj %s -o /dev/null 2>&1 | FileCheck %s
# A valid branch is covered by the executable ISA branch scenarios. This
# malformed resolved target must be rejected, never wrapped to nine bits.
# CHECK: short branch target is unaligned or out of range [-256, 255]
tjz r0, #target
.space 1024
target:
reta
