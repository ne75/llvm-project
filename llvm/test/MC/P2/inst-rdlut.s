
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ rdlut r0, r1
	if_nc_and_nz rdlut r0, r1
	if_nc_and_z rdlut r0, r1
	if_nc rdlut r0, r1
	if_c_and_nz rdlut r0, r1
	if_nz rdlut r0, r1
	if_c_ne_z rdlut r0, r1
	if_nc_or_nz rdlut r0, r1
	if_c_and_z rdlut r0, r1
	if_c_eq_z rdlut r0, r1
	if_z rdlut r0, r1
	if_nc_or_z rdlut r0, r1
	if_c rdlut r0, r1
	if_c_or_nz rdlut r0, r1
	if_c_or_z rdlut r0, r1
	rdlut r0, r1
	rdlut r0, #1
	_ret_ rdlut r0, r1 wc
	_ret_ rdlut r0, r1 wz
	_ret_ rdlut r0, r1 wcz


' CHECK: _ret_ rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x0a]
' CHECK-INST: _ret_ rdlut r0, r1


' CHECK: if_nc_and_nz rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x1a]
' CHECK-INST: if_nc_and_nz rdlut r0, r1


' CHECK: if_nc_and_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x2a]
' CHECK-INST: if_nc_and_z rdlut r0, r1


' CHECK: if_nc rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x3a]
' CHECK-INST: if_nc rdlut r0, r1


' CHECK: if_c_and_nz rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x4a]
' CHECK-INST: if_c_and_nz rdlut r0, r1


' CHECK: if_nz rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x5a]
' CHECK-INST: if_nz rdlut r0, r1


' CHECK: if_c_ne_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x6a]
' CHECK-INST: if_c_ne_z rdlut r0, r1


' CHECK: if_nc_or_nz rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x7a]
' CHECK-INST: if_nc_or_nz rdlut r0, r1


' CHECK: if_c_and_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x8a]
' CHECK-INST: if_c_and_z rdlut r0, r1


' CHECK: if_c_eq_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0x9a]
' CHECK-INST: if_c_eq_z rdlut r0, r1


' CHECK: if_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xaa]
' CHECK-INST: if_z rdlut r0, r1


' CHECK: if_nc_or_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xba]
' CHECK-INST: if_nc_or_z rdlut r0, r1


' CHECK: if_c rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xca]
' CHECK-INST: if_c rdlut r0, r1


' CHECK: if_c_or_nz rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xda]
' CHECK-INST: if_c_or_nz rdlut r0, r1


' CHECK: if_c_or_z rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xea]
' CHECK-INST: if_c_or_z rdlut r0, r1


' CHECK: rdlut r0, r1 ' encoding: [0xd1,0xa1,0xa3,0xfa]
' CHECK-INST: rdlut r0, r1


' CHECK: rdlut r0, #1 ' encoding: [0x01,0xa0,0xa7,0xfa]
' CHECK-INST: rdlut r0, #1


' CHECK: _ret_ rdlut r0, r1 wc ' encoding: [0xd1,0xa1,0xb3,0x0a]
' CHECK-INST: _ret_ rdlut r0, r1 wc


' CHECK: _ret_ rdlut r0, r1 wz ' encoding: [0xd1,0xa1,0xab,0x0a]
' CHECK-INST: _ret_ rdlut r0, r1 wz


' CHECK: _ret_ rdlut r0, r1 wcz ' encoding: [0xd1,0xa1,0xbb,0x0a]
' CHECK-INST: _ret_ rdlut r0, r1 wcz

