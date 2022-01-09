
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ mul r0, r1
	if_nc_and_nz mul r0, r1
	if_nc_and_z mul r0, r1
	if_nc mul r0, r1
	if_c_and_nz mul r0, r1
	if_nz mul r0, r1
	if_c_ne_z mul r0, r1
	if_nc_or_nz mul r0, r1
	if_c_and_z mul r0, r1
	if_c_eq_z mul r0, r1
	if_z mul r0, r1
	if_nc_or_z mul r0, r1
	if_c mul r0, r1
	if_c_or_nz mul r0, r1
	if_c_or_z mul r0, r1
	mul r0, r1
	mul r0, #3
	_ret_ mul r0, r1 wz


' CHECK: _ret_ mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0a]
' CHECK-INST: _ret_ mul r0, r1


' CHECK: if_nc_and_nz mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x1a]
' CHECK-INST: if_nc_and_nz mul r0, r1


' CHECK: if_nc_and_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x2a]
' CHECK-INST: if_nc_and_z mul r0, r1


' CHECK: if_nc mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x3a]
' CHECK-INST: if_nc mul r0, r1


' CHECK: if_c_and_nz mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x4a]
' CHECK-INST: if_c_and_nz mul r0, r1


' CHECK: if_nz mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x5a]
' CHECK-INST: if_nz mul r0, r1


' CHECK: if_c_ne_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x6a]
' CHECK-INST: if_c_ne_z mul r0, r1


' CHECK: if_nc_or_nz mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x7a]
' CHECK-INST: if_nc_or_nz mul r0, r1


' CHECK: if_c_and_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x8a]
' CHECK-INST: if_c_and_z mul r0, r1


' CHECK: if_c_eq_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x9a]
' CHECK-INST: if_c_eq_z mul r0, r1


' CHECK: if_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xaa]
' CHECK-INST: if_z mul r0, r1


' CHECK: if_nc_or_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xba]
' CHECK-INST: if_nc_or_z mul r0, r1


' CHECK: if_c mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xca]
' CHECK-INST: if_c mul r0, r1


' CHECK: if_c_or_nz mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xda]
' CHECK-INST: if_c_or_nz mul r0, r1


' CHECK: if_c_or_z mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xea]
' CHECK-INST: if_c_or_z mul r0, r1


' CHECK: mul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xfa]
' CHECK-INST: mul r0, r1


' CHECK: mul r0, #3 ' encoding: [0x03,0xa0,0x07,0xfa]
' CHECK-INST: mul r0, #3


' CHECK: _ret_ mul r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x0a]
' CHECK-INST: _ret_ mul r0, r1 wz

