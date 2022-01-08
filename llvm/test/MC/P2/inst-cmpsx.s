
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ cmpsx r0, r1
	if_nc_and_nz cmpsx r0, r1
	if_nc_and_z cmpsx r0, r1
	if_nc cmpsx r0, r1
	if_c_and_nz cmpsx r0, r1
	if_nz cmpsx r0, r1
	if_c_ne_z cmpsx r0, r1
	if_nc_or_nz cmpsx r0, r1
	if_c_and_z cmpsx r0, r1
	if_c_eq_z cmpsx r0, r1
	if_z cmpsx r0, r1
	if_nc_or_z cmpsx r0, r1
	if_c cmpsx r0, r1
	if_c_or_nz cmpsx r0, r1
	if_c_or_z cmpsx r0, r1
	cmpsx r0, r1
	cmpsx r0, #1
	_ret_ cmpsx r0, r1 wc
	_ret_ cmpsx r0, r1 wz
	_ret_ cmpsx r0, r1 wcz


' CHECK: _ret_ cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x02]
' CHECK-INST: _ret_ cmpsx r0, r1


' CHECK: if_nc_and_nz cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x12]
' CHECK-INST: if_nc_and_nz cmpsx r0, r1


' CHECK: if_nc_and_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x22]
' CHECK-INST: if_nc_and_z cmpsx r0, r1


' CHECK: if_nc cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x32]
' CHECK-INST: if_nc cmpsx r0, r1


' CHECK: if_c_and_nz cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x42]
' CHECK-INST: if_c_and_nz cmpsx r0, r1


' CHECK: if_nz cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x52]
' CHECK-INST: if_nz cmpsx r0, r1


' CHECK: if_c_ne_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x62]
' CHECK-INST: if_c_ne_z cmpsx r0, r1


' CHECK: if_nc_or_nz cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x72]
' CHECK-INST: if_nc_or_nz cmpsx r0, r1


' CHECK: if_c_and_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x82]
' CHECK-INST: if_c_and_z cmpsx r0, r1


' CHECK: if_c_eq_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x92]
' CHECK-INST: if_c_eq_z cmpsx r0, r1


' CHECK: if_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa2]
' CHECK-INST: if_z cmpsx r0, r1


' CHECK: if_nc_or_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb2]
' CHECK-INST: if_nc_or_z cmpsx r0, r1


' CHECK: if_c cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc2]
' CHECK-INST: if_c cmpsx r0, r1


' CHECK: if_c_or_nz cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd2]
' CHECK-INST: if_c_or_nz cmpsx r0, r1


' CHECK: if_c_or_z cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe2]
' CHECK-INST: if_c_or_z cmpsx r0, r1


' CHECK: cmpsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf2]
' CHECK-INST: cmpsx r0, r1


' CHECK: cmpsx r0, #1 ' encoding: [0x01,0xa0,0x67,0xf2]
' CHECK-INST: cmpsx r0, #1


' CHECK: _ret_ cmpsx r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x02]
' CHECK-INST: _ret_ cmpsx r0, r1 wc


' CHECK: _ret_ cmpsx r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x02]
' CHECK-INST: _ret_ cmpsx r0, r1 wz


' CHECK: _ret_ cmpsx r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x02]
' CHECK-INST: _ret_ cmpsx r0, r1 wcz

