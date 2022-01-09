
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ call #1
	if_nc_and_nz call #1
	if_nc_and_z call #1
	if_nc call #1
	if_c_and_nz call #1
	if_nz call #1
	if_c_ne_z call #1
	if_nc_or_nz call #1
	if_c_and_z call #1
	if_c_eq_z call #1
	if_z call #1
	if_nc_or_z call #1
	if_c call #1
	if_c_or_nz call #1
	if_c_or_z call #1
	call #1
	_ret_ call /#1


' CHECK: _ret_ call #1 ' encoding: [0x01,0x00,0xb0,0x0d]
' CHECK-INST: _ret_ call #1


' CHECK: if_nc_and_nz call #1 ' encoding: [0x01,0x00,0xb0,0x1d]
' CHECK-INST: if_nc_and_nz call #1


' CHECK: if_nc_and_z call #1 ' encoding: [0x01,0x00,0xb0,0x2d]
' CHECK-INST: if_nc_and_z call #1


' CHECK: if_nc call #1 ' encoding: [0x01,0x00,0xb0,0x3d]
' CHECK-INST: if_nc call #1


' CHECK: if_c_and_nz call #1 ' encoding: [0x01,0x00,0xb0,0x4d]
' CHECK-INST: if_c_and_nz call #1


' CHECK: if_nz call #1 ' encoding: [0x01,0x00,0xb0,0x5d]
' CHECK-INST: if_nz call #1


' CHECK: if_c_ne_z call #1 ' encoding: [0x01,0x00,0xb0,0x6d]
' CHECK-INST: if_c_ne_z call #1


' CHECK: if_nc_or_nz call #1 ' encoding: [0x01,0x00,0xb0,0x7d]
' CHECK-INST: if_nc_or_nz call #1


' CHECK: if_c_and_z call #1 ' encoding: [0x01,0x00,0xb0,0x8d]
' CHECK-INST: if_c_and_z call #1


' CHECK: if_c_eq_z call #1 ' encoding: [0x01,0x00,0xb0,0x9d]
' CHECK-INST: if_c_eq_z call #1


' CHECK: if_z call #1 ' encoding: [0x01,0x00,0xb0,0xad]
' CHECK-INST: if_z call #1


' CHECK: if_nc_or_z call #1 ' encoding: [0x01,0x00,0xb0,0xbd]
' CHECK-INST: if_nc_or_z call #1


' CHECK: if_c call #1 ' encoding: [0x01,0x00,0xb0,0xcd]
' CHECK-INST: if_c call #1


' CHECK: if_c_or_nz call #1 ' encoding: [0x01,0x00,0xb0,0xdd]
' CHECK-INST: if_c_or_nz call #1


' CHECK: if_c_or_z call #1 ' encoding: [0x01,0x00,0xb0,0xed]
' CHECK-INST: if_c_or_z call #1


' CHECK: call #1 ' encoding: [0x01,0x00,0xb0,0xfd]
' CHECK-INST: call #1


' CHECK: _ret_ call /#1 ' encoding: [0x01,0x00,0xa0,0x0d]
' CHECK-INST: _ret_ call /#1

