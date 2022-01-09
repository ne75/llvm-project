
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ encod r0, r1
	if_nc_and_nz encod r0, r1
	if_nc_and_z encod r0, r1
	if_nc encod r0, r1
	if_c_and_nz encod r0, r1
	if_nz encod r0, r1
	if_c_ne_z encod r0, r1
	if_nc_or_nz encod r0, r1
	if_c_and_z encod r0, r1
	if_c_eq_z encod r0, r1
	if_z encod r0, r1
	if_nc_or_z encod r0, r1
	if_c encod r0, r1
	if_c_or_nz encod r0, r1
	if_c_or_z encod r0, r1
	encod r0, r1
	encod r0, #1
	_ret_ encod r0, r1 wc
	_ret_ encod r0, r1 wz
	_ret_ encod r0, r1 wcz


' CHECK: _ret_ encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x07]
' CHECK-INST: _ret_ encod r0, r1


' CHECK: if_nc_and_nz encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x17]
' CHECK-INST: if_nc_and_nz encod r0, r1


' CHECK: if_nc_and_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x27]
' CHECK-INST: if_nc_and_z encod r0, r1


' CHECK: if_nc encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x37]
' CHECK-INST: if_nc encod r0, r1


' CHECK: if_c_and_nz encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x47]
' CHECK-INST: if_c_and_nz encod r0, r1


' CHECK: if_nz encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x57]
' CHECK-INST: if_nz encod r0, r1


' CHECK: if_c_ne_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x67]
' CHECK-INST: if_c_ne_z encod r0, r1


' CHECK: if_nc_or_nz encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x77]
' CHECK-INST: if_nc_or_nz encod r0, r1


' CHECK: if_c_and_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x87]
' CHECK-INST: if_c_and_z encod r0, r1


' CHECK: if_c_eq_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0x97]
' CHECK-INST: if_c_eq_z encod r0, r1


' CHECK: if_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xa7]
' CHECK-INST: if_z encod r0, r1


' CHECK: if_nc_or_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xb7]
' CHECK-INST: if_nc_or_z encod r0, r1


' CHECK: if_c encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xc7]
' CHECK-INST: if_c encod r0, r1


' CHECK: if_c_or_nz encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xd7]
' CHECK-INST: if_c_or_nz encod r0, r1


' CHECK: if_c_or_z encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xe7]
' CHECK-INST: if_c_or_z encod r0, r1


' CHECK: encod r0, r1 ' encoding: [0xd1,0xa1,0x83,0xf7]
' CHECK-INST: encod r0, r1


' CHECK: encod r0, #1 ' encoding: [0x01,0xa0,0x87,0xf7]
' CHECK-INST: encod r0, #1


' CHECK: _ret_ encod r0, r1 wc ' encoding: [0xd1,0xa1,0x93,0x07]
' CHECK-INST: _ret_ encod r0, r1 wc


' CHECK: _ret_ encod r0, r1 wz ' encoding: [0xd1,0xa1,0x8b,0x07]
' CHECK-INST: _ret_ encod r0, r1 wz


' CHECK: _ret_ encod r0, r1 wcz ' encoding: [0xd1,0xa1,0x9b,0x07]
' CHECK-INST: _ret_ encod r0, r1 wcz

