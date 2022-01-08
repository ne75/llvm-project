
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rcl r0, r1
	if_nc_and_nz rcl r0, r1
	if_nc_and_z rcl r0, r1
	if_nc rcl r0, r1
	if_c_and_nz rcl r0, r1
	if_nz rcl r0, r1
	if_c_ne_z rcl r0, r1
	if_nc_or_nz rcl r0, r1
	if_c_and_z rcl r0, r1
	if_c_eq_z rcl r0, r1
	if_z rcl r0, r1
	if_nc_or_z rcl r0, r1
	if_c rcl r0, r1
	if_c_or_nz rcl r0, r1
	if_c_or_z rcl r0, r1
	rcl r0, r1
	rcl r0, #1
	_ret_ rcl r0, r1 wc
	_ret_ rcl r0, r1 wz
	_ret_ rcl r0, r1 wcz


' CHECK: _ret_ rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x00]
' CHECK-INST: _ret_ rcl r0, r1


' CHECK: if_nc_and_nz rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x10]
' CHECK-INST: if_nc_and_nz rcl r0, r1


' CHECK: if_nc_and_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x20]
' CHECK-INST: if_nc_and_z rcl r0, r1


' CHECK: if_nc rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x30]
' CHECK-INST: if_nc rcl r0, r1


' CHECK: if_c_and_nz rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x40]
' CHECK-INST: if_c_and_nz rcl r0, r1


' CHECK: if_nz rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x50]
' CHECK-INST: if_nz rcl r0, r1


' CHECK: if_c_ne_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x60]
' CHECK-INST: if_c_ne_z rcl r0, r1


' CHECK: if_nc_or_nz rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x70]
' CHECK-INST: if_nc_or_nz rcl r0, r1


' CHECK: if_c_and_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x80]
' CHECK-INST: if_c_and_z rcl r0, r1


' CHECK: if_c_eq_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x90]
' CHECK-INST: if_c_eq_z rcl r0, r1


' CHECK: if_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xa0]
' CHECK-INST: if_z rcl r0, r1


' CHECK: if_nc_or_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xb0]
' CHECK-INST: if_nc_or_z rcl r0, r1


' CHECK: if_c rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xc0]
' CHECK-INST: if_c rcl r0, r1


' CHECK: if_c_or_nz rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xd0]
' CHECK-INST: if_c_or_nz rcl r0, r1


' CHECK: if_c_or_z rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xe0]
' CHECK-INST: if_c_or_z rcl r0, r1


' CHECK: rcl r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xf0]
' CHECK-INST: rcl r0, r1


' CHECK: rcl r0, #1 ' encoding: [0x01,0xa0,0xa7,0xf0]
' CHECK-INST: rcl r0, #1


' CHECK: _ret_ rcl r0, r1 wc ' encoding: [0xd1,0xa1,0xb3,0x00]
' CHECK-INST: _ret_ rcl r0, r1 wc


' CHECK: _ret_ rcl r0, r1 wz ' encoding: [0xd1,0xa1,0xab,0x00]
' CHECK-INST: _ret_ rcl r0, r1 wz


' CHECK: _ret_ rcl r0, r1 wcz ' encoding: [0xd1,0xa1,0xbb,0x00]
' CHECK-INST: _ret_ rcl r0, r1 wcz

