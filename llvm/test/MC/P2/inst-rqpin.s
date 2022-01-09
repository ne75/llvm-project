
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rqpin r0, r1
	if_nc_and_nz rqpin r0, r1
	if_nc_and_z rqpin r0, r1
	if_nc rqpin r0, r1
	if_c_and_nz rqpin r0, r1
	if_nz rqpin r0, r1
	if_c_ne_z rqpin r0, r1
	if_nc_or_nz rqpin r0, r1
	if_c_and_z rqpin r0, r1
	if_c_eq_z rqpin r0, r1
	if_z rqpin r0, r1
	if_nc_or_z rqpin r0, r1
	if_c rqpin r0, r1
	if_c_or_nz rqpin r0, r1
	if_c_or_z rqpin r0, r1
	rqpin r0, r1
	rqpin r0, #3
	_ret_ rqpin r0, r1 wc


' CHECK: _ret_ rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x0a]
' CHECK-INST: _ret_ rqpin r0, r1


' CHECK: if_nc_and_nz rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x1a]
' CHECK-INST: if_nc_and_nz rqpin r0, r1


' CHECK: if_nc_and_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x2a]
' CHECK-INST: if_nc_and_z rqpin r0, r1


' CHECK: if_nc rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x3a]
' CHECK-INST: if_nc rqpin r0, r1


' CHECK: if_c_and_nz rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x4a]
' CHECK-INST: if_c_and_nz rqpin r0, r1


' CHECK: if_nz rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x5a]
' CHECK-INST: if_nz rqpin r0, r1


' CHECK: if_c_ne_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x6a]
' CHECK-INST: if_c_ne_z rqpin r0, r1


' CHECK: if_nc_or_nz rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x7a]
' CHECK-INST: if_nc_or_nz rqpin r0, r1


' CHECK: if_c_and_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x8a]
' CHECK-INST: if_c_and_z rqpin r0, r1


' CHECK: if_c_eq_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0x9a]
' CHECK-INST: if_c_eq_z rqpin r0, r1


' CHECK: if_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xaa]
' CHECK-INST: if_z rqpin r0, r1


' CHECK: if_nc_or_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xba]
' CHECK-INST: if_nc_or_z rqpin r0, r1


' CHECK: if_c rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xca]
' CHECK-INST: if_c rqpin r0, r1


' CHECK: if_c_or_nz rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xda]
' CHECK-INST: if_c_or_nz rqpin r0, r1


' CHECK: if_c_or_z rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xea]
' CHECK-INST: if_c_or_z rqpin r0, r1


' CHECK: rqpin r0, r1 ' encoding: [0xd1,0xa1,0x83,0xfa]
' CHECK-INST: rqpin r0, r1


' CHECK: rqpin r0, #3 ' encoding: [0x03,0xa0,0x87,0xfa]
' CHECK-INST: rqpin r0, #3


' CHECK: _ret_ rqpin r0, r1 wc ' encoding: [0xd1,0xa1,0x93,0x0a]
' CHECK-INST: _ret_ rqpin r0, r1 wc

