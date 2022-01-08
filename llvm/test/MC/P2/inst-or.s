
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ or r0, r1
	if_nc_and_nz or r0, r1
	if_nc_and_z or r0, r1
	if_nc or r0, r1
	if_c_and_nz or r0, r1
	if_nz or r0, r1
	if_c_ne_z or r0, r1
	if_nc_or_nz or r0, r1
	if_c_and_z or r0, r1
	if_c_eq_z or r0, r1
	if_z or r0, r1
	if_nc_or_z or r0, r1
	if_c or r0, r1
	if_c_or_nz or r0, r1
	if_c_or_z or r0, r1
	or r0, r1
	or r0, #1
	_ret_ or r0, r1 wc
	_ret_ or r0, r1 wz
	_ret_ or r0, r1 wcz


' CHECK: _ret_ or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x05]
' CHECK-INST: _ret_ or r0, r1


' CHECK: if_nc_and_nz or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x15]
' CHECK-INST: if_nc_and_nz or r0, r1


' CHECK: if_nc_and_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x25]
' CHECK-INST: if_nc_and_z or r0, r1


' CHECK: if_nc or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x35]
' CHECK-INST: if_nc or r0, r1


' CHECK: if_c_and_nz or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x45]
' CHECK-INST: if_c_and_nz or r0, r1


' CHECK: if_nz or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x55]
' CHECK-INST: if_nz or r0, r1


' CHECK: if_c_ne_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x65]
' CHECK-INST: if_c_ne_z or r0, r1


' CHECK: if_nc_or_nz or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x75]
' CHECK-INST: if_nc_or_nz or r0, r1


' CHECK: if_c_and_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x85]
' CHECK-INST: if_c_and_z or r0, r1


' CHECK: if_c_eq_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0x95]
' CHECK-INST: if_c_eq_z or r0, r1


' CHECK: if_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xa5]
' CHECK-INST: if_z or r0, r1


' CHECK: if_nc_or_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xb5]
' CHECK-INST: if_nc_or_z or r0, r1


' CHECK: if_c or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xc5]
' CHECK-INST: if_c or r0, r1


' CHECK: if_c_or_nz or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xd5]
' CHECK-INST: if_c_or_nz or r0, r1


' CHECK: if_c_or_z or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xe5]
' CHECK-INST: if_c_or_z or r0, r1


' CHECK: or r0, r1 ' encoding: [0xd1,0xa1,0x43,0xf5]
' CHECK-INST: or r0, r1


' CHECK: or r0, #1 ' encoding: [0x01,0xa0,0x47,0xf5]
' CHECK-INST: or r0, #1


' CHECK: _ret_ or r0, r1 wc ' encoding: [0xd1,0xa1,0x53,0x05]
' CHECK-INST: _ret_ or r0, r1 wc


' CHECK: _ret_ or r0, r1 wz ' encoding: [0xd1,0xa1,0x4b,0x05]
' CHECK-INST: _ret_ or r0, r1 wz


' CHECK: _ret_ or r0, r1 wcz ' encoding: [0xd1,0xa1,0x5b,0x05]
' CHECK-INST: _ret_ or r0, r1 wcz

