
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ qdiv r0, r1
	if_nc_and_nz qdiv r0, r1
	if_nc_and_z qdiv r0, r1
	if_nc qdiv r0, r1
	if_c_and_nz qdiv r0, r1
	if_nz qdiv r0, r1
	if_c_ne_z qdiv r0, r1
	if_nc_or_nz qdiv r0, r1
	if_c_and_z qdiv r0, r1
	if_c_eq_z qdiv r0, r1
	if_z qdiv r0, r1
	if_nc_or_z qdiv r0, r1
	if_c qdiv r0, r1
	if_c_or_nz qdiv r0, r1
	if_c_or_z qdiv r0, r1
	qdiv r0, r1
	qdiv r0, #3
	qdiv #3, r0
	qdiv #3, #3
	_ret_ qdiv r0, r1


' CHECK: _ret_ qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x0d]
' CHECK-INST: _ret_ qdiv r0, r1


' CHECK: if_nc_and_nz qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x1d]
' CHECK-INST: if_nc_and_nz qdiv r0, r1


' CHECK: if_nc_and_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x2d]
' CHECK-INST: if_nc_and_z qdiv r0, r1


' CHECK: if_nc qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x3d]
' CHECK-INST: if_nc qdiv r0, r1


' CHECK: if_c_and_nz qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x4d]
' CHECK-INST: if_c_and_nz qdiv r0, r1


' CHECK: if_nz qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x5d]
' CHECK-INST: if_nz qdiv r0, r1


' CHECK: if_c_ne_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x6d]
' CHECK-INST: if_c_ne_z qdiv r0, r1


' CHECK: if_nc_or_nz qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x7d]
' CHECK-INST: if_nc_or_nz qdiv r0, r1


' CHECK: if_c_and_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x8d]
' CHECK-INST: if_c_and_z qdiv r0, r1


' CHECK: if_c_eq_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x9d]
' CHECK-INST: if_c_eq_z qdiv r0, r1


' CHECK: if_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xad]
' CHECK-INST: if_z qdiv r0, r1


' CHECK: if_nc_or_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xbd]
' CHECK-INST: if_nc_or_z qdiv r0, r1


' CHECK: if_c qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xcd]
' CHECK-INST: if_c qdiv r0, r1


' CHECK: if_c_or_nz qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xdd]
' CHECK-INST: if_c_or_nz qdiv r0, r1


' CHECK: if_c_or_z qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xed]
' CHECK-INST: if_c_or_z qdiv r0, r1


' CHECK: qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0xfd]
' CHECK-INST: qdiv r0, r1


' CHECK: qdiv r0, #3 ' encoding: [0x03,0xa0,0x17,0xfd]
' CHECK-INST: qdiv r0, #3


' CHECK: qdiv #3, r0 ' encoding: [0xd0,0x07,0x18,0xfd]
' CHECK-INST: qdiv #3, r0


' CHECK: qdiv #3, #3 ' encoding: [0x03,0x06,0x1c,0xfd]
' CHECK-INST: qdiv #3, #3


' CHECK: _ret_ qdiv r0, r1 ' encoding: [0xd1,0xa1,0x13,0x0d]
' CHECK-INST: _ret_ qdiv r0, r1

