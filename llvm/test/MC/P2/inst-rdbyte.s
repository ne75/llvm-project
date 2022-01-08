
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdbyte r0, r1
	if_nc_and_nz rdbyte r0, r1
	if_nc_and_z rdbyte r0, r1
	if_nc rdbyte r0, r1
	if_c_and_nz rdbyte r0, r1
	if_nz rdbyte r0, r1
	if_c_ne_z rdbyte r0, r1
	if_nc_or_nz rdbyte r0, r1
	if_c_and_z rdbyte r0, r1
	if_c_eq_z rdbyte r0, r1
	if_z rdbyte r0, r1
	if_nc_or_z rdbyte r0, r1
	if_c rdbyte r0, r1
	if_c_or_nz rdbyte r0, r1
	if_c_or_z rdbyte r0, r1
	rdbyte r0, r1
	rdbyte r0, #1
	_ret_ rdbyte r0, r1 wc
	_ret_ rdbyte r0, r1 wz
	_ret_ rdbyte r0, r1 wcz


' CHECK: _ret_ rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x0a]
' CHECK-INST: _ret_ rdbyte r0, r1


' CHECK: if_nc_and_nz rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x1a]
' CHECK-INST: if_nc_and_nz rdbyte r0, r1


' CHECK: if_nc_and_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x2a]
' CHECK-INST: if_nc_and_z rdbyte r0, r1


' CHECK: if_nc rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x3a]
' CHECK-INST: if_nc rdbyte r0, r1


' CHECK: if_c_and_nz rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x4a]
' CHECK-INST: if_c_and_nz rdbyte r0, r1


' CHECK: if_nz rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x5a]
' CHECK-INST: if_nz rdbyte r0, r1


' CHECK: if_c_ne_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x6a]
' CHECK-INST: if_c_ne_z rdbyte r0, r1


' CHECK: if_nc_or_nz rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x7a]
' CHECK-INST: if_nc_or_nz rdbyte r0, r1


' CHECK: if_c_and_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x8a]
' CHECK-INST: if_c_and_z rdbyte r0, r1


' CHECK: if_c_eq_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0x9a]
' CHECK-INST: if_c_eq_z rdbyte r0, r1


' CHECK: if_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xaa]
' CHECK-INST: if_z rdbyte r0, r1


' CHECK: if_nc_or_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xba]
' CHECK-INST: if_nc_or_z rdbyte r0, r1


' CHECK: if_c rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xca]
' CHECK-INST: if_c rdbyte r0, r1


' CHECK: if_c_or_nz rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xda]
' CHECK-INST: if_c_or_nz rdbyte r0, r1


' CHECK: if_c_or_z rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xea]
' CHECK-INST: if_c_or_z rdbyte r0, r1


' CHECK: rdbyte r0, r1 ' encoding: [0xd1,0xa1,0xc3,0xfa]
' CHECK-INST: rdbyte r0, r1


' CHECK: rdbyte r0, #1 ' encoding: [0x01,0xa0,0xc7,0xfa]
' CHECK-INST: rdbyte r0, #1


' CHECK: _ret_ rdbyte r0, r1 wc ' encoding: [0xd1,0xa1,0xd3,0x0a]
' CHECK-INST: _ret_ rdbyte r0, r1 wc


' CHECK: _ret_ rdbyte r0, r1 wz ' encoding: [0xd1,0xa1,0xcb,0x0a]
' CHECK-INST: _ret_ rdbyte r0, r1 wz


' CHECK: _ret_ rdbyte r0, r1 wcz ' encoding: [0xd1,0xa1,0xdb,0x0a]
' CHECK-INST: _ret_ rdbyte r0, r1 wcz

