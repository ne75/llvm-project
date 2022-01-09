
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ tjz r0, r1
	if_nc_and_nz tjz r0, r1
	if_nc_and_z tjz r0, r1
	if_nc tjz r0, r1
	if_c_and_nz tjz r0, r1
	if_nz tjz r0, r1
	if_c_ne_z tjz r0, r1
	if_nc_or_nz tjz r0, r1
	if_c_and_z tjz r0, r1
	if_c_eq_z tjz r0, r1
	if_z tjz r0, r1
	if_nc_or_z tjz r0, r1
	if_c tjz r0, r1
	if_c_or_nz tjz r0, r1
	if_c_or_z tjz r0, r1
	tjz r0, r1
	tjz r0, #3
	_ret_ tjz r0, r1


' CHECK: _ret_ tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x0b]
' CHECK-INST: _ret_ tjz r0, r1


' CHECK: if_nc_and_nz tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x1b]
' CHECK-INST: if_nc_and_nz tjz r0, r1


' CHECK: if_nc_and_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x2b]
' CHECK-INST: if_nc_and_z tjz r0, r1


' CHECK: if_nc tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x3b]
' CHECK-INST: if_nc tjz r0, r1


' CHECK: if_c_and_nz tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x4b]
' CHECK-INST: if_c_and_nz tjz r0, r1


' CHECK: if_nz tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x5b]
' CHECK-INST: if_nz tjz r0, r1


' CHECK: if_c_ne_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x6b]
' CHECK-INST: if_c_ne_z tjz r0, r1


' CHECK: if_nc_or_nz tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x7b]
' CHECK-INST: if_nc_or_nz tjz r0, r1


' CHECK: if_c_and_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x8b]
' CHECK-INST: if_c_and_z tjz r0, r1


' CHECK: if_c_eq_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x9b]
' CHECK-INST: if_c_eq_z tjz r0, r1


' CHECK: if_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xab]
' CHECK-INST: if_z tjz r0, r1


' CHECK: if_nc_or_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xbb]
' CHECK-INST: if_nc_or_z tjz r0, r1


' CHECK: if_c tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xcb]
' CHECK-INST: if_c tjz r0, r1


' CHECK: if_c_or_nz tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xdb]
' CHECK-INST: if_c_or_nz tjz r0, r1


' CHECK: if_c_or_z tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xeb]
' CHECK-INST: if_c_or_z tjz r0, r1


' CHECK: tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0xfb]
' CHECK-INST: tjz r0, r1


' CHECK: tjz r0, #3 ' encoding: [0x03,0xa0,0x97,0xfb]
' CHECK-INST: tjz r0, #3


' CHECK: _ret_ tjz r0, r1 ' encoding: [0xd1,0xa1,0x93,0x0b]
' CHECK-INST: _ret_ tjz r0, r1

