
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ mov r0, r1
	if_nc_and_nz mov r0, r1
	if_nc_and_z mov r0, r1
	if_nc mov r0, r1
	if_c_and_nz mov r0, r1
	if_nz mov r0, r1
	if_c_ne_z mov r0, r1
	if_nc_or_nz mov r0, r1
	if_c_and_z mov r0, r1
	if_c_eq_z mov r0, r1
	if_z mov r0, r1
	if_nc_or_z mov r0, r1
	if_c mov r0, r1
	if_c_or_nz mov r0, r1
	if_c_or_z mov r0, r1
	mov r0, r1
	mov r0, #1
	_ret_ mov r0, r1 wc
	_ret_ mov r0, r1 wz
	_ret_ mov r0, r1 wcz


' CHECK: _ret_ mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x06]
' CHECK-INST: _ret_ mov r0, r1


' CHECK: if_nc_and_nz mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x16]
' CHECK-INST: if_nc_and_nz mov r0, r1


' CHECK: if_nc_and_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x26]
' CHECK-INST: if_nc_and_z mov r0, r1


' CHECK: if_nc mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x36]
' CHECK-INST: if_nc mov r0, r1


' CHECK: if_c_and_nz mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x46]
' CHECK-INST: if_c_and_nz mov r0, r1


' CHECK: if_nz mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x56]
' CHECK-INST: if_nz mov r0, r1


' CHECK: if_c_ne_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x66]
' CHECK-INST: if_c_ne_z mov r0, r1


' CHECK: if_nc_or_nz mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x76]
' CHECK-INST: if_nc_or_nz mov r0, r1


' CHECK: if_c_and_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x86]
' CHECK-INST: if_c_and_z mov r0, r1


' CHECK: if_c_eq_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0x96]
' CHECK-INST: if_c_eq_z mov r0, r1


' CHECK: if_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xa6]
' CHECK-INST: if_z mov r0, r1


' CHECK: if_nc_or_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xb6]
' CHECK-INST: if_nc_or_z mov r0, r1


' CHECK: if_c mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xc6]
' CHECK-INST: if_c mov r0, r1


' CHECK: if_c_or_nz mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xd6]
' CHECK-INST: if_c_or_nz mov r0, r1


' CHECK: if_c_or_z mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xe6]
' CHECK-INST: if_c_or_z mov r0, r1


' CHECK: mov r0, r1 ' encoding: [0xd1,0xa1,0x03,0xf6]
' CHECK-INST: mov r0, r1


' CHECK: mov r0, #1 ' encoding: [0x01,0xa0,0x07,0xf6]
' CHECK-INST: mov r0, #1


' CHECK: _ret_ mov r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x06]
' CHECK-INST: _ret_ mov r0, r1 wc


' CHECK: _ret_ mov r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x06]
' CHECK-INST: _ret_ mov r0, r1 wz


' CHECK: _ret_ mov r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x06]
' CHECK-INST: _ret_ mov r0, r1 wcz

