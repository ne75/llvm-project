
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ addsx r0, r1
	if_nc_and_nz addsx r0, r1
	if_nc_and_z addsx r0, r1
	if_nc addsx r0, r1
	if_c_and_nz addsx r0, r1
	if_nz addsx r0, r1
	if_c_ne_z addsx r0, r1
	if_nc_or_nz addsx r0, r1
	if_c_and_z addsx r0, r1
	if_c_eq_z addsx r0, r1
	if_z addsx r0, r1
	if_nc_or_z addsx r0, r1
	if_c addsx r0, r1
	if_c_or_nz addsx r0, r1
	if_c_or_z addsx r0, r1
	addsx r0, r1
	addsx r0, #1
	_ret_ addsx r0, r1 wc
	_ret_ addsx r0, r1 wz
	_ret_ addsx r0, r1 wcz


' CHECK: _ret_ addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x01]
' CHECK-INST: _ret_ addsx r0, r1


' CHECK: if_nc_and_nz addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x11]
' CHECK-INST: if_nc_and_nz addsx r0, r1


' CHECK: if_nc_and_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x21]
' CHECK-INST: if_nc_and_z addsx r0, r1


' CHECK: if_nc addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x31]
' CHECK-INST: if_nc addsx r0, r1


' CHECK: if_c_and_nz addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x41]
' CHECK-INST: if_c_and_nz addsx r0, r1


' CHECK: if_nz addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x51]
' CHECK-INST: if_nz addsx r0, r1


' CHECK: if_c_ne_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x61]
' CHECK-INST: if_c_ne_z addsx r0, r1


' CHECK: if_nc_or_nz addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x71]
' CHECK-INST: if_nc_or_nz addsx r0, r1


' CHECK: if_c_and_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x81]
' CHECK-INST: if_c_and_z addsx r0, r1


' CHECK: if_c_eq_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0x91]
' CHECK-INST: if_c_eq_z addsx r0, r1


' CHECK: if_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xa1]
' CHECK-INST: if_z addsx r0, r1


' CHECK: if_nc_or_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xb1]
' CHECK-INST: if_nc_or_z addsx r0, r1


' CHECK: if_c addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xc1]
' CHECK-INST: if_c addsx r0, r1


' CHECK: if_c_or_nz addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xd1]
' CHECK-INST: if_c_or_nz addsx r0, r1


' CHECK: if_c_or_z addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xe1]
' CHECK-INST: if_c_or_z addsx r0, r1


' CHECK: addsx r0, r1 ' encoding: [0xd1,0xa1,0x63,0xf1]
' CHECK-INST: addsx r0, r1


' CHECK: addsx r0, #1 ' encoding: [0x01,0xa0,0x67,0xf1]
' CHECK-INST: addsx r0, #1


' CHECK: _ret_ addsx r0, r1 wc ' encoding: [0xd1,0xa1,0x73,0x01]
' CHECK-INST: _ret_ addsx r0, r1 wc


' CHECK: _ret_ addsx r0, r1 wz ' encoding: [0xd1,0xa1,0x6b,0x01]
' CHECK-INST: _ret_ addsx r0, r1 wz


' CHECK: _ret_ addsx r0, r1 wcz ' encoding: [0xd1,0xa1,0x7b,0x01]
' CHECK-INST: _ret_ addsx r0, r1 wcz

