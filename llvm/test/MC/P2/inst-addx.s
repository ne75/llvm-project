
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ addx r0, r1
	if_nc_and_nz addx r0, r1
	if_nc_and_z addx r0, r1
	if_nc addx r0, r1
	if_c_and_nz addx r0, r1
	if_nz addx r0, r1
	if_c_ne_z addx r0, r1
	if_nc_or_nz addx r0, r1
	if_c_and_z addx r0, r1
	if_c_eq_z addx r0, r1
	if_z addx r0, r1
	if_nc_or_z addx r0, r1
	if_c addx r0, r1
	if_c_or_nz addx r0, r1
	if_c_or_z addx r0, r1
	addx r0, r1
	addx r0, #1
	_ret_ addx r0, r1 wc
	_ret_ addx r0, r1 wz
	_ret_ addx r0, r1 wcz


' CHECK: _ret_ addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x01]
' CHECK-INST: _ret_ addx r0, r1


' CHECK: if_nc_and_nz addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x11]
' CHECK-INST: if_nc_and_nz addx r0, r1


' CHECK: if_nc_and_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x21]
' CHECK-INST: if_nc_and_z addx r0, r1


' CHECK: if_nc addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x31]
' CHECK-INST: if_nc addx r0, r1


' CHECK: if_c_and_nz addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x41]
' CHECK-INST: if_c_and_nz addx r0, r1


' CHECK: if_nz addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x51]
' CHECK-INST: if_nz addx r0, r1


' CHECK: if_c_ne_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x61]
' CHECK-INST: if_c_ne_z addx r0, r1


' CHECK: if_nc_or_nz addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x71]
' CHECK-INST: if_nc_or_nz addx r0, r1


' CHECK: if_c_and_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x81]
' CHECK-INST: if_c_and_z addx r0, r1


' CHECK: if_c_eq_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x91]
' CHECK-INST: if_c_eq_z addx r0, r1


' CHECK: if_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xa1]
' CHECK-INST: if_z addx r0, r1


' CHECK: if_nc_or_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xb1]
' CHECK-INST: if_nc_or_z addx r0, r1


' CHECK: if_c addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xc1]
' CHECK-INST: if_c addx r0, r1


' CHECK: if_c_or_nz addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xd1]
' CHECK-INST: if_c_or_nz addx r0, r1


' CHECK: if_c_or_z addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xe1]
' CHECK-INST: if_c_or_z addx r0, r1


' CHECK: addx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xf1]
' CHECK-INST: addx r0, r1


' CHECK: addx r0, #1 ' encoding: [0x01,0xa0,0x27,0xf1]
' CHECK-INST: addx r0, #1


' CHECK: _ret_ addx r0, r1 wc ' encoding: [0xd1,0xa1,0x33,0x01]
' CHECK-INST: _ret_ addx r0, r1 wc


' CHECK: _ret_ addx r0, r1 wz ' encoding: [0xd1,0xa1,0x2b,0x01]
' CHECK-INST: _ret_ addx r0, r1 wz


' CHECK: _ret_ addx r0, r1 wcz ' encoding: [0xd1,0xa1,0x3b,0x01]
' CHECK-INST: _ret_ addx r0, r1 wcz

