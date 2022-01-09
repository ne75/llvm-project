
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ cmpx r0, r1
	if_nc_and_nz cmpx r0, r1
	if_nc_and_z cmpx r0, r1
	if_nc cmpx r0, r1
	if_c_and_nz cmpx r0, r1
	if_nz cmpx r0, r1
	if_c_ne_z cmpx r0, r1
	if_nc_or_nz cmpx r0, r1
	if_c_and_z cmpx r0, r1
	if_c_eq_z cmpx r0, r1
	if_z cmpx r0, r1
	if_nc_or_z cmpx r0, r1
	if_c cmpx r0, r1
	if_c_or_nz cmpx r0, r1
	if_c_or_z cmpx r0, r1
	cmpx r0, r1
	cmpx r0, #1
	_ret_ cmpx r0, r1 wc
	_ret_ cmpx r0, r1 wz
	_ret_ cmpx r0, r1 wcz


' CHECK: _ret_ cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x02]
' CHECK-INST: _ret_ cmpx r0, r1


' CHECK: if_nc_and_nz cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x12]
' CHECK-INST: if_nc_and_nz cmpx r0, r1


' CHECK: if_nc_and_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x22]
' CHECK-INST: if_nc_and_z cmpx r0, r1


' CHECK: if_nc cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x32]
' CHECK-INST: if_nc cmpx r0, r1


' CHECK: if_c_and_nz cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x42]
' CHECK-INST: if_c_and_nz cmpx r0, r1


' CHECK: if_nz cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x52]
' CHECK-INST: if_nz cmpx r0, r1


' CHECK: if_c_ne_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x62]
' CHECK-INST: if_c_ne_z cmpx r0, r1


' CHECK: if_nc_or_nz cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x72]
' CHECK-INST: if_nc_or_nz cmpx r0, r1


' CHECK: if_c_and_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x82]
' CHECK-INST: if_c_and_z cmpx r0, r1


' CHECK: if_c_eq_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0x92]
' CHECK-INST: if_c_eq_z cmpx r0, r1


' CHECK: if_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xa2]
' CHECK-INST: if_z cmpx r0, r1


' CHECK: if_nc_or_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xb2]
' CHECK-INST: if_nc_or_z cmpx r0, r1


' CHECK: if_c cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xc2]
' CHECK-INST: if_c cmpx r0, r1


' CHECK: if_c_or_nz cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xd2]
' CHECK-INST: if_c_or_nz cmpx r0, r1


' CHECK: if_c_or_z cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xe2]
' CHECK-INST: if_c_or_z cmpx r0, r1


' CHECK: cmpx r0, r1 ' encoding: [0xd1,0xa1,0x23,0xf2]
' CHECK-INST: cmpx r0, r1


' CHECK: cmpx r0, #1 ' encoding: [0x01,0xa0,0x27,0xf2]
' CHECK-INST: cmpx r0, #1


' CHECK: _ret_ cmpx r0, r1 wc ' encoding: [0xd1,0xa1,0x33,0x02]
' CHECK-INST: _ret_ cmpx r0, r1 wc


' CHECK: _ret_ cmpx r0, r1 wz ' encoding: [0xd1,0xa1,0x2b,0x02]
' CHECK-INST: _ret_ cmpx r0, r1 wz


' CHECK: _ret_ cmpx r0, r1 wcz ' encoding: [0xd1,0xa1,0x3b,0x02]
' CHECK-INST: _ret_ cmpx r0, r1 wcz

