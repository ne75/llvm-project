
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ sal r0, r1
	if_nc_and_nz sal r0, r1
	if_nc_and_z sal r0, r1
	if_nc sal r0, r1
	if_c_and_nz sal r0, r1
	if_nz sal r0, r1
	if_c_ne_z sal r0, r1
	if_nc_or_nz sal r0, r1
	if_c_and_z sal r0, r1
	if_c_eq_z sal r0, r1
	if_z sal r0, r1
	if_nc_or_z sal r0, r1
	if_c sal r0, r1
	if_c_or_nz sal r0, r1
	if_c_or_z sal r0, r1
	sal r0, r1
	sal r0, #1
	_ret_ sal r0, r1 wc
	_ret_ sal r0, r1 wz
	_ret_ sal r0, r1 wcz


' CHECK: _ret_ sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x00]
' CHECK-INST: _ret_ sal r0, r1


' CHECK: if_nc_and_nz sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x10]
' CHECK-INST: if_nc_and_nz sal r0, r1


' CHECK: if_nc_and_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x20]
' CHECK-INST: if_nc_and_z sal r0, r1


' CHECK: if_nc sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x30]
' CHECK-INST: if_nc sal r0, r1


' CHECK: if_c_and_nz sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x40]
' CHECK-INST: if_c_and_nz sal r0, r1


' CHECK: if_nz sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x50]
' CHECK-INST: if_nz sal r0, r1


' CHECK: if_c_ne_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x60]
' CHECK-INST: if_c_ne_z sal r0, r1


' CHECK: if_nc_or_nz sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x70]
' CHECK-INST: if_nc_or_nz sal r0, r1


' CHECK: if_c_and_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x80]
' CHECK-INST: if_c_and_z sal r0, r1


' CHECK: if_c_eq_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0x90]
' CHECK-INST: if_c_eq_z sal r0, r1


' CHECK: if_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xa0]
' CHECK-INST: if_z sal r0, r1


' CHECK: if_nc_or_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xb0]
' CHECK-INST: if_nc_or_z sal r0, r1


' CHECK: if_c sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xc0]
' CHECK-INST: if_c sal r0, r1


' CHECK: if_c_or_nz sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xd0]
' CHECK-INST: if_c_or_nz sal r0, r1


' CHECK: if_c_or_z sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xe0]
' CHECK-INST: if_c_or_z sal r0, r1


' CHECK: sal r0, r1 ' encoding: [0xd1,0xa1,0xe3,0xf0]
' CHECK-INST: sal r0, r1


' CHECK: sal r0, #1 ' encoding: [0x01,0xa0,0xe7,0xf0]
' CHECK-INST: sal r0, #1


' CHECK: _ret_ sal r0, r1 wc ' encoding: [0xd1,0xa1,0xf3,0x00]
' CHECK-INST: _ret_ sal r0, r1 wc


' CHECK: _ret_ sal r0, r1 wz ' encoding: [0xd1,0xa1,0xeb,0x00]
' CHECK-INST: _ret_ sal r0, r1 wz


' CHECK: _ret_ sal r0, r1 wcz ' encoding: [0xd1,0xa1,0xfb,0x00]
' CHECK-INST: _ret_ sal r0, r1 wcz

