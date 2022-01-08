
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ addct3 r0, r1
	if_nc_and_nz addct3 r0, r1
	if_nc_and_z addct3 r0, r1
	if_nc addct3 r0, r1
	if_c_and_nz addct3 r0, r1
	if_nz addct3 r0, r1
	if_c_ne_z addct3 r0, r1
	if_nc_or_nz addct3 r0, r1
	if_c_and_z addct3 r0, r1
	if_c_eq_z addct3 r0, r1
	if_z addct3 r0, r1
	if_nc_or_z addct3 r0, r1
	if_c addct3 r0, r1
	if_c_or_nz addct3 r0, r1
	if_c_or_z addct3 r0, r1
	addct3 r0, r1
	addct3 r0, #3
	_ret_ addct3 r0, r1


' CHECK: _ret_ addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x0a]
' CHECK-INST: _ret_ addct3 r0, r1


' CHECK: if_nc_and_nz addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x1a]
' CHECK-INST: if_nc_and_nz addct3 r0, r1


' CHECK: if_nc_and_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x2a]
' CHECK-INST: if_nc_and_z addct3 r0, r1


' CHECK: if_nc addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x3a]
' CHECK-INST: if_nc addct3 r0, r1


' CHECK: if_c_and_nz addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x4a]
' CHECK-INST: if_c_and_nz addct3 r0, r1


' CHECK: if_nz addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x5a]
' CHECK-INST: if_nz addct3 r0, r1


' CHECK: if_c_ne_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x6a]
' CHECK-INST: if_c_ne_z addct3 r0, r1


' CHECK: if_nc_or_nz addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x7a]
' CHECK-INST: if_nc_or_nz addct3 r0, r1


' CHECK: if_c_and_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x8a]
' CHECK-INST: if_c_and_z addct3 r0, r1


' CHECK: if_c_eq_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x9a]
' CHECK-INST: if_c_eq_z addct3 r0, r1


' CHECK: if_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xaa]
' CHECK-INST: if_z addct3 r0, r1


' CHECK: if_nc_or_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xba]
' CHECK-INST: if_nc_or_z addct3 r0, r1


' CHECK: if_c addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xca]
' CHECK-INST: if_c addct3 r0, r1


' CHECK: if_c_or_nz addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xda]
' CHECK-INST: if_c_or_nz addct3 r0, r1


' CHECK: if_c_or_z addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xea]
' CHECK-INST: if_c_or_z addct3 r0, r1


' CHECK: addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0xfa]
' CHECK-INST: addct3 r0, r1


' CHECK: addct3 r0, #3 ' encoding: [0x03,0xa0,0x77,0xfa]
' CHECK-INST: addct3 r0, #3


' CHECK: _ret_ addct3 r0, r1 ' encoding: [0xd1,0xa1,0x73,0x0a]
' CHECK-INST: _ret_ addct3 r0, r1

