
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrfast r0, r1
	if_nc_and_nz wrfast r0, r1
	if_nc_and_z wrfast r0, r1
	if_nc wrfast r0, r1
	if_c_and_nz wrfast r0, r1
	if_nz wrfast r0, r1
	if_c_ne_z wrfast r0, r1
	if_nc_or_nz wrfast r0, r1
	if_c_and_z wrfast r0, r1
	if_c_eq_z wrfast r0, r1
	if_z wrfast r0, r1
	if_nc_or_z wrfast r0, r1
	if_c wrfast r0, r1
	if_c_or_nz wrfast r0, r1
	if_c_or_z wrfast r0, r1
	wrfast r0, r1
	wrfast r0, #3
	wrfast #3, r0
	wrfast #3, #3
	_ret_ wrfast r0, r1


' CHECK: _ret_ wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x0c]
' CHECK-INST: _ret_ wrfast r0, r1


' CHECK: if_nc_and_nz wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x1c]
' CHECK-INST: if_nc_and_nz wrfast r0, r1


' CHECK: if_nc_and_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x2c]
' CHECK-INST: if_nc_and_z wrfast r0, r1


' CHECK: if_nc wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x3c]
' CHECK-INST: if_nc wrfast r0, r1


' CHECK: if_c_and_nz wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x4c]
' CHECK-INST: if_c_and_nz wrfast r0, r1


' CHECK: if_nz wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x5c]
' CHECK-INST: if_nz wrfast r0, r1


' CHECK: if_c_ne_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x6c]
' CHECK-INST: if_c_ne_z wrfast r0, r1


' CHECK: if_nc_or_nz wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x7c]
' CHECK-INST: if_nc_or_nz wrfast r0, r1


' CHECK: if_c_and_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x8c]
' CHECK-INST: if_c_and_z wrfast r0, r1


' CHECK: if_c_eq_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x9c]
' CHECK-INST: if_c_eq_z wrfast r0, r1


' CHECK: if_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xac]
' CHECK-INST: if_z wrfast r0, r1


' CHECK: if_nc_or_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xbc]
' CHECK-INST: if_nc_or_z wrfast r0, r1


' CHECK: if_c wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xcc]
' CHECK-INST: if_c wrfast r0, r1


' CHECK: if_c_or_nz wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xdc]
' CHECK-INST: if_c_or_nz wrfast r0, r1


' CHECK: if_c_or_z wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xec]
' CHECK-INST: if_c_or_z wrfast r0, r1


' CHECK: wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0xfc]
' CHECK-INST: wrfast r0, r1


' CHECK: wrfast r0, #3 ' encoding: [0x03,0xa0,0x87,0xfc]
' CHECK-INST: wrfast r0, #3


' CHECK: wrfast #3, r0 ' encoding: [0xd0,0x07,0x88,0xfc]
' CHECK-INST: wrfast #3, r0


' CHECK: wrfast #3, #3 ' encoding: [0x03,0x06,0x8c,0xfc]
' CHECK-INST: wrfast #3, #3


' CHECK: _ret_ wrfast r0, r1 ' encoding: [0xd1,0xa1,0x83,0x0c]
' CHECK-INST: _ret_ wrfast r0, r1

