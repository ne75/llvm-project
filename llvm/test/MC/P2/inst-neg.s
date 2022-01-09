
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ neg r0, r1
	if_nc_and_nz neg r0, r1
	if_nc_and_z neg r0, r1
	if_nc neg r0, r1
	if_c_and_nz neg r0, r1
	if_nz neg r0, r1
	if_c_ne_z neg r0, r1
	if_nc_or_nz neg r0, r1
	if_c_and_z neg r0, r1
	if_c_eq_z neg r0, r1
	if_z neg r0, r1
	if_nc_or_z neg r0, r1
	if_c neg r0, r1
	if_c_or_nz neg r0, r1
	if_c_or_z neg r0, r1
	neg r0, r1
	neg r0, #1
	_ret_ neg r0, r1 wc
	_ret_ neg r0, r1 wz
	_ret_ neg r0, r1 wcz


' CHECK: _ret_ neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x06]
' CHECK-INST: _ret_ neg r0, r1


' CHECK: if_nc_and_nz neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x16]
' CHECK-INST: if_nc_and_nz neg r0, r1


' CHECK: if_nc_and_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x26]
' CHECK-INST: if_nc_and_z neg r0, r1


' CHECK: if_nc neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x36]
' CHECK-INST: if_nc neg r0, r1


' CHECK: if_c_and_nz neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x46]
' CHECK-INST: if_c_and_nz neg r0, r1


' CHECK: if_nz neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x56]
' CHECK-INST: if_nz neg r0, r1


' CHECK: if_c_ne_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x66]
' CHECK-INST: if_c_ne_z neg r0, r1


' CHECK: if_nc_or_nz neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x76]
' CHECK-INST: if_nc_or_nz neg r0, r1


' CHECK: if_c_and_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x86]
' CHECK-INST: if_c_and_z neg r0, r1


' CHECK: if_c_eq_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0x96]
' CHECK-INST: if_c_eq_z neg r0, r1


' CHECK: if_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa6]
' CHECK-INST: if_z neg r0, r1


' CHECK: if_nc_or_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb6]
' CHECK-INST: if_nc_or_z neg r0, r1


' CHECK: if_c neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc6]
' CHECK-INST: if_c neg r0, r1


' CHECK: if_c_or_nz neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd6]
' CHECK-INST: if_c_or_nz neg r0, r1


' CHECK: if_c_or_z neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe6]
' CHECK-INST: if_c_or_z neg r0, r1


' CHECK: neg r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf6]
' CHECK-INST: neg r0, r1


' CHECK: neg r0, #1 ' encoding: [0x01,0xa0,0x67,0xf6]
' CHECK-INST: neg r0, #1


' CHECK: _ret_ neg r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x06]
' CHECK-INST: _ret_ neg r0, r1 wc


' CHECK: _ret_ neg r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x06]
' CHECK-INST: _ret_ neg r0, r1 wz


' CHECK: _ret_ neg r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x06]
' CHECK-INST: _ret_ neg r0, r1 wcz

