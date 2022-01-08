
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ not r0, r1
	if_nc_and_nz not r0, r1
	if_nc_and_z not r0, r1
	if_nc not r0, r1
	if_c_and_nz not r0, r1
	if_nz not r0, r1
	if_c_ne_z not r0, r1
	if_nc_or_nz not r0, r1
	if_c_and_z not r0, r1
	if_c_eq_z not r0, r1
	if_z not r0, r1
	if_nc_or_z not r0, r1
	if_c not r0, r1
	if_c_or_nz not r0, r1
	if_c_or_z not r0, r1
	not r0, r1
	not r0, #1
	_ret_ not r0, r1 wc
	_ret_ not r0, r1 wz
	_ret_ not r0, r1 wcz


' CHECK: _ret_ not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x06]
' CHECK-INST: _ret_ not r0, r1


' CHECK: if_nc_and_nz not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x16]
' CHECK-INST: if_nc_and_nz not r0, r1


' CHECK: if_nc_and_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x26]
' CHECK-INST: if_nc_and_z not r0, r1


' CHECK: if_nc not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x36]
' CHECK-INST: if_nc not r0, r1


' CHECK: if_c_and_nz not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x46]
' CHECK-INST: if_c_and_nz not r0, r1


' CHECK: if_nz not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x56]
' CHECK-INST: if_nz not r0, r1


' CHECK: if_c_ne_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x66]
' CHECK-INST: if_c_ne_z not r0, r1


' CHECK: if_nc_or_nz not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x76]
' CHECK-INST: if_nc_or_nz not r0, r1


' CHECK: if_c_and_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x86]
' CHECK-INST: if_c_and_z not r0, r1


' CHECK: if_c_eq_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0x96]
' CHECK-INST: if_c_eq_z not r0, r1


' CHECK: if_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xa6]
' CHECK-INST: if_z not r0, r1


' CHECK: if_nc_or_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xb6]
' CHECK-INST: if_nc_or_z not r0, r1


' CHECK: if_c not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xc6]
' CHECK-INST: if_c not r0, r1


' CHECK: if_c_or_nz not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xd6]
' CHECK-INST: if_c_or_nz not r0, r1


' CHECK: if_c_or_z not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xe6]
' CHECK-INST: if_c_or_z not r0, r1


' CHECK: not r0, r1 ' encoding: [0xd1,0xa1,0x23,0xf6]
' CHECK-INST: not r0, r1


' CHECK: not r0, #1 ' encoding: [0x01,0xa0,0x27,0xf6]
' CHECK-INST: not r0, #1


' CHECK: _ret_ not r0, r1 wc ' encoding: [0xd1,0xa1,0x33,0x06]
' CHECK-INST: _ret_ not r0, r1 wc


' CHECK: _ret_ not r0, r1 wz ' encoding: [0xd1,0xa1,0x2b,0x06]
' CHECK-INST: _ret_ not r0, r1 wz


' CHECK: _ret_ not r0, r1 wcz ' encoding: [0xd1,0xa1,0x3b,0x06]
' CHECK-INST: _ret_ not r0, r1 wcz

