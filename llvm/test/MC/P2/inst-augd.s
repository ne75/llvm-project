
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ augd #123456
	if_nc_and_nz augd #123456
	if_nc_and_z augd #123456
	if_nc augd #123456
	if_c_and_nz augd #123456
	if_nz augd #123456
	if_c_ne_z augd #123456
	if_nc_or_nz augd #123456
	if_c_and_z augd #123456
	if_c_eq_z augd #123456
	if_z augd #123456
	if_nc_or_z augd #123456
	if_c augd #123456
	if_c_or_nz augd #123456
	if_c_or_z augd #123456
	augd #123456


' CHECK: _ret_ augd #123456 ' encoding: [0x40,0xe2,0x81,0x0f]
' CHECK-INST: _ret_ augd #123456


' CHECK: if_nc_and_nz augd #123456 ' encoding: [0x40,0xe2,0x81,0x1f]
' CHECK-INST: if_nc_and_nz augd #123456


' CHECK: if_nc_and_z augd #123456 ' encoding: [0x40,0xe2,0x81,0x2f]
' CHECK-INST: if_nc_and_z augd #123456


' CHECK: if_nc augd #123456 ' encoding: [0x40,0xe2,0x81,0x3f]
' CHECK-INST: if_nc augd #123456


' CHECK: if_c_and_nz augd #123456 ' encoding: [0x40,0xe2,0x81,0x4f]
' CHECK-INST: if_c_and_nz augd #123456


' CHECK: if_nz augd #123456 ' encoding: [0x40,0xe2,0x81,0x5f]
' CHECK-INST: if_nz augd #123456


' CHECK: if_c_ne_z augd #123456 ' encoding: [0x40,0xe2,0x81,0x6f]
' CHECK-INST: if_c_ne_z augd #123456


' CHECK: if_nc_or_nz augd #123456 ' encoding: [0x40,0xe2,0x81,0x7f]
' CHECK-INST: if_nc_or_nz augd #123456


' CHECK: if_c_and_z augd #123456 ' encoding: [0x40,0xe2,0x81,0x8f]
' CHECK-INST: if_c_and_z augd #123456


' CHECK: if_c_eq_z augd #123456 ' encoding: [0x40,0xe2,0x81,0x9f]
' CHECK-INST: if_c_eq_z augd #123456


' CHECK: if_z augd #123456 ' encoding: [0x40,0xe2,0x81,0xaf]
' CHECK-INST: if_z augd #123456


' CHECK: if_nc_or_z augd #123456 ' encoding: [0x40,0xe2,0x81,0xbf]
' CHECK-INST: if_nc_or_z augd #123456


' CHECK: if_c augd #123456 ' encoding: [0x40,0xe2,0x81,0xcf]
' CHECK-INST: if_c augd #123456


' CHECK: if_c_or_nz augd #123456 ' encoding: [0x40,0xe2,0x81,0xdf]
' CHECK-INST: if_c_or_nz augd #123456


' CHECK: if_c_or_z augd #123456 ' encoding: [0x40,0xe2,0x81,0xef]
' CHECK-INST: if_c_or_z augd #123456


' CHECK: augd #123456 ' encoding: [0x40,0xe2,0x81,0xff]
' CHECK-INST: augd #123456

