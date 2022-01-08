
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdfast r0, r1
	if_nc_and_nz rdfast r0, r1
	if_nc_and_z rdfast r0, r1
	if_nc rdfast r0, r1
	if_c_and_nz rdfast r0, r1
	if_nz rdfast r0, r1
	if_c_ne_z rdfast r0, r1
	if_nc_or_nz rdfast r0, r1
	if_c_and_z rdfast r0, r1
	if_c_eq_z rdfast r0, r1
	if_z rdfast r0, r1
	if_nc_or_z rdfast r0, r1
	if_c rdfast r0, r1
	if_c_or_nz rdfast r0, r1
	if_c_or_z rdfast r0, r1
	rdfast r0, r1
	rdfast r0, #3
	rdfast #3, r0
	rdfast #3, #3
	_ret_ rdfast r0, r1


' CHECK: _ret_ rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x0c]
' CHECK-INST: _ret_ rdfast r0, r1


' CHECK: if_nc_and_nz rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x1c]
' CHECK-INST: if_nc_and_nz rdfast r0, r1


' CHECK: if_nc_and_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x2c]
' CHECK-INST: if_nc_and_z rdfast r0, r1


' CHECK: if_nc rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x3c]
' CHECK-INST: if_nc rdfast r0, r1


' CHECK: if_c_and_nz rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x4c]
' CHECK-INST: if_c_and_nz rdfast r0, r1


' CHECK: if_nz rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x5c]
' CHECK-INST: if_nz rdfast r0, r1


' CHECK: if_c_ne_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x6c]
' CHECK-INST: if_c_ne_z rdfast r0, r1


' CHECK: if_nc_or_nz rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x7c]
' CHECK-INST: if_nc_or_nz rdfast r0, r1


' CHECK: if_c_and_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x8c]
' CHECK-INST: if_c_and_z rdfast r0, r1


' CHECK: if_c_eq_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x9c]
' CHECK-INST: if_c_eq_z rdfast r0, r1


' CHECK: if_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xac]
' CHECK-INST: if_z rdfast r0, r1


' CHECK: if_nc_or_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xbc]
' CHECK-INST: if_nc_or_z rdfast r0, r1


' CHECK: if_c rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xcc]
' CHECK-INST: if_c rdfast r0, r1


' CHECK: if_c_or_nz rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xdc]
' CHECK-INST: if_c_or_nz rdfast r0, r1


' CHECK: if_c_or_z rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xec]
' CHECK-INST: if_c_or_z rdfast r0, r1


' CHECK: rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0xfc]
' CHECK-INST: rdfast r0, r1


' CHECK: rdfast r0, #3 ' encoding: [0x03,0xa0,0x77,0xfc]
' CHECK-INST: rdfast r0, #3


' CHECK: rdfast #3, r0 ' encoding: [0xd0,0x07,0x78,0xfc]
' CHECK-INST: rdfast #3, r0


' CHECK: rdfast #3, #3 ' encoding: [0x03,0x06,0x7c,0xfc]
' CHECK-INST: rdfast #3, #3


' CHECK: _ret_ rdfast r0, r1 ' encoding: [0xd1,0xa1,0x73,0x0c]
' CHECK-INST: _ret_ rdfast r0, r1

