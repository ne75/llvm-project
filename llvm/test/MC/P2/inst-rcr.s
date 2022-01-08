
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rcr r0, r1
	if_nc_and_nz rcr r0, r1
	if_nc_and_z rcr r0, r1
	if_nc rcr r0, r1
	if_c_and_nz rcr r0, r1
	if_nz rcr r0, r1
	if_c_ne_z rcr r0, r1
	if_nc_or_nz rcr r0, r1
	if_c_and_z rcr r0, r1
	if_c_eq_z rcr r0, r1
	if_z rcr r0, r1
	if_nc_or_z rcr r0, r1
	if_c rcr r0, r1
	if_c_or_nz rcr r0, r1
	if_c_or_z rcr r0, r1
	rcr r0, r1
	rcr r0, #1
	_ret_ rcr r0, r1 wc
	_ret_ rcr r0, r1 wz
	_ret_ rcr r0, r1 wcz


' CHECK: _ret_ rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x00]
' CHECK-INST: _ret_ rcr r0, r1


' CHECK: if_nc_and_nz rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x10]
' CHECK-INST: if_nc_and_nz rcr r0, r1


' CHECK: if_nc_and_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x20]
' CHECK-INST: if_nc_and_z rcr r0, r1


' CHECK: if_nc rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x30]
' CHECK-INST: if_nc rcr r0, r1


' CHECK: if_c_and_nz rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x40]
' CHECK-INST: if_c_and_nz rcr r0, r1


' CHECK: if_nz rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x50]
' CHECK-INST: if_nz rcr r0, r1


' CHECK: if_c_ne_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x60]
' CHECK-INST: if_c_ne_z rcr r0, r1


' CHECK: if_nc_or_nz rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x70]
' CHECK-INST: if_nc_or_nz rcr r0, r1


' CHECK: if_c_and_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x80]
' CHECK-INST: if_c_and_z rcr r0, r1


' CHECK: if_c_eq_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x90]
' CHECK-INST: if_c_eq_z rcr r0, r1


' CHECK: if_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xa0]
' CHECK-INST: if_z rcr r0, r1


' CHECK: if_nc_or_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xb0]
' CHECK-INST: if_nc_or_z rcr r0, r1


' CHECK: if_c rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xc0]
' CHECK-INST: if_c rcr r0, r1


' CHECK: if_c_or_nz rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xd0]
' CHECK-INST: if_c_or_nz rcr r0, r1


' CHECK: if_c_or_z rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xe0]
' CHECK-INST: if_c_or_z rcr r0, r1


' CHECK: rcr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xf0]
' CHECK-INST: rcr r0, r1


' CHECK: rcr r0, #1 ' encoding: [0x01,0xa0,0x87,0xf0]
' CHECK-INST: rcr r0, #1


' CHECK: _ret_ rcr r0, r1 wc ' encoding: [0xd1,0xa1,0x93,0x00]
' CHECK-INST: _ret_ rcr r0, r1 wc


' CHECK: _ret_ rcr r0, r1 wz ' encoding: [0xd1,0xa1,0x8b,0x00]
' CHECK-INST: _ret_ rcr r0, r1 wz


' CHECK: _ret_ rcr r0, r1 wcz ' encoding: [0xd1,0xa1,0x9b,0x00]
' CHECK-INST: _ret_ rcr r0, r1 wcz

