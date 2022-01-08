
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ ror r0, r1
	if_nc_and_nz ror r0, r1
	if_nc_and_z ror r0, r1
	if_nc ror r0, r1
	if_c_and_nz ror r0, r1
	if_nz ror r0, r1
	if_c_ne_z ror r0, r1
	if_nc_or_nz ror r0, r1
	if_c_and_z ror r0, r1
	if_c_eq_z ror r0, r1
	if_z ror r0, r1
	if_nc_or_z ror r0, r1
	if_c ror r0, r1
	if_c_or_nz ror r0, r1
	if_c_or_z ror r0, r1
	ror r0, r1
	ror r0, #1
	_ret_ ror r0, r1 wc
	_ret_ ror r0, r1 wz
	_ret_ ror r0, r1 wcz


' CHECK: _ret_ ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x00]
' CHECK-INST: _ret_ ror r0, r1


' CHECK: if_nc_and_nz ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x10]
' CHECK-INST: if_nc_and_nz ror r0, r1


' CHECK: if_nc_and_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x20]
' CHECK-INST: if_nc_and_z ror r0, r1


' CHECK: if_nc ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x30]
' CHECK-INST: if_nc ror r0, r1


' CHECK: if_c_and_nz ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x40]
' CHECK-INST: if_c_and_nz ror r0, r1


' CHECK: if_nz ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x50]
' CHECK-INST: if_nz ror r0, r1


' CHECK: if_c_ne_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x60]
' CHECK-INST: if_c_ne_z ror r0, r1


' CHECK: if_nc_or_nz ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x70]
' CHECK-INST: if_nc_or_nz ror r0, r1


' CHECK: if_c_and_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x80]
' CHECK-INST: if_c_and_z ror r0, r1


' CHECK: if_c_eq_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0x90]
' CHECK-INST: if_c_eq_z ror r0, r1


' CHECK: if_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xa0]
' CHECK-INST: if_z ror r0, r1


' CHECK: if_nc_or_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xb0]
' CHECK-INST: if_nc_or_z ror r0, r1


' CHECK: if_c ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xc0]
' CHECK-INST: if_c ror r0, r1


' CHECK: if_c_or_nz ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xd0]
' CHECK-INST: if_c_or_nz ror r0, r1


' CHECK: if_c_or_z ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xe0]
' CHECK-INST: if_c_or_z ror r0, r1


' CHECK: ror r0, r1 ' encoding: [0xd1,0xa1,0x03,0xf0]
' CHECK-INST: ror r0, r1


' CHECK: ror r0, #1 ' encoding: [0x01,0xa0,0x07,0xf0]
' CHECK-INST: ror r0, #1


' CHECK: _ret_ ror r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x00]
' CHECK-INST: _ret_ ror r0, r1 wc


' CHECK: _ret_ ror r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x00]
' CHECK-INST: _ret_ ror r0, r1 wz


' CHECK: _ret_ ror r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x00]
' CHECK-INST: _ret_ ror r0, r1 wcz

