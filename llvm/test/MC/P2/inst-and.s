
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ and r0, r1
	if_nc_and_nz and r0, r1
	if_nc_and_z and r0, r1
	if_nc and r0, r1
	if_c_and_nz and r0, r1
	if_nz and r0, r1
	if_c_ne_z and r0, r1
	if_nc_or_nz and r0, r1
	if_c_and_z and r0, r1
	if_c_eq_z and r0, r1
	if_z and r0, r1
	if_nc_or_z and r0, r1
	if_c and r0, r1
	if_c_or_nz and r0, r1
	if_c_or_z and r0, r1
	and r0, r1
	and r0, #1
	_ret_ and r0, r1 wc
	_ret_ and r0, r1 wz
	_ret_ and r0, r1 wcz


' CHECK: _ret_ and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x05]
' CHECK-INST: _ret_ and r0, r1


' CHECK: if_nc_and_nz and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x15]
' CHECK-INST: if_nc_and_nz and r0, r1


' CHECK: if_nc_and_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x25]
' CHECK-INST: if_nc_and_z and r0, r1


' CHECK: if_nc and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x35]
' CHECK-INST: if_nc and r0, r1


' CHECK: if_c_and_nz and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x45]
' CHECK-INST: if_c_and_nz and r0, r1


' CHECK: if_nz and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x55]
' CHECK-INST: if_nz and r0, r1


' CHECK: if_c_ne_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x65]
' CHECK-INST: if_c_ne_z and r0, r1


' CHECK: if_nc_or_nz and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x75]
' CHECK-INST: if_nc_or_nz and r0, r1


' CHECK: if_c_and_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x85]
' CHECK-INST: if_c_and_z and r0, r1


' CHECK: if_c_eq_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0x95]
' CHECK-INST: if_c_eq_z and r0, r1


' CHECK: if_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xa5]
' CHECK-INST: if_z and r0, r1


' CHECK: if_nc_or_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xb5]
' CHECK-INST: if_nc_or_z and r0, r1


' CHECK: if_c and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xc5]
' CHECK-INST: if_c and r0, r1


' CHECK: if_c_or_nz and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xd5]
' CHECK-INST: if_c_or_nz and r0, r1


' CHECK: if_c_or_z and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xe5]
' CHECK-INST: if_c_or_z and r0, r1


' CHECK: and r0, r1 ' encoding: [0xd1,0xa1,0x03,0xf5]
' CHECK-INST: and r0, r1


' CHECK: and r0, #1 ' encoding: [0x01,0xa0,0x07,0xf5]
' CHECK-INST: and r0, #1


' CHECK: _ret_ and r0, r1 wc ' encoding: [0xd1,0xa1,0x13,0x05]
' CHECK-INST: _ret_ and r0, r1 wc


' CHECK: _ret_ and r0, r1 wz ' encoding: [0xd1,0xa1,0x0b,0x05]
' CHECK-INST: _ret_ and r0, r1 wz


' CHECK: _ret_ and r0, r1 wcz ' encoding: [0xd1,0xa1,0x1b,0x05]
' CHECK-INST: _ret_ and r0, r1 wcz

