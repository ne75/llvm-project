
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ shr r0, r1
	if_nc_and_nz shr r0, r1
	if_nc_and_z shr r0, r1
	if_nc shr r0, r1
	if_c_and_nz shr r0, r1
	if_nz shr r0, r1
	if_c_ne_z shr r0, r1
	if_nc_or_nz shr r0, r1
	if_c_and_z shr r0, r1
	if_c_eq_z shr r0, r1
	if_z shr r0, r1
	if_nc_or_z shr r0, r1
	if_c shr r0, r1
	if_c_or_nz shr r0, r1
	if_c_or_z shr r0, r1
	shr r0, r1
	shr r0, #1
	_ret_ shr r0, r1 wc
	_ret_ shr r0, r1 wz
	_ret_ shr r0, r1 wcz


' CHECK: _ret_ shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x00]
' CHECK-INST: _ret_ shr r0, r1


' CHECK: if_nc_and_nz shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x10]
' CHECK-INST: if_nc_and_nz shr r0, r1


' CHECK: if_nc_and_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x20]
' CHECK-INST: if_nc_and_z shr r0, r1


' CHECK: if_nc shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x30]
' CHECK-INST: if_nc shr r0, r1


' CHECK: if_c_and_nz shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x40]
' CHECK-INST: if_c_and_nz shr r0, r1


' CHECK: if_nz shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x50]
' CHECK-INST: if_nz shr r0, r1


' CHECK: if_c_ne_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x60]
' CHECK-INST: if_c_ne_z shr r0, r1


' CHECK: if_nc_or_nz shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x70]
' CHECK-INST: if_nc_or_nz shr r0, r1


' CHECK: if_c_and_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x80]
' CHECK-INST: if_c_and_z shr r0, r1


' CHECK: if_c_eq_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0x90]
' CHECK-INST: if_c_eq_z shr r0, r1


' CHECK: if_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xa0]
' CHECK-INST: if_z shr r0, r1


' CHECK: if_nc_or_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xb0]
' CHECK-INST: if_nc_or_z shr r0, r1


' CHECK: if_c shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xc0]
' CHECK-INST: if_c shr r0, r1


' CHECK: if_c_or_nz shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xd0]
' CHECK-INST: if_c_or_nz shr r0, r1


' CHECK: if_c_or_z shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xe0]
' CHECK-INST: if_c_or_z shr r0, r1


' CHECK: shr r0, r1 ' encoding: [0xd1,0xa1,0x43,0xf0]
' CHECK-INST: shr r0, r1


' CHECK: shr r0, #1 ' encoding: [0x01,0xa0,0x47,0xf0]
' CHECK-INST: shr r0, #1


' CHECK: _ret_ shr r0, r1 wc ' encoding: [0xd1,0xa1,0x53,0x00]
' CHECK-INST: _ret_ shr r0, r1 wc


' CHECK: _ret_ shr r0, r1 wz ' encoding: [0xd1,0xa1,0x4b,0x00]
' CHECK-INST: _ret_ shr r0, r1 wz


' CHECK: _ret_ shr r0, r1 wcz ' encoding: [0xd1,0xa1,0x5b,0x00]
' CHECK-INST: _ret_ shr r0, r1 wcz

