
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrword r0, r1
	if_nc_and_nz wrword r0, r1
	if_nc_and_z wrword r0, r1
	if_nc wrword r0, r1
	if_c_and_nz wrword r0, r1
	if_nz wrword r0, r1
	if_c_ne_z wrword r0, r1
	if_nc_or_nz wrword r0, r1
	if_c_and_z wrword r0, r1
	if_c_eq_z wrword r0, r1
	if_z wrword r0, r1
	if_nc_or_z wrword r0, r1
	if_c wrword r0, r1
	if_c_or_nz wrword r0, r1
	if_c_or_z wrword r0, r1
	wrword r0, r1
	wrword r0, #3
	wrword #3, r0
	wrword #3, #3
	_ret_ wrword r0, r1


' CHECK: _ret_ wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x0c]
' CHECK-INST: _ret_ wrword r0, r1


' CHECK: if_nc_and_nz wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x1c]
' CHECK-INST: if_nc_and_nz wrword r0, r1


' CHECK: if_nc_and_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x2c]
' CHECK-INST: if_nc_and_z wrword r0, r1


' CHECK: if_nc wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x3c]
' CHECK-INST: if_nc wrword r0, r1


' CHECK: if_c_and_nz wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x4c]
' CHECK-INST: if_c_and_nz wrword r0, r1


' CHECK: if_nz wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x5c]
' CHECK-INST: if_nz wrword r0, r1


' CHECK: if_c_ne_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x6c]
' CHECK-INST: if_c_ne_z wrword r0, r1


' CHECK: if_nc_or_nz wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x7c]
' CHECK-INST: if_nc_or_nz wrword r0, r1


' CHECK: if_c_and_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x8c]
' CHECK-INST: if_c_and_z wrword r0, r1


' CHECK: if_c_eq_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x9c]
' CHECK-INST: if_c_eq_z wrword r0, r1


' CHECK: if_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xac]
' CHECK-INST: if_z wrword r0, r1


' CHECK: if_nc_or_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xbc]
' CHECK-INST: if_nc_or_z wrword r0, r1


' CHECK: if_c wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xcc]
' CHECK-INST: if_c wrword r0, r1


' CHECK: if_c_or_nz wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xdc]
' CHECK-INST: if_c_or_nz wrword r0, r1


' CHECK: if_c_or_z wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xec]
' CHECK-INST: if_c_or_z wrword r0, r1


' CHECK: wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0xfc]
' CHECK-INST: wrword r0, r1


' CHECK: wrword r0, #3 ' encoding: [0x03,0xa0,0x57,0xfc]
' CHECK-INST: wrword r0, #3


' CHECK: wrword #3, r0 ' encoding: [0xd0,0x07,0x58,0xfc]
' CHECK-INST: wrword #3, r0


' CHECK: wrword #3, #3 ' encoding: [0x03,0x06,0x5c,0xfc]
' CHECK-INST: wrword #3, #3


' CHECK: _ret_ wrword r0, r1 ' encoding: [0xd1,0xa1,0x53,0x0c]
' CHECK-INST: _ret_ wrword r0, r1

