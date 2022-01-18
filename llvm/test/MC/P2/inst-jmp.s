
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ jmp #1
	if_nc_and_nz jmp #1
	if_nc_and_z jmp #1
	if_nc jmp #1
	if_c_and_nz jmp #1
	if_nz jmp #1
	if_c_ne_z jmp #1
	if_nc_or_nz jmp #1
	if_c_and_z jmp #1
	if_c_eq_z jmp #1
	if_z jmp #1
	if_nc_or_z jmp #1
	if_c jmp #1
	if_c_or_nz jmp #1
	if_c_or_z jmp #1
	jmp #1
	_ret_ jmp #\1


' CHECK: _ret_ jmp #1 ' encoding: [0x01,0x00,0x90,0x0d]
' CHECK-INST: _ret_ jmp #1


' CHECK: if_nc_and_nz jmp #1 ' encoding: [0x01,0x00,0x90,0x1d]
' CHECK-INST: if_nc_and_nz jmp #1


' CHECK: if_nc_and_z jmp #1 ' encoding: [0x01,0x00,0x90,0x2d]
' CHECK-INST: if_nc_and_z jmp #1


' CHECK: if_nc jmp #1 ' encoding: [0x01,0x00,0x90,0x3d]
' CHECK-INST: if_nc jmp #1


' CHECK: if_c_and_nz jmp #1 ' encoding: [0x01,0x00,0x90,0x4d]
' CHECK-INST: if_c_and_nz jmp #1


' CHECK: if_nz jmp #1 ' encoding: [0x01,0x00,0x90,0x5d]
' CHECK-INST: if_nz jmp #1


' CHECK: if_c_ne_z jmp #1 ' encoding: [0x01,0x00,0x90,0x6d]
' CHECK-INST: if_c_ne_z jmp #1


' CHECK: if_nc_or_nz jmp #1 ' encoding: [0x01,0x00,0x90,0x7d]
' CHECK-INST: if_nc_or_nz jmp #1


' CHECK: if_c_and_z jmp #1 ' encoding: [0x01,0x00,0x90,0x8d]
' CHECK-INST: if_c_and_z jmp #1


' CHECK: if_c_eq_z jmp #1 ' encoding: [0x01,0x00,0x90,0x9d]
' CHECK-INST: if_c_eq_z jmp #1


' CHECK: if_z jmp #1 ' encoding: [0x01,0x00,0x90,0xad]
' CHECK-INST: if_z jmp #1


' CHECK: if_nc_or_z jmp #1 ' encoding: [0x01,0x00,0x90,0xbd]
' CHECK-INST: if_nc_or_z jmp #1


' CHECK: if_c jmp #1 ' encoding: [0x01,0x00,0x90,0xcd]
' CHECK-INST: if_c jmp #1


' CHECK: if_c_or_nz jmp #1 ' encoding: [0x01,0x00,0x90,0xdd]
' CHECK-INST: if_c_or_nz jmp #1


' CHECK: if_c_or_z jmp #1 ' encoding: [0x01,0x00,0x90,0xed]
' CHECK-INST: if_c_or_z jmp #1


' CHECK: jmp #1 ' encoding: [0x01,0x00,0x90,0xfd]
' CHECK-INST: jmp #1


' CHECK: _ret_ jmp #\1 ' encoding: [0x01,0x00,0x80,0x0d]
' CHECK-INST: _ret_ jmp #\1

