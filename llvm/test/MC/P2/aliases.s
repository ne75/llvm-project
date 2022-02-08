
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
    akpin r0
    akpin #1

' CHECK: wrpin #1, r0 ' encoding: [0xd0,0x03,0x08,0xfc]
' CHECK-INST: wrpin #1, r0

' CHECK: wrpin #1, #1 ' encoding: [0x01,0x02,0x0c,0xfc]
' CHECK-INST: wrpin #1, #1