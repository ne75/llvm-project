
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdword r0, r1
	if_nc_and_nz rdword r0, r1
	if_nc_and_z rdword r0, r1
	if_nc rdword r0, r1
	if_c_and_nz rdword r0, r1
	if_nz rdword r0, r1
	if_c_ne_z rdword r0, r1
	if_nc_or_nz rdword r0, r1
	if_c_and_z rdword r0, r1
	if_c_eq_z rdword r0, r1
	if_z rdword r0, r1
	if_nc_or_z rdword r0, r1
	if_c rdword r0, r1
	if_c_or_nz rdword r0, r1
	if_c_or_z rdword r0, r1
	rdword r0, r1
	rdword r0, #1
	_ret_ rdword r0, r1 wc
	_ret_ rdword r0, r1 wz
	_ret_ rdword r0, r1 wcz


' CHECK: _ret_ rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x0a]
' CHECK-INST: _ret_ rdword r0, r1


' CHECK: if_nc_and_nz rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x1a]
' CHECK-INST: if_nc_and_nz rdword r0, r1


' CHECK: if_nc_and_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x2a]
' CHECK-INST: if_nc_and_z rdword r0, r1


' CHECK: if_nc rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x3a]
' CHECK-INST: if_nc rdword r0, r1


' CHECK: if_c_and_nz rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x4a]
' CHECK-INST: if_c_and_nz rdword r0, r1


' CHECK: if_nz rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x5a]
' CHECK-INST: if_nz rdword r0, r1


' CHECK: if_c_ne_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x6a]
' CHECK-INST: if_c_ne_z rdword r0, r1


' CHECK: if_nc_or_nz rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x7a]
' CHECK-INST: if_nc_or_nz rdword r0, r1


' CHECK: if_c_and_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x8a]
' CHECK-INST: if_c_and_z rdword r0, r1


' CHECK: if_c_eq_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x9a]
' CHECK-INST: if_c_eq_z rdword r0, r1


' CHECK: if_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xaa]
' CHECK-INST: if_z rdword r0, r1


' CHECK: if_nc_or_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xba]
' CHECK-INST: if_nc_or_z rdword r0, r1


' CHECK: if_c rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xca]
' CHECK-INST: if_c rdword r0, r1


' CHECK: if_c_or_nz rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xda]
' CHECK-INST: if_c_or_nz rdword r0, r1


' CHECK: if_c_or_z rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xea]
' CHECK-INST: if_c_or_z rdword r0, r1


' CHECK: rdword r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xfa]
' CHECK-INST: rdword r0, r1


' CHECK: rdword r0, #1 ' encoding: [0x01,0xa0,0xe7,0xfa]
' CHECK-INST: rdword r0, #1


' CHECK: _ret_ rdword r0, r1 wc ' encoding: [0xd1,0xa1,0xf3,0x0a]
' CHECK-INST: _ret_ rdword r0, r1 wc


' CHECK: _ret_ rdword r0, r1 wz ' encoding: [0xd1,0xa1,0xeb,0x0a]
' CHECK-INST: _ret_ rdword r0, r1 wz


' CHECK: _ret_ rdword r0, r1 wcz ' encoding: [0xd1,0xa1,0xfb,0x0a]
' CHECK-INST: _ret_ rdword r0, r1 wcz

