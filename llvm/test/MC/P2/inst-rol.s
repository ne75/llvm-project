
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rol r0, r1
	if_nc_and_nz rol r0, r1
	if_nc_and_z rol r0, r1
	if_nc rol r0, r1
	if_c_and_nz rol r0, r1
	if_nz rol r0, r1
	if_c_ne_z rol r0, r1
	if_nc_or_nz rol r0, r1
	if_c_and_z rol r0, r1
	if_c_eq_z rol r0, r1
	if_z rol r0, r1
	if_nc_or_z rol r0, r1
	if_c rol r0, r1
	if_c_or_nz rol r0, r1
	if_c_or_z rol r0, r1
	rol r0, r1
	rol r0, #1
	_ret_ rol r0, r1 wc
	_ret_ rol r0, r1 wz
	_ret_ rol r0, r1 wcz


' CHECK: _ret_ rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x00]
' CHECK-INST: _ret_ rol r0, r1


' CHECK: if_nc_and_nz rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x10]
' CHECK-INST: if_nc_and_nz rol r0, r1


' CHECK: if_nc_and_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x20]
' CHECK-INST: if_nc_and_z rol r0, r1


' CHECK: if_nc rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x30]
' CHECK-INST: if_nc rol r0, r1


' CHECK: if_c_and_nz rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x40]
' CHECK-INST: if_c_and_nz rol r0, r1


' CHECK: if_nz rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x50]
' CHECK-INST: if_nz rol r0, r1


' CHECK: if_c_ne_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x60]
' CHECK-INST: if_c_ne_z rol r0, r1


' CHECK: if_nc_or_nz rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x70]
' CHECK-INST: if_nc_or_nz rol r0, r1


' CHECK: if_c_and_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x80]
' CHECK-INST: if_c_and_z rol r0, r1


' CHECK: if_c_eq_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0x90]
' CHECK-INST: if_c_eq_z rol r0, r1


' CHECK: if_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xa0]
' CHECK-INST: if_z rol r0, r1


' CHECK: if_nc_or_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xb0]
' CHECK-INST: if_nc_or_z rol r0, r1


' CHECK: if_c rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xc0]
' CHECK-INST: if_c rol r0, r1


' CHECK: if_c_or_nz rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xd0]
' CHECK-INST: if_c_or_nz rol r0, r1


' CHECK: if_c_or_z rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xe0]
' CHECK-INST: if_c_or_z rol r0, r1


' CHECK: rol r0, r1 ' encoding: [0xd1,0xa1,0x23,0xf0]
' CHECK-INST: rol r0, r1


' CHECK: rol r0, #1 ' encoding: [0x01,0xa0,0x27,0xf0]
' CHECK-INST: rol r0, #1


' CHECK: _ret_ rol r0, r1 wc ' encoding: [0xd1,0xa1,0x33,0x00]
' CHECK-INST: _ret_ rol r0, r1 wc


' CHECK: _ret_ rol r0, r1 wz ' encoding: [0xd1,0xa1,0x2b,0x00]
' CHECK-INST: _ret_ rol r0, r1 wz


' CHECK: _ret_ rol r0, r1 wcz ' encoding: [0xd1,0xa1,0x3b,0x00]
' CHECK-INST: _ret_ rol r0, r1 wcz

