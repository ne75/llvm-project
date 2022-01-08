
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrlong r0, r1
	if_nc_and_nz wrlong r0, r1
	if_nc_and_z wrlong r0, r1
	if_nc wrlong r0, r1
	if_c_and_nz wrlong r0, r1
	if_nz wrlong r0, r1
	if_c_ne_z wrlong r0, r1
	if_nc_or_nz wrlong r0, r1
	if_c_and_z wrlong r0, r1
	if_c_eq_z wrlong r0, r1
	if_z wrlong r0, r1
	if_nc_or_z wrlong r0, r1
	if_c wrlong r0, r1
	if_c_or_nz wrlong r0, r1
	if_c_or_z wrlong r0, r1
	wrlong r0, r1
	wrlong r0, #3
	wrlong #3, r0
	wrlong #3, #3
	_ret_ wrlong r0, r1


' CHECK: _ret_ wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x0c]
' CHECK-INST: _ret_ wrlong r0, r1


' CHECK: if_nc_and_nz wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x1c]
' CHECK-INST: if_nc_and_nz wrlong r0, r1


' CHECK: if_nc_and_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x2c]
' CHECK-INST: if_nc_and_z wrlong r0, r1


' CHECK: if_nc wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x3c]
' CHECK-INST: if_nc wrlong r0, r1


' CHECK: if_c_and_nz wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x4c]
' CHECK-INST: if_c_and_nz wrlong r0, r1


' CHECK: if_nz wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x5c]
' CHECK-INST: if_nz wrlong r0, r1


' CHECK: if_c_ne_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x6c]
' CHECK-INST: if_c_ne_z wrlong r0, r1


' CHECK: if_nc_or_nz wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x7c]
' CHECK-INST: if_nc_or_nz wrlong r0, r1


' CHECK: if_c_and_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x8c]
' CHECK-INST: if_c_and_z wrlong r0, r1


' CHECK: if_c_eq_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x9c]
' CHECK-INST: if_c_eq_z wrlong r0, r1


' CHECK: if_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xac]
' CHECK-INST: if_z wrlong r0, r1


' CHECK: if_nc_or_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xbc]
' CHECK-INST: if_nc_or_z wrlong r0, r1


' CHECK: if_c wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xcc]
' CHECK-INST: if_c wrlong r0, r1


' CHECK: if_c_or_nz wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xdc]
' CHECK-INST: if_c_or_nz wrlong r0, r1


' CHECK: if_c_or_z wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xec]
' CHECK-INST: if_c_or_z wrlong r0, r1


' CHECK: wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0xfc]
' CHECK-INST: wrlong r0, r1


' CHECK: wrlong r0, #3 ' encoding: [0x03,0xa0,0x67,0xfc]
' CHECK-INST: wrlong r0, #3


' CHECK: wrlong #3, r0 ' encoding: [0xd0,0x07,0x68,0xfc]
' CHECK-INST: wrlong #3, r0


' CHECK: wrlong #3, #3 ' encoding: [0x03,0x06,0x6c,0xfc]
' CHECK-INST: wrlong #3, #3


' CHECK: _ret_ wrlong r0, r1 ' encoding: [0xd1,0xa1,0x63,0x0c]
' CHECK-INST: _ret_ wrlong r0, r1

