
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ calla #1
	if_nc_and_nz calla #1
	if_nc_and_z calla #1
	if_nc calla #1
	if_c_and_nz calla #1
	if_nz calla #1
	if_c_ne_z calla #1
	if_nc_or_nz calla #1
	if_c_and_z calla #1
	if_c_eq_z calla #1
	if_z calla #1
	if_nc_or_z calla #1
	if_c calla #1
	if_c_or_nz calla #1
	if_c_or_z calla #1
	calla #1


' CHECK: _ret_ calla #1 ' encoding: [0x01,0x00,0xc0,0x0d]
' CHECK-INST: _ret_ calla #1


' CHECK: if_nc_and_nz calla #1 ' encoding: [0x01,0x00,0xc0,0x1d]
' CHECK-INST: if_nc_and_nz calla #1


' CHECK: if_nc_and_z calla #1 ' encoding: [0x01,0x00,0xc0,0x2d]
' CHECK-INST: if_nc_and_z calla #1


' CHECK: if_nc calla #1 ' encoding: [0x01,0x00,0xc0,0x3d]
' CHECK-INST: if_nc calla #1


' CHECK: if_c_and_nz calla #1 ' encoding: [0x01,0x00,0xc0,0x4d]
' CHECK-INST: if_c_and_nz calla #1


' CHECK: if_nz calla #1 ' encoding: [0x01,0x00,0xc0,0x5d]
' CHECK-INST: if_nz calla #1


' CHECK: if_c_ne_z calla #1 ' encoding: [0x01,0x00,0xc0,0x6d]
' CHECK-INST: if_c_ne_z calla #1


' CHECK: if_nc_or_nz calla #1 ' encoding: [0x01,0x00,0xc0,0x7d]
' CHECK-INST: if_nc_or_nz calla #1


' CHECK: if_c_and_z calla #1 ' encoding: [0x01,0x00,0xc0,0x8d]
' CHECK-INST: if_c_and_z calla #1


' CHECK: if_c_eq_z calla #1 ' encoding: [0x01,0x00,0xc0,0x9d]
' CHECK-INST: if_c_eq_z calla #1


' CHECK: if_z calla #1 ' encoding: [0x01,0x00,0xc0,0xad]
' CHECK-INST: if_z calla #1


' CHECK: if_nc_or_z calla #1 ' encoding: [0x01,0x00,0xc0,0xbd]
' CHECK-INST: if_nc_or_z calla #1


' CHECK: if_c calla #1 ' encoding: [0x01,0x00,0xc0,0xcd]
' CHECK-INST: if_c calla #1


' CHECK: if_c_or_nz calla #1 ' encoding: [0x01,0x00,0xc0,0xdd]
' CHECK-INST: if_c_or_nz calla #1


' CHECK: if_c_or_z calla #1 ' encoding: [0x01,0x00,0xc0,0xed]
' CHECK-INST: if_c_or_z calla #1


' CHECK: calla #1 ' encoding: [0x01,0x00,0xc0,0xfd]
' CHECK-INST: calla #1

