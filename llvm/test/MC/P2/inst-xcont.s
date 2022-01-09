
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ xcont r0, r1
	if_nc_and_nz xcont r0, r1
	if_nc_and_z xcont r0, r1
	if_nc xcont r0, r1
	if_c_and_nz xcont r0, r1
	if_nz xcont r0, r1
	if_c_ne_z xcont r0, r1
	if_nc_or_nz xcont r0, r1
	if_c_and_z xcont r0, r1
	if_c_eq_z xcont r0, r1
	if_z xcont r0, r1
	if_nc_or_z xcont r0, r1
	if_c xcont r0, r1
	if_c_or_nz xcont r0, r1
	if_c_or_z xcont r0, r1
	xcont r0, r1
	xcont r0, #3
	xcont #3, r0
	xcont #3, #3
	_ret_ xcont r0, r1


' CHECK: _ret_ xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x0c]
' CHECK-INST: _ret_ xcont r0, r1


' CHECK: if_nc_and_nz xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x1c]
' CHECK-INST: if_nc_and_nz xcont r0, r1


' CHECK: if_nc_and_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x2c]
' CHECK-INST: if_nc_and_z xcont r0, r1


' CHECK: if_nc xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x3c]
' CHECK-INST: if_nc xcont r0, r1


' CHECK: if_c_and_nz xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x4c]
' CHECK-INST: if_c_and_nz xcont r0, r1


' CHECK: if_nz xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x5c]
' CHECK-INST: if_nz xcont r0, r1


' CHECK: if_c_ne_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x6c]
' CHECK-INST: if_c_ne_z xcont r0, r1


' CHECK: if_nc_or_nz xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x7c]
' CHECK-INST: if_nc_or_nz xcont r0, r1


' CHECK: if_c_and_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x8c]
' CHECK-INST: if_c_and_z xcont r0, r1


' CHECK: if_c_eq_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x9c]
' CHECK-INST: if_c_eq_z xcont r0, r1


' CHECK: if_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xac]
' CHECK-INST: if_z xcont r0, r1


' CHECK: if_nc_or_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xbc]
' CHECK-INST: if_nc_or_z xcont r0, r1


' CHECK: if_c xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xcc]
' CHECK-INST: if_c xcont r0, r1


' CHECK: if_c_or_nz xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xdc]
' CHECK-INST: if_c_or_nz xcont r0, r1


' CHECK: if_c_or_z xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xec]
' CHECK-INST: if_c_or_z xcont r0, r1


' CHECK: xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xfc]
' CHECK-INST: xcont r0, r1


' CHECK: xcont r0, #3 ' encoding: [0x03,0xa0,0xc7,0xfc]
' CHECK-INST: xcont r0, #3


' CHECK: xcont #3, r0 ' encoding: [0xd0,0x07,0xc8,0xfc]
' CHECK-INST: xcont #3, r0


' CHECK: xcont #3, #3 ' encoding: [0x03,0x06,0xcc,0xfc]
' CHECK-INST: xcont #3, #3


' CHECK: _ret_ xcont r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x0c]
' CHECK-INST: _ret_ xcont r0, r1

