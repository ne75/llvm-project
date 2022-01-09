
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ abs r0, r1
	if_nc_and_nz abs r0, r1
	if_nc_and_z abs r0, r1
	if_nc abs r0, r1
	if_c_and_nz abs r0, r1
	if_nz abs r0, r1
	if_c_ne_z abs r0, r1
	if_nc_or_nz abs r0, r1
	if_c_and_z abs r0, r1
	if_c_eq_z abs r0, r1
	if_z abs r0, r1
	if_nc_or_z abs r0, r1
	if_c abs r0, r1
	if_c_or_nz abs r0, r1
	if_c_or_z abs r0, r1
	abs r0, r1
	abs r0, #1
	_ret_ abs r0, r1 wc
	_ret_ abs r0, r1 wz
	_ret_ abs r0, r1 wcz


' CHECK: _ret_ abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x06]
' CHECK-INST: _ret_ abs r0, r1


' CHECK: if_nc_and_nz abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x16]
' CHECK-INST: if_nc_and_nz abs r0, r1


' CHECK: if_nc_and_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x26]
' CHECK-INST: if_nc_and_z abs r0, r1


' CHECK: if_nc abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x36]
' CHECK-INST: if_nc abs r0, r1


' CHECK: if_c_and_nz abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x46]
' CHECK-INST: if_c_and_nz abs r0, r1


' CHECK: if_nz abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x56]
' CHECK-INST: if_nz abs r0, r1


' CHECK: if_c_ne_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x66]
' CHECK-INST: if_c_ne_z abs r0, r1


' CHECK: if_nc_or_nz abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x76]
' CHECK-INST: if_nc_or_nz abs r0, r1


' CHECK: if_c_and_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x86]
' CHECK-INST: if_c_and_z abs r0, r1


' CHECK: if_c_eq_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0x96]
' CHECK-INST: if_c_eq_z abs r0, r1


' CHECK: if_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xa6]
' CHECK-INST: if_z abs r0, r1


' CHECK: if_nc_or_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xb6]
' CHECK-INST: if_nc_or_z abs r0, r1


' CHECK: if_c abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xc6]
' CHECK-INST: if_c abs r0, r1


' CHECK: if_c_or_nz abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xd6]
' CHECK-INST: if_c_or_nz abs r0, r1


' CHECK: if_c_or_z abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xe6]
' CHECK-INST: if_c_or_z abs r0, r1


' CHECK: abs r0, r1 ' encoding: [0xd1,0xa1,0x43,0xf6]
' CHECK-INST: abs r0, r1


' CHECK: abs r0, #1 ' encoding: [0x01,0xa0,0x47,0xf6]
' CHECK-INST: abs r0, #1


' CHECK: _ret_ abs r0, r1 wc ' encoding: [0xd1,0xa1,0x53,0x06]
' CHECK-INST: _ret_ abs r0, r1 wc


' CHECK: _ret_ abs r0, r1 wz ' encoding: [0xd1,0xa1,0x4b,0x06]
' CHECK-INST: _ret_ abs r0, r1 wz


' CHECK: _ret_ abs r0, r1 wcz ' encoding: [0xd1,0xa1,0x5b,0x06]
' CHECK-INST: _ret_ abs r0, r1 wcz

