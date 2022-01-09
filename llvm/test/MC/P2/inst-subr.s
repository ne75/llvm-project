
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ subr r0, r1
	if_nc_and_nz subr r0, r1
	if_nc_and_z subr r0, r1
	if_nc subr r0, r1
	if_c_and_nz subr r0, r1
	if_nz subr r0, r1
	if_c_ne_z subr r0, r1
	if_nc_or_nz subr r0, r1
	if_c_and_z subr r0, r1
	if_c_eq_z subr r0, r1
	if_z subr r0, r1
	if_nc_or_z subr r0, r1
	if_c subr r0, r1
	if_c_or_nz subr r0, r1
	if_c_or_z subr r0, r1
	subr r0, r1
	subr r0, #1
	_ret_ subr r0, r1 wc
	_ret_ subr r0, r1 wz
	_ret_ subr r0, r1 wcz


' CHECK: _ret_ subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x02]
' CHECK-INST: _ret_ subr r0, r1


' CHECK: if_nc_and_nz subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x12]
' CHECK-INST: if_nc_and_nz subr r0, r1


' CHECK: if_nc_and_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x22]
' CHECK-INST: if_nc_and_z subr r0, r1


' CHECK: if_nc subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x32]
' CHECK-INST: if_nc subr r0, r1


' CHECK: if_c_and_nz subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x42]
' CHECK-INST: if_c_and_nz subr r0, r1


' CHECK: if_nz subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x52]
' CHECK-INST: if_nz subr r0, r1


' CHECK: if_c_ne_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x62]
' CHECK-INST: if_c_ne_z subr r0, r1


' CHECK: if_nc_or_nz subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x72]
' CHECK-INST: if_nc_or_nz subr r0, r1


' CHECK: if_c_and_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x82]
' CHECK-INST: if_c_and_z subr r0, r1


' CHECK: if_c_eq_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x92]
' CHECK-INST: if_c_eq_z subr r0, r1


' CHECK: if_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xa2]
' CHECK-INST: if_z subr r0, r1


' CHECK: if_nc_or_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xb2]
' CHECK-INST: if_nc_or_z subr r0, r1


' CHECK: if_c subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xc2]
' CHECK-INST: if_c subr r0, r1


' CHECK: if_c_or_nz subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xd2]
' CHECK-INST: if_c_or_nz subr r0, r1


' CHECK: if_c_or_z subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xe2]
' CHECK-INST: if_c_or_z subr r0, r1


' CHECK: subr r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xf2]
' CHECK-INST: subr r0, r1


' CHECK: subr r0, #1 ' encoding: [0x01,0xa0,0xc7,0xf2]
' CHECK-INST: subr r0, #1


' CHECK: _ret_ subr r0, r1 wc ' encoding: [0xd1,0xa1,0xd3,0x02]
' CHECK-INST: _ret_ subr r0, r1 wc


' CHECK: _ret_ subr r0, r1 wz ' encoding: [0xd1,0xa1,0xcb,0x02]
' CHECK-INST: _ret_ subr r0, r1 wz


' CHECK: _ret_ subr r0, r1 wcz ' encoding: [0xd1,0xa1,0xdb,0x02]
' CHECK-INST: _ret_ subr r0, r1 wcz

