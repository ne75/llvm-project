
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ adds r0, r1
	if_nc_and_nz adds r0, r1
	if_nc_and_z adds r0, r1
	if_nc adds r0, r1
	if_c_and_nz adds r0, r1
	if_nz adds r0, r1
	if_c_ne_z adds r0, r1
	if_nc_or_nz adds r0, r1
	if_c_and_z adds r0, r1
	if_c_eq_z adds r0, r1
	if_z adds r0, r1
	if_nc_or_z adds r0, r1
	if_c adds r0, r1
	if_c_or_nz adds r0, r1
	if_c_or_z adds r0, r1
	adds r0, r1
	adds r0, #1
	_ret_ adds r0, r1 wc
	_ret_ adds r0, r1 wz
	_ret_ adds r0, r1 wcz


' CHECK: _ret_ adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x01]
' CHECK-INST: _ret_ adds r0, r1


' CHECK: if_nc_and_nz adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x11]
' CHECK-INST: if_nc_and_nz adds r0, r1


' CHECK: if_nc_and_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x21]
' CHECK-INST: if_nc_and_z adds r0, r1


' CHECK: if_nc adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x31]
' CHECK-INST: if_nc adds r0, r1


' CHECK: if_c_and_nz adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x41]
' CHECK-INST: if_c_and_nz adds r0, r1


' CHECK: if_nz adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x51]
' CHECK-INST: if_nz adds r0, r1


' CHECK: if_c_ne_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x61]
' CHECK-INST: if_c_ne_z adds r0, r1


' CHECK: if_nc_or_nz adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x71]
' CHECK-INST: if_nc_or_nz adds r0, r1


' CHECK: if_c_and_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x81]
' CHECK-INST: if_c_and_z adds r0, r1


' CHECK: if_c_eq_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0x91]
' CHECK-INST: if_c_eq_z adds r0, r1


' CHECK: if_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xa1]
' CHECK-INST: if_z adds r0, r1


' CHECK: if_nc_or_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xb1]
' CHECK-INST: if_nc_or_z adds r0, r1


' CHECK: if_c adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xc1]
' CHECK-INST: if_c adds r0, r1


' CHECK: if_c_or_nz adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xd1]
' CHECK-INST: if_c_or_nz adds r0, r1


' CHECK: if_c_or_z adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xe1]
' CHECK-INST: if_c_or_z adds r0, r1


' CHECK: adds r0, r1 ' encoding: [0xd1,0xa1,0x43,0xf1]
' CHECK-INST: adds r0, r1


' CHECK: adds r0, #1 ' encoding: [0x01,0xa0,0x47,0xf1]
' CHECK-INST: adds r0, #1


' CHECK: _ret_ adds r0, r1 wc ' encoding: [0xd1,0xa1,0x53,0x01]
' CHECK-INST: _ret_ adds r0, r1 wc


' CHECK: _ret_ adds r0, r1 wz ' encoding: [0xd1,0xa1,0x4b,0x01]
' CHECK-INST: _ret_ adds r0, r1 wz


' CHECK: _ret_ adds r0, r1 wcz ' encoding: [0xd1,0xa1,0x5b,0x01]
' CHECK-INST: _ret_ adds r0, r1 wcz

