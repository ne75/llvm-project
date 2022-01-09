
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wypin r0, r1
	if_nc_and_nz wypin r0, r1
	if_nc_and_z wypin r0, r1
	if_nc wypin r0, r1
	if_c_and_nz wypin r0, r1
	if_nz wypin r0, r1
	if_c_ne_z wypin r0, r1
	if_nc_or_nz wypin r0, r1
	if_c_and_z wypin r0, r1
	if_c_eq_z wypin r0, r1
	if_z wypin r0, r1
	if_nc_or_z wypin r0, r1
	if_c wypin r0, r1
	if_c_or_nz wypin r0, r1
	if_c_or_z wypin r0, r1
	wypin r0, r1
	wypin r0, #3
	wypin #3, r0
	wypin #3, #3
	_ret_ wypin r0, r1


' CHECK: _ret_ wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x0c]
' CHECK-INST: _ret_ wypin r0, r1


' CHECK: if_nc_and_nz wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x1c]
' CHECK-INST: if_nc_and_nz wypin r0, r1


' CHECK: if_nc_and_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x2c]
' CHECK-INST: if_nc_and_z wypin r0, r1


' CHECK: if_nc wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x3c]
' CHECK-INST: if_nc wypin r0, r1


' CHECK: if_c_and_nz wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x4c]
' CHECK-INST: if_c_and_nz wypin r0, r1


' CHECK: if_nz wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x5c]
' CHECK-INST: if_nz wypin r0, r1


' CHECK: if_c_ne_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x6c]
' CHECK-INST: if_c_ne_z wypin r0, r1


' CHECK: if_nc_or_nz wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x7c]
' CHECK-INST: if_nc_or_nz wypin r0, r1


' CHECK: if_c_and_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x8c]
' CHECK-INST: if_c_and_z wypin r0, r1


' CHECK: if_c_eq_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x9c]
' CHECK-INST: if_c_eq_z wypin r0, r1


' CHECK: if_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xac]
' CHECK-INST: if_z wypin r0, r1


' CHECK: if_nc_or_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xbc]
' CHECK-INST: if_nc_or_z wypin r0, r1


' CHECK: if_c wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xcc]
' CHECK-INST: if_c wypin r0, r1


' CHECK: if_c_or_nz wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xdc]
' CHECK-INST: if_c_or_nz wypin r0, r1


' CHECK: if_c_or_z wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xec]
' CHECK-INST: if_c_or_z wypin r0, r1


' CHECK: wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0xfc]
' CHECK-INST: wypin r0, r1


' CHECK: wypin r0, #3 ' encoding: [0x03,0xa0,0x27,0xfc]
' CHECK-INST: wypin r0, #3


' CHECK: wypin #3, r0 ' encoding: [0xd0,0x07,0x28,0xfc]
' CHECK-INST: wypin #3, r0


' CHECK: wypin #3, #3 ' encoding: [0x03,0x06,0x2c,0xfc]
' CHECK-INST: wypin #3, #3


' CHECK: _ret_ wypin r0, r1 ' encoding: [0xd1,0xa1,0x23,0x0c]
' CHECK-INST: _ret_ wypin r0, r1

