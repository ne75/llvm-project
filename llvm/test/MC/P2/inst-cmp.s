
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ cmp r0, r1
	if_nc_and_nz cmp r0, r1
	if_nc_and_z cmp r0, r1
	if_nc cmp r0, r1
	if_c_and_nz cmp r0, r1
	if_nz cmp r0, r1
	if_c_ne_z cmp r0, r1
	if_nc_or_nz cmp r0, r1
	if_c_and_z cmp r0, r1
	if_c_eq_z cmp r0, r1
	if_z cmp r0, r1
	if_nc_or_z cmp r0, r1
	if_c cmp r0, r1
	if_c_or_nz cmp r0, r1
	if_c_or_z cmp r0, r1
	cmp r0, r1
	cmp r0, #1
	_ret_ cmp r0, r1 wc
	_ret_ cmp r0, r1 wz
	_ret_ cmp r0, r1 wcz


' CHECK: _ret_ cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x02]
' CHECK-INST: _ret_ cmp r0, r1


' CHECK: if_nc_and_nz cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x12]
' CHECK-INST: if_nc_and_nz cmp r0, r1


' CHECK: if_nc_and_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x22]
' CHECK-INST: if_nc_and_z cmp r0, r1


' CHECK: if_nc cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x32]
' CHECK-INST: if_nc cmp r0, r1


' CHECK: if_c_and_nz cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x42]
' CHECK-INST: if_c_and_nz cmp r0, r1


' CHECK: if_nz cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x52]
' CHECK-INST: if_nz cmp r0, r1


' CHECK: if_c_ne_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x62]
' CHECK-INST: if_c_ne_z cmp r0, r1


' CHECK: if_nc_or_nz cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x72]
' CHECK-INST: if_nc_or_nz cmp r0, r1


' CHECK: if_c_and_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x82]
' CHECK-INST: if_c_and_z cmp r0, r1


' CHECK: if_c_eq_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0x92]
' CHECK-INST: if_c_eq_z cmp r0, r1


' CHECK: if_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xa2]
' CHECK-INST: if_z cmp r0, r1


' CHECK: if_nc_or_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xb2]
' CHECK-INST: if_nc_or_z cmp r0, r1


' CHECK: if_c cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xc2]
' CHECK-INST: if_c cmp r0, r1


' CHECK: if_c_or_nz cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xd2]
' CHECK-INST: if_c_or_nz cmp r0, r1


' CHECK: if_c_or_z cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xe2]
' CHECK-INST: if_c_or_z cmp r0, r1


' CHECK: cmp r0, r1 ' encoding: [0xd1,0xa1,0x03,0xf2]
' CHECK-INST: cmp r0, r1


' CHECK: cmp r0, #1 ' encoding: [0x01,0xa0,0x07,0xf2]
' CHECK-INST: cmp r0, #1


' CHECK: _ret_ cmp r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x02]
' CHECK-INST: _ret_ cmp r0, r1 wc


' CHECK: _ret_ cmp r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x02]
' CHECK-INST: _ret_ cmp r0, r1 wz


' CHECK: _ret_ cmp r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x02]
' CHECK-INST: _ret_ cmp r0, r1 wcz

