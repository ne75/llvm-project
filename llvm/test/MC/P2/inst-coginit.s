
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ coginit r0, r1
	if_nc_and_nz coginit r0, r1
	if_nc_and_z coginit r0, r1
	if_nc coginit r0, r1
	if_c_and_nz coginit r0, r1
	if_nz coginit r0, r1
	if_c_ne_z coginit r0, r1
	if_nc_or_nz coginit r0, r1
	if_c_and_z coginit r0, r1
	if_c_eq_z coginit r0, r1
	if_z coginit r0, r1
	if_nc_or_z coginit r0, r1
	if_c coginit r0, r1
	if_c_or_nz coginit r0, r1
	if_c_or_z coginit r0, r1
	coginit r0, r1
	coginit r0, #3
	coginit #3, r0
	coginit #3, #3
	_ret_ coginit r0, r1 wc


' CHECK: _ret_ coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x0c]
' CHECK-INST: _ret_ coginit r0, r1


' CHECK: if_nc_and_nz coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x1c]
' CHECK-INST: if_nc_and_nz coginit r0, r1


' CHECK: if_nc_and_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x2c]
' CHECK-INST: if_nc_and_z coginit r0, r1


' CHECK: if_nc coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x3c]
' CHECK-INST: if_nc coginit r0, r1


' CHECK: if_c_and_nz coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x4c]
' CHECK-INST: if_c_and_nz coginit r0, r1


' CHECK: if_nz coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x5c]
' CHECK-INST: if_nz coginit r0, r1


' CHECK: if_c_ne_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x6c]
' CHECK-INST: if_c_ne_z coginit r0, r1


' CHECK: if_nc_or_nz coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x7c]
' CHECK-INST: if_nc_or_nz coginit r0, r1


' CHECK: if_c_and_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x8c]
' CHECK-INST: if_c_and_z coginit r0, r1


' CHECK: if_c_eq_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x9c]
' CHECK-INST: if_c_eq_z coginit r0, r1


' CHECK: if_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xac]
' CHECK-INST: if_z coginit r0, r1


' CHECK: if_nc_or_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xbc]
' CHECK-INST: if_nc_or_z coginit r0, r1


' CHECK: if_c coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xcc]
' CHECK-INST: if_c coginit r0, r1


' CHECK: if_c_or_nz coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xdc]
' CHECK-INST: if_c_or_nz coginit r0, r1


' CHECK: if_c_or_z coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xec]
' CHECK-INST: if_c_or_z coginit r0, r1


' CHECK: coginit r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xfc]
' CHECK-INST: coginit r0, r1


' CHECK: coginit r0, #3 ' encoding: [0x03,0xa0,0xe7,0xfc]
' CHECK-INST: coginit r0, #3


' CHECK: coginit #3, r0 ' encoding: [0xd0,0x07,0xe8,0xfc]
' CHECK-INST: coginit #3, r0


' CHECK: coginit #3, #3 ' encoding: [0x03,0x06,0xec,0xfc]
' CHECK-INST: coginit #3, #3


' CHECK: _ret_ coginit r0, r1 wc ' encoding: [0xd1,0xa1,0xf3,0x0c]
' CHECK-INST: _ret_ coginit r0, r1 wc

