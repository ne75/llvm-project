
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ subs r0, r1
	if_nc_and_nz subs r0, r1
	if_nc_and_z subs r0, r1
	if_nc subs r0, r1
	if_c_and_nz subs r0, r1
	if_nz subs r0, r1
	if_c_ne_z subs r0, r1
	if_nc_or_nz subs r0, r1
	if_c_and_z subs r0, r1
	if_c_eq_z subs r0, r1
	if_z subs r0, r1
	if_nc_or_z subs r0, r1
	if_c subs r0, r1
	if_c_or_nz subs r0, r1
	if_c_or_z subs r0, r1
	subs r0, r1
	subs r0, #1
	_ret_ subs r0, r1 wc
	_ret_ subs r0, r1 wz
	_ret_ subs r0, r1 wcz


' CHECK: _ret_ subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x01]
' CHECK-INST: _ret_ subs r0, r1


' CHECK: if_nc_and_nz subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x11]
' CHECK-INST: if_nc_and_nz subs r0, r1


' CHECK: if_nc_and_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x21]
' CHECK-INST: if_nc_and_z subs r0, r1


' CHECK: if_nc subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x31]
' CHECK-INST: if_nc subs r0, r1


' CHECK: if_c_and_nz subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x41]
' CHECK-INST: if_c_and_nz subs r0, r1


' CHECK: if_nz subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x51]
' CHECK-INST: if_nz subs r0, r1


' CHECK: if_c_ne_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x61]
' CHECK-INST: if_c_ne_z subs r0, r1


' CHECK: if_nc_or_nz subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x71]
' CHECK-INST: if_nc_or_nz subs r0, r1


' CHECK: if_c_and_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x81]
' CHECK-INST: if_c_and_z subs r0, r1


' CHECK: if_c_eq_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x91]
' CHECK-INST: if_c_eq_z subs r0, r1


' CHECK: if_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xa1]
' CHECK-INST: if_z subs r0, r1


' CHECK: if_nc_or_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xb1]
' CHECK-INST: if_nc_or_z subs r0, r1


' CHECK: if_c subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xc1]
' CHECK-INST: if_c subs r0, r1


' CHECK: if_c_or_nz subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xd1]
' CHECK-INST: if_c_or_nz subs r0, r1


' CHECK: if_c_or_z subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xe1]
' CHECK-INST: if_c_or_z subs r0, r1


' CHECK: subs r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xf1]
' CHECK-INST: subs r0, r1


' CHECK: subs r0, #1 ' encoding: [0x01,0xa0,0xc7,0xf1]
' CHECK-INST: subs r0, #1


' CHECK: _ret_ subs r0, r1 wc ' encoding: [0xd1,0xa1,0xd3,0x01]
' CHECK-INST: _ret_ subs r0, r1 wc


' CHECK: _ret_ subs r0, r1 wz ' encoding: [0xd1,0xa1,0xcb,0x01]
' CHECK-INST: _ret_ subs r0, r1 wz


' CHECK: _ret_ subs r0, r1 wcz ' encoding: [0xd1,0xa1,0xdb,0x01]
' CHECK-INST: _ret_ subs r0, r1 wcz

