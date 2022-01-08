
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wxpin r0, r1
	if_nc_and_nz wxpin r0, r1
	if_nc_and_z wxpin r0, r1
	if_nc wxpin r0, r1
	if_c_and_nz wxpin r0, r1
	if_nz wxpin r0, r1
	if_c_ne_z wxpin r0, r1
	if_nc_or_nz wxpin r0, r1
	if_c_and_z wxpin r0, r1
	if_c_eq_z wxpin r0, r1
	if_z wxpin r0, r1
	if_nc_or_z wxpin r0, r1
	if_c wxpin r0, r1
	if_c_or_nz wxpin r0, r1
	if_c_or_z wxpin r0, r1
	wxpin r0, r1
	wxpin r0, #3
	wxpin #3, r0
	wxpin #3, #3
	_ret_ wxpin r0, r1


' CHECK: _ret_ wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x0c]
' CHECK-INST: _ret_ wxpin r0, r1


' CHECK: if_nc_and_nz wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x1c]
' CHECK-INST: if_nc_and_nz wxpin r0, r1


' CHECK: if_nc_and_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x2c]
' CHECK-INST: if_nc_and_z wxpin r0, r1


' CHECK: if_nc wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x3c]
' CHECK-INST: if_nc wxpin r0, r1


' CHECK: if_c_and_nz wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x4c]
' CHECK-INST: if_c_and_nz wxpin r0, r1


' CHECK: if_nz wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x5c]
' CHECK-INST: if_nz wxpin r0, r1


' CHECK: if_c_ne_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x6c]
' CHECK-INST: if_c_ne_z wxpin r0, r1


' CHECK: if_nc_or_nz wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x7c]
' CHECK-INST: if_nc_or_nz wxpin r0, r1


' CHECK: if_c_and_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x8c]
' CHECK-INST: if_c_and_z wxpin r0, r1


' CHECK: if_c_eq_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x9c]
' CHECK-INST: if_c_eq_z wxpin r0, r1


' CHECK: if_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xac]
' CHECK-INST: if_z wxpin r0, r1


' CHECK: if_nc_or_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xbc]
' CHECK-INST: if_nc_or_z wxpin r0, r1


' CHECK: if_c wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xcc]
' CHECK-INST: if_c wxpin r0, r1


' CHECK: if_c_or_nz wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xdc]
' CHECK-INST: if_c_or_nz wxpin r0, r1


' CHECK: if_c_or_z wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xec]
' CHECK-INST: if_c_or_z wxpin r0, r1


' CHECK: wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0xfc]
' CHECK-INST: wxpin r0, r1


' CHECK: wxpin r0, #3 ' encoding: [0x03,0xa0,0x17,0xfc]
' CHECK-INST: wxpin r0, #3


' CHECK: wxpin #3, r0 ' encoding: [0xd0,0x07,0x18,0xfc]
' CHECK-INST: wxpin #3, r0


' CHECK: wxpin #3, #3 ' encoding: [0x03,0x06,0x1c,0xfc]
' CHECK-INST: wxpin #3, #3


' CHECK: _ret_ wxpin r0, r1 ' encoding: [0xd1,0xa1,0x13,0x0c]
' CHECK-INST: _ret_ wxpin r0, r1

