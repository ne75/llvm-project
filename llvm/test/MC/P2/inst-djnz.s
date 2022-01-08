
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ djnz r0, r1
	if_nc_and_nz djnz r0, r1
	if_nc_and_z djnz r0, r1
	if_nc djnz r0, r1
	if_c_and_nz djnz r0, r1
	if_nz djnz r0, r1
	if_c_ne_z djnz r0, r1
	if_nc_or_nz djnz r0, r1
	if_c_and_z djnz r0, r1
	if_c_eq_z djnz r0, r1
	if_z djnz r0, r1
	if_nc_or_z djnz r0, r1
	if_c djnz r0, r1
	if_c_or_nz djnz r0, r1
	if_c_or_z djnz r0, r1
	djnz r0, r1
	djnz r0, #3
	_ret_ djnz r0, r1


' CHECK: _ret_ djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x0b]
' CHECK-INST: _ret_ djnz r0, r1


' CHECK: if_nc_and_nz djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x1b]
' CHECK-INST: if_nc_and_nz djnz r0, r1


' CHECK: if_nc_and_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x2b]
' CHECK-INST: if_nc_and_z djnz r0, r1


' CHECK: if_nc djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x3b]
' CHECK-INST: if_nc djnz r0, r1


' CHECK: if_c_and_nz djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x4b]
' CHECK-INST: if_c_and_nz djnz r0, r1


' CHECK: if_nz djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x5b]
' CHECK-INST: if_nz djnz r0, r1


' CHECK: if_c_ne_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x6b]
' CHECK-INST: if_c_ne_z djnz r0, r1


' CHECK: if_nc_or_nz djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x7b]
' CHECK-INST: if_nc_or_nz djnz r0, r1


' CHECK: if_c_and_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x8b]
' CHECK-INST: if_c_and_z djnz r0, r1


' CHECK: if_c_eq_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x9b]
' CHECK-INST: if_c_eq_z djnz r0, r1


' CHECK: if_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xab]
' CHECK-INST: if_z djnz r0, r1


' CHECK: if_nc_or_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xbb]
' CHECK-INST: if_nc_or_z djnz r0, r1


' CHECK: if_c djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xcb]
' CHECK-INST: if_c djnz r0, r1


' CHECK: if_c_or_nz djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xdb]
' CHECK-INST: if_c_or_nz djnz r0, r1


' CHECK: if_c_or_z djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xeb]
' CHECK-INST: if_c_or_z djnz r0, r1


' CHECK: djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0xfb]
' CHECK-INST: djnz r0, r1


' CHECK: djnz r0, #3 ' encoding: [0x03,0xa0,0x6f,0xfb]
' CHECK-INST: djnz r0, #3


' CHECK: _ret_ djnz r0, r1 ' encoding: [0xd1,0xa1,0x6b,0x0b]
' CHECK-INST: _ret_ djnz r0, r1

