
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ sub r0, r1
	if_nc_and_nz sub r0, r1
	if_nc_and_z sub r0, r1
	if_nc sub r0, r1
	if_c_and_nz sub r0, r1
	if_nz sub r0, r1
	if_c_ne_z sub r0, r1
	if_nc_or_nz sub r0, r1
	if_c_and_z sub r0, r1
	if_c_eq_z sub r0, r1
	if_z sub r0, r1
	if_nc_or_z sub r0, r1
	if_c sub r0, r1
	if_c_or_nz sub r0, r1
	if_c_or_z sub r0, r1
	sub r0, r1
	sub r0, #1
	_ret_ sub r0, r1 wc
	_ret_ sub r0, r1 wz
	_ret_ sub r0, r1 wcz


' CHECK: _ret_ sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x01]
' CHECK-INST: _ret_ sub r0, r1


' CHECK: if_nc_and_nz sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x11]
' CHECK-INST: if_nc_and_nz sub r0, r1


' CHECK: if_nc_and_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x21]
' CHECK-INST: if_nc_and_z sub r0, r1


' CHECK: if_nc sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x31]
' CHECK-INST: if_nc sub r0, r1


' CHECK: if_c_and_nz sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x41]
' CHECK-INST: if_c_and_nz sub r0, r1


' CHECK: if_nz sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x51]
' CHECK-INST: if_nz sub r0, r1


' CHECK: if_c_ne_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x61]
' CHECK-INST: if_c_ne_z sub r0, r1


' CHECK: if_nc_or_nz sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x71]
' CHECK-INST: if_nc_or_nz sub r0, r1


' CHECK: if_c_and_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x81]
' CHECK-INST: if_c_and_z sub r0, r1


' CHECK: if_c_eq_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0x91]
' CHECK-INST: if_c_eq_z sub r0, r1


' CHECK: if_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xa1]
' CHECK-INST: if_z sub r0, r1


' CHECK: if_nc_or_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xb1]
' CHECK-INST: if_nc_or_z sub r0, r1


' CHECK: if_c sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xc1]
' CHECK-INST: if_c sub r0, r1


' CHECK: if_c_or_nz sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xd1]
' CHECK-INST: if_c_or_nz sub r0, r1


' CHECK: if_c_or_z sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xe1]
' CHECK-INST: if_c_or_z sub r0, r1


' CHECK: sub r0, r1 ' encoding: [0xd1,0xa1,0x83,0xf1]
' CHECK-INST: sub r0, r1


' CHECK: sub r0, #1 ' encoding: [0x01,0xa0,0x87,0xf1]
' CHECK-INST: sub r0, #1


' CHECK: _ret_ sub r0, r1 wc ' encoding: [0xd1,0xa1,0x93,0x01]
' CHECK-INST: _ret_ sub r0, r1 wc


' CHECK: _ret_ sub r0, r1 wz ' encoding: [0xd1,0xa1,0x8b,0x01]
' CHECK-INST: _ret_ sub r0, r1 wz


' CHECK: _ret_ sub r0, r1 wcz ' encoding: [0xd1,0xa1,0x9b,0x01]
' CHECK-INST: _ret_ sub r0, r1 wcz

