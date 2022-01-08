
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ qmul r0, r1
	if_nc_and_nz qmul r0, r1
	if_nc_and_z qmul r0, r1
	if_nc qmul r0, r1
	if_c_and_nz qmul r0, r1
	if_nz qmul r0, r1
	if_c_ne_z qmul r0, r1
	if_nc_or_nz qmul r0, r1
	if_c_and_z qmul r0, r1
	if_c_eq_z qmul r0, r1
	if_z qmul r0, r1
	if_nc_or_z qmul r0, r1
	if_c qmul r0, r1
	if_c_or_nz qmul r0, r1
	if_c_or_z qmul r0, r1
	qmul r0, r1
	qmul r0, #3
	qmul #3, r0
	qmul #3, #3
	_ret_ qmul r0, r1


' CHECK: _ret_ qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0d]
' CHECK-INST: _ret_ qmul r0, r1


' CHECK: if_nc_and_nz qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x1d]
' CHECK-INST: if_nc_and_nz qmul r0, r1


' CHECK: if_nc_and_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x2d]
' CHECK-INST: if_nc_and_z qmul r0, r1


' CHECK: if_nc qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x3d]
' CHECK-INST: if_nc qmul r0, r1


' CHECK: if_c_and_nz qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x4d]
' CHECK-INST: if_c_and_nz qmul r0, r1


' CHECK: if_nz qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x5d]
' CHECK-INST: if_nz qmul r0, r1


' CHECK: if_c_ne_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x6d]
' CHECK-INST: if_c_ne_z qmul r0, r1


' CHECK: if_nc_or_nz qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x7d]
' CHECK-INST: if_nc_or_nz qmul r0, r1


' CHECK: if_c_and_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x8d]
' CHECK-INST: if_c_and_z qmul r0, r1


' CHECK: if_c_eq_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x9d]
' CHECK-INST: if_c_eq_z qmul r0, r1


' CHECK: if_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xad]
' CHECK-INST: if_z qmul r0, r1


' CHECK: if_nc_or_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xbd]
' CHECK-INST: if_nc_or_z qmul r0, r1


' CHECK: if_c qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xcd]
' CHECK-INST: if_c qmul r0, r1


' CHECK: if_c_or_nz qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xdd]
' CHECK-INST: if_c_or_nz qmul r0, r1


' CHECK: if_c_or_z qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xed]
' CHECK-INST: if_c_or_z qmul r0, r1


' CHECK: qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0xfd]
' CHECK-INST: qmul r0, r1


' CHECK: qmul r0, #3 ' encoding: [0x03,0xa0,0x07,0xfd]
' CHECK-INST: qmul r0, #3


' CHECK: qmul #3, r0 ' encoding: [0xd0,0x07,0x08,0xfd]
' CHECK-INST: qmul #3, r0


' CHECK: qmul #3, #3 ' encoding: [0x03,0x06,0x0c,0xfd]
' CHECK-INST: qmul #3, #3


' CHECK: _ret_ qmul r0, r1 ' encoding: [0xd1,0xa1,0x03,0x0d]
' CHECK-INST: _ret_ qmul r0, r1

