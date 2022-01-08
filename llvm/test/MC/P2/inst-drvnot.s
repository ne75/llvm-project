
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ drvnot r0
	if_nc_and_nz drvnot r0
	if_nc_and_z drvnot r0
	if_nc drvnot r0
	if_c_and_nz drvnot r0
	if_nz drvnot r0
	if_c_ne_z drvnot r0
	if_nc_or_nz drvnot r0
	if_c_and_z drvnot r0
	if_c_eq_z drvnot r0
	if_z drvnot r0
	if_nc_or_z drvnot r0
	if_c drvnot r0
	if_c_or_nz drvnot r0
	if_c_or_z drvnot r0
	drvnot r0
	drvnot #1
	_ret_ drvnot r0 wcz


' CHECK: _ret_ drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x0d]
' CHECK-INST: _ret_ drvnot r0


' CHECK: if_nc_and_nz drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x1d]
' CHECK-INST: if_nc_and_nz drvnot r0


' CHECK: if_nc_and_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x2d]
' CHECK-INST: if_nc_and_z drvnot r0


' CHECK: if_nc drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x3d]
' CHECK-INST: if_nc drvnot r0


' CHECK: if_c_and_nz drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x4d]
' CHECK-INST: if_c_and_nz drvnot r0


' CHECK: if_nz drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x5d]
' CHECK-INST: if_nz drvnot r0


' CHECK: if_c_ne_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x6d]
' CHECK-INST: if_c_ne_z drvnot r0


' CHECK: if_nc_or_nz drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x7d]
' CHECK-INST: if_nc_or_nz drvnot r0


' CHECK: if_c_and_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x8d]
' CHECK-INST: if_c_and_z drvnot r0


' CHECK: if_c_eq_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0x9d]
' CHECK-INST: if_c_eq_z drvnot r0


' CHECK: if_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xad]
' CHECK-INST: if_z drvnot r0


' CHECK: if_nc_or_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xbd]
' CHECK-INST: if_nc_or_z drvnot r0


' CHECK: if_c drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xcd]
' CHECK-INST: if_c drvnot r0


' CHECK: if_c_or_nz drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xdd]
' CHECK-INST: if_c_or_nz drvnot r0


' CHECK: if_c_or_z drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xed]
' CHECK-INST: if_c_or_z drvnot r0


' CHECK: drvnot r0 ' encoding: [0x5f,0xa0,0x63,0xfd]
' CHECK-INST: drvnot r0


' CHECK: drvnot #1 ' encoding: [0x5f,0x02,0x64,0xfd]
' CHECK-INST: drvnot #1


' CHECK: _ret_ drvnot r0 wcz ' encoding: [0x5f,0xa0,0x7b,0x0d]
' CHECK-INST: _ret_ drvnot r0 wcz

