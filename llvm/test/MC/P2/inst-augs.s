
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ augs #1
	if_nc_and_nz augs #1
	if_nc_and_z augs #1
	if_nc augs #1
	if_c_and_nz augs #1
	if_nz augs #1
	if_c_ne_z augs #1
	if_nc_or_nz augs #1
	if_c_and_z augs #1
	if_c_eq_z augs #1
	if_z augs #1
	if_nc_or_z augs #1
	if_c augs #1
	if_c_or_nz augs #1
	if_c_or_z augs #1
	augs #1


' CHECK: _ret_ augs #1 ' encoding: [0x01,0x00,0x00,0x0f]
' CHECK-INST: _ret_ augs #1


' CHECK: if_nc_and_nz augs #1 ' encoding: [0x01,0x00,0x00,0x1f]
' CHECK-INST: if_nc_and_nz augs #1


' CHECK: if_nc_and_z augs #1 ' encoding: [0x01,0x00,0x00,0x2f]
' CHECK-INST: if_nc_and_z augs #1


' CHECK: if_nc augs #1 ' encoding: [0x01,0x00,0x00,0x3f]
' CHECK-INST: if_nc augs #1


' CHECK: if_c_and_nz augs #1 ' encoding: [0x01,0x00,0x00,0x4f]
' CHECK-INST: if_c_and_nz augs #1


' CHECK: if_nz augs #1 ' encoding: [0x01,0x00,0x00,0x5f]
' CHECK-INST: if_nz augs #1


' CHECK: if_c_ne_z augs #1 ' encoding: [0x01,0x00,0x00,0x6f]
' CHECK-INST: if_c_ne_z augs #1


' CHECK: if_nc_or_nz augs #1 ' encoding: [0x01,0x00,0x00,0x7f]
' CHECK-INST: if_nc_or_nz augs #1


' CHECK: if_c_and_z augs #1 ' encoding: [0x01,0x00,0x00,0x8f]
' CHECK-INST: if_c_and_z augs #1


' CHECK: if_c_eq_z augs #1 ' encoding: [0x01,0x00,0x00,0x9f]
' CHECK-INST: if_c_eq_z augs #1


' CHECK: if_z augs #1 ' encoding: [0x01,0x00,0x00,0xaf]
' CHECK-INST: if_z augs #1


' CHECK: if_nc_or_z augs #1 ' encoding: [0x01,0x00,0x00,0xbf]
' CHECK-INST: if_nc_or_z augs #1


' CHECK: if_c augs #1 ' encoding: [0x01,0x00,0x00,0xcf]
' CHECK-INST: if_c augs #1


' CHECK: if_c_or_nz augs #1 ' encoding: [0x01,0x00,0x00,0xdf]
' CHECK-INST: if_c_or_nz augs #1


' CHECK: if_c_or_z augs #1 ' encoding: [0x01,0x00,0x00,0xef]
' CHECK-INST: if_c_or_z augs #1


' CHECK: augs #1 ' encoding: [0x01,0x00,0x00,0xff]
' CHECK-INST: augs #1

