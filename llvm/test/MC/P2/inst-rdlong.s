
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdlong r0, r1
	if_nc_and_nz rdlong r0, r1
	if_nc_and_z rdlong r0, r1
	if_nc rdlong r0, r1
	if_c_and_nz rdlong r0, r1
	if_nz rdlong r0, r1
	if_c_ne_z rdlong r0, r1
	if_nc_or_nz rdlong r0, r1
	if_c_and_z rdlong r0, r1
	if_c_eq_z rdlong r0, r1
	if_z rdlong r0, r1
	if_nc_or_z rdlong r0, r1
	if_c rdlong r0, r1
	if_c_or_nz rdlong r0, r1
	if_c_or_z rdlong r0, r1
	rdlong r0, r1
	rdlong r0, #1
	_ret_ rdlong r0, r1 wc
	_ret_ rdlong r0, r1 wz
	_ret_ rdlong r0, r1 wcz


' CHECK: _ret_ rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0b]
' CHECK-INST: _ret_ rdlong r0, r1


' CHECK: if_nc_and_nz rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x1b]
' CHECK-INST: if_nc_and_nz rdlong r0, r1


' CHECK: if_nc_and_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x2b]
' CHECK-INST: if_nc_and_z rdlong r0, r1


' CHECK: if_nc rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x3b]
' CHECK-INST: if_nc rdlong r0, r1


' CHECK: if_c_and_nz rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x4b]
' CHECK-INST: if_c_and_nz rdlong r0, r1


' CHECK: if_nz rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x5b]
' CHECK-INST: if_nz rdlong r0, r1


' CHECK: if_c_ne_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x6b]
' CHECK-INST: if_c_ne_z rdlong r0, r1


' CHECK: if_nc_or_nz rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x7b]
' CHECK-INST: if_nc_or_nz rdlong r0, r1


' CHECK: if_c_and_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x8b]
' CHECK-INST: if_c_and_z rdlong r0, r1


' CHECK: if_c_eq_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0x9b]
' CHECK-INST: if_c_eq_z rdlong r0, r1


' CHECK: if_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xab]
' CHECK-INST: if_z rdlong r0, r1


' CHECK: if_nc_or_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xbb]
' CHECK-INST: if_nc_or_z rdlong r0, r1


' CHECK: if_c rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xcb]
' CHECK-INST: if_c rdlong r0, r1


' CHECK: if_c_or_nz rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xdb]
' CHECK-INST: if_c_or_nz rdlong r0, r1


' CHECK: if_c_or_z rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xeb]
' CHECK-INST: if_c_or_z rdlong r0, r1


' CHECK: rdlong r0, r1 ' encoding: [0xd1,0xa1,0x03,0xfb]
' CHECK-INST: rdlong r0, r1


' CHECK: rdlong r0, #1 ' encoding: [0x01,0xa0,0x07,0xfb]
' CHECK-INST: rdlong r0, #1


' CHECK: _ret_ rdlong r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x0b]
' CHECK-INST: _ret_ rdlong r0, r1 wc


' CHECK: _ret_ rdlong r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x0b]
' CHECK-INST: _ret_ rdlong r0, r1 wz


' CHECK: _ret_ rdlong r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x0b]
' CHECK-INST: _ret_ rdlong r0, r1 wcz

