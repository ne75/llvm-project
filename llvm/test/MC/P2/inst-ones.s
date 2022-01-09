
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ ones r0, r1
	if_nc_and_nz ones r0, r1
	if_nc_and_z ones r0, r1
	if_nc ones r0, r1
	if_c_and_nz ones r0, r1
	if_nz ones r0, r1
	if_c_ne_z ones r0, r1
	if_nc_or_nz ones r0, r1
	if_c_and_z ones r0, r1
	if_c_eq_z ones r0, r1
	if_z ones r0, r1
	if_nc_or_z ones r0, r1
	if_c ones r0, r1
	if_c_or_nz ones r0, r1
	if_c_or_z ones r0, r1
	ones r0, r1
	ones r0, #1
	_ret_ ones r0, r1 wc
	_ret_ ones r0, r1 wz
	_ret_ ones r0, r1 wcz


' CHECK: _ret_ ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x07]
' CHECK-INST: _ret_ ones r0, r1


' CHECK: if_nc_and_nz ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x17]
' CHECK-INST: if_nc_and_nz ones r0, r1


' CHECK: if_nc_and_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x27]
' CHECK-INST: if_nc_and_z ones r0, r1


' CHECK: if_nc ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x37]
' CHECK-INST: if_nc ones r0, r1


' CHECK: if_c_and_nz ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x47]
' CHECK-INST: if_c_and_nz ones r0, r1


' CHECK: if_nz ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x57]
' CHECK-INST: if_nz ones r0, r1


' CHECK: if_c_ne_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x67]
' CHECK-INST: if_c_ne_z ones r0, r1


' CHECK: if_nc_or_nz ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x77]
' CHECK-INST: if_nc_or_nz ones r0, r1


' CHECK: if_c_and_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x87]
' CHECK-INST: if_c_and_z ones r0, r1


' CHECK: if_c_eq_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x97]
' CHECK-INST: if_c_eq_z ones r0, r1


' CHECK: if_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xa7]
' CHECK-INST: if_z ones r0, r1


' CHECK: if_nc_or_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xb7]
' CHECK-INST: if_nc_or_z ones r0, r1


' CHECK: if_c ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xc7]
' CHECK-INST: if_c ones r0, r1


' CHECK: if_c_or_nz ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xd7]
' CHECK-INST: if_c_or_nz ones r0, r1


' CHECK: if_c_or_z ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xe7]
' CHECK-INST: if_c_or_z ones r0, r1


' CHECK: ones r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xf7]
' CHECK-INST: ones r0, r1


' CHECK: ones r0, #1 ' encoding: [0x01,0xa0,0xa7,0xf7]
' CHECK-INST: ones r0, #1


' CHECK: _ret_ ones r0, r1 wc ' encoding: [0xd1,0xa1,0xb3,0x07]
' CHECK-INST: _ret_ ones r0, r1 wc


' CHECK: _ret_ ones r0, r1 wz ' encoding: [0xd1,0xa1,0xab,0x07]
' CHECK-INST: _ret_ ones r0, r1 wz


' CHECK: _ret_ ones r0, r1 wcz ' encoding: [0xd1,0xa1,0xbb,0x07]
' CHECK-INST: _ret_ ones r0, r1 wcz

