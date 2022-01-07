' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
  add $r0, $r1

' CHECK: add r0, r1               ' encoding: [0xd1,0xa1,0x03,0xf1]
' CHECK-INST: add r0, r1
