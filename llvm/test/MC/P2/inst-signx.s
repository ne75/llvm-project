
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ signx r0, r1
	if_nc_and_nz signx r0, r1
	if_nc_and_z signx r0, r1
	if_nc signx r0, r1
	if_c_and_nz signx r0, r1
	if_nz signx r0, r1
	if_c_ne_z signx r0, r1
	if_nc_or_nz signx r0, r1
	if_c_and_z signx r0, r1
	if_c_eq_z signx r0, r1
	if_z signx r0, r1
	if_nc_or_z signx r0, r1
	if_c signx r0, r1
	if_c_or_nz signx r0, r1
	if_c_or_z signx r0, r1
	signx r0, r1
	signx r0, #1
	_ret_ signx r0, r1 wc
	_ret_ signx r0, r1 wz
	_ret_ signx r0, r1 wcz


' CHECK: _ret_ signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x07]
' CHECK-INST: _ret_ signx r0, r1


' CHECK: if_nc_and_nz signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x17]
' CHECK-INST: if_nc_and_nz signx r0, r1


' CHECK: if_nc_and_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x27]
' CHECK-INST: if_nc_and_z signx r0, r1


' CHECK: if_nc signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x37]
' CHECK-INST: if_nc signx r0, r1


' CHECK: if_c_and_nz signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x47]
' CHECK-INST: if_c_and_nz signx r0, r1


' CHECK: if_nz signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x57]
' CHECK-INST: if_nz signx r0, r1


' CHECK: if_c_ne_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x67]
' CHECK-INST: if_c_ne_z signx r0, r1


' CHECK: if_nc_or_nz signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x77]
' CHECK-INST: if_nc_or_nz signx r0, r1


' CHECK: if_c_and_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x87]
' CHECK-INST: if_c_and_z signx r0, r1


' CHECK: if_c_eq_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x97]
' CHECK-INST: if_c_eq_z signx r0, r1


' CHECK: if_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa7]
' CHECK-INST: if_z signx r0, r1


' CHECK: if_nc_or_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb7]
' CHECK-INST: if_nc_or_z signx r0, r1


' CHECK: if_c signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc7]
' CHECK-INST: if_c signx r0, r1


' CHECK: if_c_or_nz signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd7]
' CHECK-INST: if_c_or_nz signx r0, r1


' CHECK: if_c_or_z signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe7]
' CHECK-INST: if_c_or_z signx r0, r1


' CHECK: signx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf7]
' CHECK-INST: signx r0, r1


' CHECK: signx r0, #1 ' encoding: [0x01,0xa0,0x67,0xf7]
' CHECK-INST: signx r0, #1


' CHECK: _ret_ signx r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x07]
' CHECK-INST: _ret_ signx r0, r1 wc


' CHECK: _ret_ signx r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x07]
' CHECK-INST: _ret_ signx r0, r1 wz


' CHECK: _ret_ signx r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x07]
' CHECK-INST: _ret_ signx r0, r1 wcz

