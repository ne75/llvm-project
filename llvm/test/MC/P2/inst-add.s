
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ add r0, r1
	if_nc_and_nz add r0, r1
	if_nc_and_z add r0, r1
	if_nc add r0, r1
	if_c_and_nz add r0, r1
	if_nz add r0, r1
	if_c_ne_z add r0, r1
	if_nc_or_nz add r0, r1
	if_c_and_z add r0, r1
	if_c_eq_z add r0, r1
	if_z add r0, r1
	if_nc_or_z add r0, r1
	if_c add r0, r1
	if_c_or_nz add r0, r1
	if_c_or_z add r0, r1
	add r0, r1
	add r0, #1
	_ret_ add r0, r1 wc
	_ret_ add r0, r1 wz
	_ret_ add r0, r1 wcz


' CHECK: _ret_ add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x01]
' CHECK-INST: _ret_ add r0, r1


' CHECK: if_nc_and_nz add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x11]
' CHECK-INST: if_nc_and_nz add r0, r1


' CHECK: if_nc_and_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x21]
' CHECK-INST: if_nc_and_z add r0, r1


' CHECK: if_nc add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x31]
' CHECK-INST: if_nc add r0, r1


' CHECK: if_c_and_nz add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x41]
' CHECK-INST: if_c_and_nz add r0, r1


' CHECK: if_nz add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x51]
' CHECK-INST: if_nz add r0, r1


' CHECK: if_c_ne_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x61]
' CHECK-INST: if_c_ne_z add r0, r1


' CHECK: if_nc_or_nz add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x71]
' CHECK-INST: if_nc_or_nz add r0, r1


' CHECK: if_c_and_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x81]
' CHECK-INST: if_c_and_z add r0, r1


' CHECK: if_c_eq_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0x91]
' CHECK-INST: if_c_eq_z add r0, r1


' CHECK: if_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xa1]
' CHECK-INST: if_z add r0, r1


' CHECK: if_nc_or_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xb1]
' CHECK-INST: if_nc_or_z add r0, r1


' CHECK: if_c add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xc1]
' CHECK-INST: if_c add r0, r1


' CHECK: if_c_or_nz add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xd1]
' CHECK-INST: if_c_or_nz add r0, r1


' CHECK: if_c_or_z add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xe1]
' CHECK-INST: if_c_or_z add r0, r1


' CHECK: add r0, r1 ' encoding: [0xd1,0xa1,0x03,0xf1]
' CHECK-INST: add r0, r1


' CHECK: add r0, #1 ' encoding: [0x01,0xa0,0x07,0xf1]
' CHECK-INST: add r0, #1


' CHECK: _ret_ add r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x01]
' CHECK-INST: _ret_ add r0, r1 wc


' CHECK: _ret_ add r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x01]
' CHECK-INST: _ret_ add r0, r1 wz


' CHECK: _ret_ add r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x01]
' CHECK-INST: _ret_ add r0, r1 wcz

