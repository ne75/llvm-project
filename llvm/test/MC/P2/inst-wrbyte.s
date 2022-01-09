
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrbyte r0, r1
	if_nc_and_nz wrbyte r0, r1
	if_nc_and_z wrbyte r0, r1
	if_nc wrbyte r0, r1
	if_c_and_nz wrbyte r0, r1
	if_nz wrbyte r0, r1
	if_c_ne_z wrbyte r0, r1
	if_nc_or_nz wrbyte r0, r1
	if_c_and_z wrbyte r0, r1
	if_c_eq_z wrbyte r0, r1
	if_z wrbyte r0, r1
	if_nc_or_z wrbyte r0, r1
	if_c wrbyte r0, r1
	if_c_or_nz wrbyte r0, r1
	if_c_or_z wrbyte r0, r1
	wrbyte r0, r1
	wrbyte r0, #3
	wrbyte #3, r0
	wrbyte #3, #3
	_ret_ wrbyte r0, r1


' CHECK: _ret_ wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x0c]
' CHECK-INST: _ret_ wrbyte r0, r1


' CHECK: if_nc_and_nz wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x1c]
' CHECK-INST: if_nc_and_nz wrbyte r0, r1


' CHECK: if_nc_and_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x2c]
' CHECK-INST: if_nc_and_z wrbyte r0, r1


' CHECK: if_nc wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x3c]
' CHECK-INST: if_nc wrbyte r0, r1


' CHECK: if_c_and_nz wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x4c]
' CHECK-INST: if_c_and_nz wrbyte r0, r1


' CHECK: if_nz wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x5c]
' CHECK-INST: if_nz wrbyte r0, r1


' CHECK: if_c_ne_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x6c]
' CHECK-INST: if_c_ne_z wrbyte r0, r1


' CHECK: if_nc_or_nz wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x7c]
' CHECK-INST: if_nc_or_nz wrbyte r0, r1


' CHECK: if_c_and_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x8c]
' CHECK-INST: if_c_and_z wrbyte r0, r1


' CHECK: if_c_eq_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x9c]
' CHECK-INST: if_c_eq_z wrbyte r0, r1


' CHECK: if_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xac]
' CHECK-INST: if_z wrbyte r0, r1


' CHECK: if_nc_or_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xbc]
' CHECK-INST: if_nc_or_z wrbyte r0, r1


' CHECK: if_c wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xcc]
' CHECK-INST: if_c wrbyte r0, r1


' CHECK: if_c_or_nz wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xdc]
' CHECK-INST: if_c_or_nz wrbyte r0, r1


' CHECK: if_c_or_z wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xec]
' CHECK-INST: if_c_or_z wrbyte r0, r1


' CHECK: wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0xfc]
' CHECK-INST: wrbyte r0, r1


' CHECK: wrbyte r0, #3 ' encoding: [0x03,0xa0,0x47,0xfc]
' CHECK-INST: wrbyte r0, #3


' CHECK: wrbyte #3, r0 ' encoding: [0xd0,0x07,0x48,0xfc]
' CHECK-INST: wrbyte #3, r0


' CHECK: wrbyte #3, #3 ' encoding: [0x03,0x06,0x4c,0xfc]
' CHECK-INST: wrbyte #3, #3


' CHECK: _ret_ wrbyte r0, r1 ' encoding: [0xd1,0xa1,0x43,0x0c]
' CHECK-INST: _ret_ wrbyte r0, r1

