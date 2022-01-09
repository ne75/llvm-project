
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ shl r0, r1
	if_nc_and_nz shl r0, r1
	if_nc_and_z shl r0, r1
	if_nc shl r0, r1
	if_c_and_nz shl r0, r1
	if_nz shl r0, r1
	if_c_ne_z shl r0, r1
	if_nc_or_nz shl r0, r1
	if_c_and_z shl r0, r1
	if_c_eq_z shl r0, r1
	if_z shl r0, r1
	if_nc_or_z shl r0, r1
	if_c shl r0, r1
	if_c_or_nz shl r0, r1
	if_c_or_z shl r0, r1
	shl r0, r1
	shl r0, #1
	_ret_ shl r0, r1 wc
	_ret_ shl r0, r1 wz
	_ret_ shl r0, r1 wcz


' CHECK: _ret_ shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x00]
' CHECK-INST: _ret_ shl r0, r1


' CHECK: if_nc_and_nz shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x10]
' CHECK-INST: if_nc_and_nz shl r0, r1


' CHECK: if_nc_and_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x20]
' CHECK-INST: if_nc_and_z shl r0, r1


' CHECK: if_nc shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x30]
' CHECK-INST: if_nc shl r0, r1


' CHECK: if_c_and_nz shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x40]
' CHECK-INST: if_c_and_nz shl r0, r1


' CHECK: if_nz shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x50]
' CHECK-INST: if_nz shl r0, r1


' CHECK: if_c_ne_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x60]
' CHECK-INST: if_c_ne_z shl r0, r1


' CHECK: if_nc_or_nz shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x70]
' CHECK-INST: if_nc_or_nz shl r0, r1


' CHECK: if_c_and_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x80]
' CHECK-INST: if_c_and_z shl r0, r1


' CHECK: if_c_eq_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0x90]
' CHECK-INST: if_c_eq_z shl r0, r1


' CHECK: if_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa0]
' CHECK-INST: if_z shl r0, r1


' CHECK: if_nc_or_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb0]
' CHECK-INST: if_nc_or_z shl r0, r1


' CHECK: if_c shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc0]
' CHECK-INST: if_c shl r0, r1


' CHECK: if_c_or_nz shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd0]
' CHECK-INST: if_c_or_nz shl r0, r1


' CHECK: if_c_or_z shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe0]
' CHECK-INST: if_c_or_z shl r0, r1


' CHECK: shl r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf0]
' CHECK-INST: shl r0, r1


' CHECK: shl r0, #1 ' encoding: [0x01,0xa0,0x67,0xf0]
' CHECK-INST: shl r0, #1


' CHECK: _ret_ shl r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x00]
' CHECK-INST: _ret_ shl r0, r1 wc


' CHECK: _ret_ shl r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x00]
' CHECK-INST: _ret_ shl r0, r1 wz


' CHECK: _ret_ shl r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x00]
' CHECK-INST: _ret_ shl r0, r1 wcz

