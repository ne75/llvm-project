
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ muls r0, r1
	if_nc_and_nz muls r0, r1
	if_nc_and_z muls r0, r1
	if_nc muls r0, r1
	if_c_and_nz muls r0, r1
	if_nz muls r0, r1
	if_c_ne_z muls r0, r1
	if_nc_or_nz muls r0, r1
	if_c_and_z muls r0, r1
	if_c_eq_z muls r0, r1
	if_z muls r0, r1
	if_nc_or_z muls r0, r1
	if_c muls r0, r1
	if_c_or_nz muls r0, r1
	if_c_or_z muls r0, r1
	muls r0, r1
	muls r0, #3
	_ret_ muls r0, r1 wz


' CHECK: _ret_ muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x0a]
' CHECK-INST: _ret_ muls r0, r1


' CHECK: if_nc_and_nz muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x1a]
' CHECK-INST: if_nc_and_nz muls r0, r1


' CHECK: if_nc_and_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x2a]
' CHECK-INST: if_nc_and_z muls r0, r1


' CHECK: if_nc muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x3a]
' CHECK-INST: if_nc muls r0, r1


' CHECK: if_c_and_nz muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x4a]
' CHECK-INST: if_c_and_nz muls r0, r1


' CHECK: if_nz muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x5a]
' CHECK-INST: if_nz muls r0, r1


' CHECK: if_c_ne_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x6a]
' CHECK-INST: if_c_ne_z muls r0, r1


' CHECK: if_nc_or_nz muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x7a]
' CHECK-INST: if_nc_or_nz muls r0, r1


' CHECK: if_c_and_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x8a]
' CHECK-INST: if_c_and_z muls r0, r1


' CHECK: if_c_eq_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0x9a]
' CHECK-INST: if_c_eq_z muls r0, r1


' CHECK: if_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xaa]
' CHECK-INST: if_z muls r0, r1


' CHECK: if_nc_or_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xba]
' CHECK-INST: if_nc_or_z muls r0, r1


' CHECK: if_c muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xca]
' CHECK-INST: if_c muls r0, r1


' CHECK: if_c_or_nz muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xda]
' CHECK-INST: if_c_or_nz muls r0, r1


' CHECK: if_c_or_z muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xea]
' CHECK-INST: if_c_or_z muls r0, r1


' CHECK: muls r0, r1 ' encoding: [0xd1,0xa1,0x13,0xfa]
' CHECK-INST: muls r0, r1


' CHECK: muls r0, #3 ' encoding: [0x03,0xa0,0x17,0xfa]
' CHECK-INST: muls r0, #3


' CHECK: _ret_ muls r0, r1 wz ' encoding: [0xd1,0xa1,0x1b,0x0a]
' CHECK-INST: _ret_ muls r0, r1 wz

