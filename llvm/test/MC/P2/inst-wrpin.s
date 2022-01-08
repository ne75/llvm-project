
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrpin r0, r1
	if_nc_and_nz wrpin r0, r1
	if_nc_and_z wrpin r0, r1
	if_nc wrpin r0, r1
	if_c_and_nz wrpin r0, r1
	if_nz wrpin r0, r1
	if_c_ne_z wrpin r0, r1
	if_nc_or_nz wrpin r0, r1
	if_c_and_z wrpin r0, r1
	if_c_eq_z wrpin r0, r1
	if_z wrpin r0, r1
	if_nc_or_z wrpin r0, r1
	if_c wrpin r0, r1
	if_c_or_nz wrpin r0, r1
	if_c_or_z wrpin r0, r1
	wrpin r0, r1
	wrpin r0, #3
	wrpin #3, r0
	wrpin #3, #3
	_ret_ wrpin r0, r1


' CHECK: _ret_ wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0c]
' CHECK-INST: _ret_ wrpin r0, r1


' CHECK: if_nc_and_nz wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x1c]
' CHECK-INST: if_nc_and_nz wrpin r0, r1


' CHECK: if_nc_and_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x2c]
' CHECK-INST: if_nc_and_z wrpin r0, r1


' CHECK: if_nc wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x3c]
' CHECK-INST: if_nc wrpin r0, r1


' CHECK: if_c_and_nz wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x4c]
' CHECK-INST: if_c_and_nz wrpin r0, r1


' CHECK: if_nz wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x5c]
' CHECK-INST: if_nz wrpin r0, r1


' CHECK: if_c_ne_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x6c]
' CHECK-INST: if_c_ne_z wrpin r0, r1


' CHECK: if_nc_or_nz wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x7c]
' CHECK-INST: if_nc_or_nz wrpin r0, r1


' CHECK: if_c_and_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x8c]
' CHECK-INST: if_c_and_z wrpin r0, r1


' CHECK: if_c_eq_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x9c]
' CHECK-INST: if_c_eq_z wrpin r0, r1


' CHECK: if_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xac]
' CHECK-INST: if_z wrpin r0, r1


' CHECK: if_nc_or_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xbc]
' CHECK-INST: if_nc_or_z wrpin r0, r1


' CHECK: if_c wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xcc]
' CHECK-INST: if_c wrpin r0, r1


' CHECK: if_c_or_nz wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xdc]
' CHECK-INST: if_c_or_nz wrpin r0, r1


' CHECK: if_c_or_z wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xec]
' CHECK-INST: if_c_or_z wrpin r0, r1


' CHECK: wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0xfc]
' CHECK-INST: wrpin r0, r1


' CHECK: wrpin r0, #3 ' encoding: [0x03,0xa0,0x07,0xfc]
' CHECK-INST: wrpin r0, #3


' CHECK: wrpin #3, r0 ' encoding: [0xd0,0x07,0x08,0xfc]
' CHECK-INST: wrpin #3, r0


' CHECK: wrpin #3, #3 ' encoding: [0x03,0x06,0x0c,0xfc]
' CHECK-INST: wrpin #3, #3


' CHECK: _ret_ wrpin r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0c]
' CHECK-INST: _ret_ wrpin r0, r1

