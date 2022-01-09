
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ tjnz r0, r1
	if_nc_and_nz tjnz r0, r1
	if_nc_and_z tjnz r0, r1
	if_nc tjnz r0, r1
	if_c_and_nz tjnz r0, r1
	if_nz tjnz r0, r1
	if_c_ne_z tjnz r0, r1
	if_nc_or_nz tjnz r0, r1
	if_c_and_z tjnz r0, r1
	if_c_eq_z tjnz r0, r1
	if_z tjnz r0, r1
	if_nc_or_z tjnz r0, r1
	if_c tjnz r0, r1
	if_c_or_nz tjnz r0, r1
	if_c_or_z tjnz r0, r1
	tjnz r0, r1
	tjnz r0, #3
	_ret_ tjnz r0, r1


' CHECK: _ret_ tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x0b]
' CHECK-INST: _ret_ tjnz r0, r1


' CHECK: if_nc_and_nz tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x1b]
' CHECK-INST: if_nc_and_nz tjnz r0, r1


' CHECK: if_nc_and_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x2b]
' CHECK-INST: if_nc_and_z tjnz r0, r1


' CHECK: if_nc tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x3b]
' CHECK-INST: if_nc tjnz r0, r1


' CHECK: if_c_and_nz tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x4b]
' CHECK-INST: if_c_and_nz tjnz r0, r1


' CHECK: if_nz tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x5b]
' CHECK-INST: if_nz tjnz r0, r1


' CHECK: if_c_ne_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x6b]
' CHECK-INST: if_c_ne_z tjnz r0, r1


' CHECK: if_nc_or_nz tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x7b]
' CHECK-INST: if_nc_or_nz tjnz r0, r1


' CHECK: if_c_and_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x8b]
' CHECK-INST: if_c_and_z tjnz r0, r1


' CHECK: if_c_eq_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x9b]
' CHECK-INST: if_c_eq_z tjnz r0, r1


' CHECK: if_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xab]
' CHECK-INST: if_z tjnz r0, r1


' CHECK: if_nc_or_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xbb]
' CHECK-INST: if_nc_or_z tjnz r0, r1


' CHECK: if_c tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xcb]
' CHECK-INST: if_c tjnz r0, r1


' CHECK: if_c_or_nz tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xdb]
' CHECK-INST: if_c_or_nz tjnz r0, r1


' CHECK: if_c_or_z tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xeb]
' CHECK-INST: if_c_or_z tjnz r0, r1


' CHECK: tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0xfb]
' CHECK-INST: tjnz r0, r1


' CHECK: tjnz r0, #3 ' encoding: [0x03,0xa0,0x9f,0xfb]
' CHECK-INST: tjnz r0, #3


' CHECK: _ret_ tjnz r0, r1 ' encoding: [0xd1,0xa1,0x9b,0x0b]
' CHECK-INST: _ret_ tjnz r0, r1

