
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ cmpr r0, r1
	if_nc_and_nz cmpr r0, r1
	if_nc_and_z cmpr r0, r1
	if_nc cmpr r0, r1
	if_c_and_nz cmpr r0, r1
	if_nz cmpr r0, r1
	if_c_ne_z cmpr r0, r1
	if_nc_or_nz cmpr r0, r1
	if_c_and_z cmpr r0, r1
	if_c_eq_z cmpr r0, r1
	if_z cmpr r0, r1
	if_nc_or_z cmpr r0, r1
	if_c cmpr r0, r1
	if_c_or_nz cmpr r0, r1
	if_c_or_z cmpr r0, r1
	cmpr r0, r1
	cmpr r0, #1
	_ret_ cmpr r0, r1 wc
	_ret_ cmpr r0, r1 wz
	_ret_ cmpr r0, r1 wcz


' CHECK: _ret_ cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x02]
' CHECK-INST: _ret_ cmpr r0, r1


' CHECK: if_nc_and_nz cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x12]
' CHECK-INST: if_nc_and_nz cmpr r0, r1


' CHECK: if_nc_and_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x22]
' CHECK-INST: if_nc_and_z cmpr r0, r1


' CHECK: if_nc cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x32]
' CHECK-INST: if_nc cmpr r0, r1


' CHECK: if_c_and_nz cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x42]
' CHECK-INST: if_c_and_nz cmpr r0, r1


' CHECK: if_nz cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x52]
' CHECK-INST: if_nz cmpr r0, r1


' CHECK: if_c_ne_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x62]
' CHECK-INST: if_c_ne_z cmpr r0, r1


' CHECK: if_nc_or_nz cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x72]
' CHECK-INST: if_nc_or_nz cmpr r0, r1


' CHECK: if_c_and_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x82]
' CHECK-INST: if_c_and_z cmpr r0, r1


' CHECK: if_c_eq_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0x92]
' CHECK-INST: if_c_eq_z cmpr r0, r1


' CHECK: if_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xa2]
' CHECK-INST: if_z cmpr r0, r1


' CHECK: if_nc_or_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xb2]
' CHECK-INST: if_nc_or_z cmpr r0, r1


' CHECK: if_c cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xc2]
' CHECK-INST: if_c cmpr r0, r1


' CHECK: if_c_or_nz cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xd2]
' CHECK-INST: if_c_or_nz cmpr r0, r1


' CHECK: if_c_or_z cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xe2]
' CHECK-INST: if_c_or_z cmpr r0, r1


' CHECK: cmpr r0, r1 ' encoding: [0xd1,0xa1,0x83,0xf2]
' CHECK-INST: cmpr r0, r1


' CHECK: cmpr r0, #1 ' encoding: [0x01,0xa0,0x87,0xf2]
' CHECK-INST: cmpr r0, #1


' CHECK: _ret_ cmpr r0, r1 wc ' encoding: [0xd1,0xa1,0x93,0x02]
' CHECK-INST: _ret_ cmpr r0, r1 wc


' CHECK: _ret_ cmpr r0, r1 wz ' encoding: [0xd1,0xa1,0x8b,0x02]
' CHECK-INST: _ret_ cmpr r0, r1 wz


' CHECK: _ret_ cmpr r0, r1 wcz ' encoding: [0xd1,0xa1,0x9b,0x02]
' CHECK-INST: _ret_ cmpr r0, r1 wcz

