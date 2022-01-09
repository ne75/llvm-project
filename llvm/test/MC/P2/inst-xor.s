
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ xor r0, r1
	if_nc_and_nz xor r0, r1
	if_nc_and_z xor r0, r1
	if_nc xor r0, r1
	if_c_and_nz xor r0, r1
	if_nz xor r0, r1
	if_c_ne_z xor r0, r1
	if_nc_or_nz xor r0, r1
	if_c_and_z xor r0, r1
	if_c_eq_z xor r0, r1
	if_z xor r0, r1
	if_nc_or_z xor r0, r1
	if_c xor r0, r1
	if_c_or_nz xor r0, r1
	if_c_or_z xor r0, r1
	xor r0, r1
	xor r0, #1
	_ret_ xor r0, r1 wc
	_ret_ xor r0, r1 wz
	_ret_ xor r0, r1 wcz


' CHECK: _ret_ xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x05]
' CHECK-INST: _ret_ xor r0, r1


' CHECK: if_nc_and_nz xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x15]
' CHECK-INST: if_nc_and_nz xor r0, r1


' CHECK: if_nc_and_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x25]
' CHECK-INST: if_nc_and_z xor r0, r1


' CHECK: if_nc xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x35]
' CHECK-INST: if_nc xor r0, r1


' CHECK: if_c_and_nz xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x45]
' CHECK-INST: if_c_and_nz xor r0, r1


' CHECK: if_nz xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x55]
' CHECK-INST: if_nz xor r0, r1


' CHECK: if_c_ne_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x65]
' CHECK-INST: if_c_ne_z xor r0, r1


' CHECK: if_nc_or_nz xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x75]
' CHECK-INST: if_nc_or_nz xor r0, r1


' CHECK: if_c_and_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x85]
' CHECK-INST: if_c_and_z xor r0, r1


' CHECK: if_c_eq_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0x95]
' CHECK-INST: if_c_eq_z xor r0, r1


' CHECK: if_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa5]
' CHECK-INST: if_z xor r0, r1


' CHECK: if_nc_or_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb5]
' CHECK-INST: if_nc_or_z xor r0, r1


' CHECK: if_c xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc5]
' CHECK-INST: if_c xor r0, r1


' CHECK: if_c_or_nz xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd5]
' CHECK-INST: if_c_or_nz xor r0, r1


' CHECK: if_c_or_z xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe5]
' CHECK-INST: if_c_or_z xor r0, r1


' CHECK: xor r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf5]
' CHECK-INST: xor r0, r1


' CHECK: xor r0, #1 ' encoding: [0x01,0xa0,0x67,0xf5]
' CHECK-INST: xor r0, #1


' CHECK: _ret_ xor r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x05]
' CHECK-INST: _ret_ xor r0, r1 wc


' CHECK: _ret_ xor r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x05]
' CHECK-INST: _ret_ xor r0, r1 wz


' CHECK: _ret_ xor r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x05]
' CHECK-INST: _ret_ xor r0, r1 wcz

