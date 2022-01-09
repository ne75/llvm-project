
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdpin r0, r1
	if_nc_and_nz rdpin r0, r1
	if_nc_and_z rdpin r0, r1
	if_nc rdpin r0, r1
	if_c_and_nz rdpin r0, r1
	if_nz rdpin r0, r1
	if_c_ne_z rdpin r0, r1
	if_nc_or_nz rdpin r0, r1
	if_c_and_z rdpin r0, r1
	if_c_eq_z rdpin r0, r1
	if_z rdpin r0, r1
	if_nc_or_z rdpin r0, r1
	if_c rdpin r0, r1
	if_c_or_nz rdpin r0, r1
	if_c_or_z rdpin r0, r1
	rdpin r0, r1
	rdpin r0, #3
	_ret_ rdpin r0, r1 wc


' CHECK: _ret_ rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x0a]
' CHECK-INST: _ret_ rdpin r0, r1


' CHECK: if_nc_and_nz rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x1a]
' CHECK-INST: if_nc_and_nz rdpin r0, r1


' CHECK: if_nc_and_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x2a]
' CHECK-INST: if_nc_and_z rdpin r0, r1


' CHECK: if_nc rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x3a]
' CHECK-INST: if_nc rdpin r0, r1


' CHECK: if_c_and_nz rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x4a]
' CHECK-INST: if_c_and_nz rdpin r0, r1


' CHECK: if_nz rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x5a]
' CHECK-INST: if_nz rdpin r0, r1


' CHECK: if_c_ne_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x6a]
' CHECK-INST: if_c_ne_z rdpin r0, r1


' CHECK: if_nc_or_nz rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x7a]
' CHECK-INST: if_nc_or_nz rdpin r0, r1


' CHECK: if_c_and_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x8a]
' CHECK-INST: if_c_and_z rdpin r0, r1


' CHECK: if_c_eq_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0x9a]
' CHECK-INST: if_c_eq_z rdpin r0, r1


' CHECK: if_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xaa]
' CHECK-INST: if_z rdpin r0, r1


' CHECK: if_nc_or_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xba]
' CHECK-INST: if_nc_or_z rdpin r0, r1


' CHECK: if_c rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xca]
' CHECK-INST: if_c rdpin r0, r1


' CHECK: if_c_or_nz rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xda]
' CHECK-INST: if_c_or_nz rdpin r0, r1


' CHECK: if_c_or_z rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xea]
' CHECK-INST: if_c_or_z rdpin r0, r1


' CHECK: rdpin r0, r1 ' encoding: [0xd1,0xa1,0x8b,0xfa]
' CHECK-INST: rdpin r0, r1


' CHECK: rdpin r0, #3 ' encoding: [0x03,0xa0,0x8f,0xfa]
' CHECK-INST: rdpin r0, #3


' CHECK: _ret_ rdpin r0, r1 wc ' encoding: [0xd1,0xa1,0x9b,0x0a]
' CHECK-INST: _ret_ rdpin r0, r1 wc

