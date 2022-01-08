
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ decod r0, r1
	if_nc_and_nz decod r0, r1
	if_nc_and_z decod r0, r1
	if_nc decod r0, r1
	if_c_and_nz decod r0, r1
	if_nz decod r0, r1
	if_c_ne_z decod r0, r1
	if_nc_or_nz decod r0, r1
	if_c_and_z decod r0, r1
	if_c_eq_z decod r0, r1
	if_z decod r0, r1
	if_nc_or_z decod r0, r1
	if_c decod r0, r1
	if_c_or_nz decod r0, r1
	if_c_or_z decod r0, r1
	decod r0, r1
	decod r0, #3
	_ret_ decod r0, r1


' CHECK: _ret_ decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x09]
' CHECK-INST: _ret_ decod r0, r1


' CHECK: if_nc_and_nz decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x19]
' CHECK-INST: if_nc_and_nz decod r0, r1


' CHECK: if_nc_and_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x29]
' CHECK-INST: if_nc_and_z decod r0, r1


' CHECK: if_nc decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x39]
' CHECK-INST: if_nc decod r0, r1


' CHECK: if_c_and_nz decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x49]
' CHECK-INST: if_c_and_nz decod r0, r1


' CHECK: if_nz decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x59]
' CHECK-INST: if_nz decod r0, r1


' CHECK: if_c_ne_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x69]
' CHECK-INST: if_c_ne_z decod r0, r1


' CHECK: if_nc_or_nz decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x79]
' CHECK-INST: if_nc_or_nz decod r0, r1


' CHECK: if_c_and_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x89]
' CHECK-INST: if_c_and_z decod r0, r1


' CHECK: if_c_eq_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x99]
' CHECK-INST: if_c_eq_z decod r0, r1


' CHECK: if_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xa9]
' CHECK-INST: if_z decod r0, r1


' CHECK: if_nc_or_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xb9]
' CHECK-INST: if_nc_or_z decod r0, r1


' CHECK: if_c decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xc9]
' CHECK-INST: if_c decod r0, r1


' CHECK: if_c_or_nz decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xd9]
' CHECK-INST: if_c_or_nz decod r0, r1


' CHECK: if_c_or_z decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xe9]
' CHECK-INST: if_c_or_z decod r0, r1


' CHECK: decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xf9]
' CHECK-INST: decod r0, r1


' CHECK: decod r0, #3 ' encoding: [0x03,0xa0,0xc7,0xf9]
' CHECK-INST: decod r0, #3


' CHECK: _ret_ decod r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x09]
' CHECK-INST: _ret_ decod r0, r1

