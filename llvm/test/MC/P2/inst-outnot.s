
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ outnot r0
	if_nc_and_nz outnot r0
	if_nc_and_z outnot r0
	if_nc outnot r0
	if_c_and_nz outnot r0
	if_nz outnot r0
	if_c_ne_z outnot r0
	if_nc_or_nz outnot r0
	if_c_and_z outnot r0
	if_c_eq_z outnot r0
	if_z outnot r0
	if_nc_or_z outnot r0
	if_c outnot r0
	if_c_or_nz outnot r0
	if_c_or_z outnot r0
	outnot r0
	outnot #1
	_ret_ outnot r0 wcz


' CHECK: _ret_ outnot r0 ' encoding: [0x4f,0xa0,0x63,0x0d]
' CHECK-INST: _ret_ outnot r0


' CHECK: if_nc_and_nz outnot r0 ' encoding: [0x4f,0xa0,0x63,0x1d]
' CHECK-INST: if_nc_and_nz outnot r0


' CHECK: if_nc_and_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0x2d]
' CHECK-INST: if_nc_and_z outnot r0


' CHECK: if_nc outnot r0 ' encoding: [0x4f,0xa0,0x63,0x3d]
' CHECK-INST: if_nc outnot r0


' CHECK: if_c_and_nz outnot r0 ' encoding: [0x4f,0xa0,0x63,0x4d]
' CHECK-INST: if_c_and_nz outnot r0


' CHECK: if_nz outnot r0 ' encoding: [0x4f,0xa0,0x63,0x5d]
' CHECK-INST: if_nz outnot r0


' CHECK: if_c_ne_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0x6d]
' CHECK-INST: if_c_ne_z outnot r0


' CHECK: if_nc_or_nz outnot r0 ' encoding: [0x4f,0xa0,0x63,0x7d]
' CHECK-INST: if_nc_or_nz outnot r0


' CHECK: if_c_and_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0x8d]
' CHECK-INST: if_c_and_z outnot r0


' CHECK: if_c_eq_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0x9d]
' CHECK-INST: if_c_eq_z outnot r0


' CHECK: if_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0xad]
' CHECK-INST: if_z outnot r0


' CHECK: if_nc_or_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0xbd]
' CHECK-INST: if_nc_or_z outnot r0


' CHECK: if_c outnot r0 ' encoding: [0x4f,0xa0,0x63,0xcd]
' CHECK-INST: if_c outnot r0


' CHECK: if_c_or_nz outnot r0 ' encoding: [0x4f,0xa0,0x63,0xdd]
' CHECK-INST: if_c_or_nz outnot r0


' CHECK: if_c_or_z outnot r0 ' encoding: [0x4f,0xa0,0x63,0xed]
' CHECK-INST: if_c_or_z outnot r0


' CHECK: outnot r0 ' encoding: [0x4f,0xa0,0x63,0xfd]
' CHECK-INST: outnot r0


' CHECK: outnot #1 ' encoding: [0x4f,0x02,0x64,0xfd]
' CHECK-INST: outnot #1


' CHECK: _ret_ outnot r0 wcz ' encoding: [0x4f,0xa0,0x7b,0x0d]
' CHECK-INST: _ret_ outnot r0 wcz

