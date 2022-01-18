
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ augs #123456
	if_nc_and_nz augs #123456
	if_nc_and_z augs #123456
	if_nc augs #123456
	if_c_and_nz augs #123456
	if_nz augs #123456
	if_c_ne_z augs #123456
	if_nc_or_nz augs #123456
	if_c_and_z augs #123456
	if_c_eq_z augs #123456
	if_z augs #123456
	if_nc_or_z augs #123456
	if_c augs #123456
	if_c_or_nz augs #123456
	if_c_or_z augs #123456
	augs #123456


' CHECK: _ret_ augs #123456 ' encoding: [0x40,0xe2,0x01,0x0f]
' CHECK-INST: _ret_ augs #123456


' CHECK: if_nc_and_nz augs #123456 ' encoding: [0x40,0xe2,0x01,0x1f]
' CHECK-INST: if_nc_and_nz augs #123456


' CHECK: if_nc_and_z augs #123456 ' encoding: [0x40,0xe2,0x01,0x2f]
' CHECK-INST: if_nc_and_z augs #123456


' CHECK: if_nc augs #123456 ' encoding: [0x40,0xe2,0x01,0x3f]
' CHECK-INST: if_nc augs #123456


' CHECK: if_c_and_nz augs #123456 ' encoding: [0x40,0xe2,0x01,0x4f]
' CHECK-INST: if_c_and_nz augs #123456


' CHECK: if_nz augs #123456 ' encoding: [0x40,0xe2,0x01,0x5f]
' CHECK-INST: if_nz augs #123456


' CHECK: if_c_ne_z augs #123456 ' encoding: [0x40,0xe2,0x01,0x6f]
' CHECK-INST: if_c_ne_z augs #123456


' CHECK: if_nc_or_nz augs #123456 ' encoding: [0x40,0xe2,0x01,0x7f]
' CHECK-INST: if_nc_or_nz augs #123456


' CHECK: if_c_and_z augs #123456 ' encoding: [0x40,0xe2,0x01,0x8f]
' CHECK-INST: if_c_and_z augs #123456


' CHECK: if_c_eq_z augs #123456 ' encoding: [0x40,0xe2,0x01,0x9f]
' CHECK-INST: if_c_eq_z augs #123456


' CHECK: if_z augs #123456 ' encoding: [0x40,0xe2,0x01,0xaf]
' CHECK-INST: if_z augs #123456


' CHECK: if_nc_or_z augs #123456 ' encoding: [0x40,0xe2,0x01,0xbf]
' CHECK-INST: if_nc_or_z augs #123456


' CHECK: if_c augs #123456 ' encoding: [0x40,0xe2,0x01,0xcf]
' CHECK-INST: if_c augs #123456


' CHECK: if_c_or_nz augs #123456 ' encoding: [0x40,0xe2,0x01,0xdf]
' CHECK-INST: if_c_or_nz augs #123456


' CHECK: if_c_or_z augs #123456 ' encoding: [0x40,0xe2,0x01,0xef]
' CHECK-INST: if_c_or_z augs #123456


' CHECK: augs #123456 ' encoding: [0x40,0xe2,0x01,0xff]
' CHECK-INST: augs #123456

