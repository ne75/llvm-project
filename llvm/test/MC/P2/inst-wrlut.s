
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrlut r0, r1
	if_nc_and_nz wrlut r0, r1
	if_nc_and_z wrlut r0, r1
	if_nc wrlut r0, r1
	if_c_and_nz wrlut r0, r1
	if_nz wrlut r0, r1
	if_c_ne_z wrlut r0, r1
	if_nc_or_nz wrlut r0, r1
	if_c_and_z wrlut r0, r1
	if_c_eq_z wrlut r0, r1
	if_z wrlut r0, r1
	if_nc_or_z wrlut r0, r1
	if_c wrlut r0, r1
	if_c_or_nz wrlut r0, r1
	if_c_or_z wrlut r0, r1
	wrlut r0, r1
	wrlut r0, #3
	wrlut #3, r0
	wrlut #3, #3
	_ret_ wrlut r0, r1


' CHECK: _ret_ wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x0c]
' CHECK-INST: _ret_ wrlut r0, r1


' CHECK: if_nc_and_nz wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x1c]
' CHECK-INST: if_nc_and_nz wrlut r0, r1


' CHECK: if_nc_and_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x2c]
' CHECK-INST: if_nc_and_z wrlut r0, r1


' CHECK: if_nc wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x3c]
' CHECK-INST: if_nc wrlut r0, r1


' CHECK: if_c_and_nz wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x4c]
' CHECK-INST: if_c_and_nz wrlut r0, r1


' CHECK: if_nz wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x5c]
' CHECK-INST: if_nz wrlut r0, r1


' CHECK: if_c_ne_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x6c]
' CHECK-INST: if_c_ne_z wrlut r0, r1


' CHECK: if_nc_or_nz wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x7c]
' CHECK-INST: if_nc_or_nz wrlut r0, r1


' CHECK: if_c_and_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x8c]
' CHECK-INST: if_c_and_z wrlut r0, r1


' CHECK: if_c_eq_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x9c]
' CHECK-INST: if_c_eq_z wrlut r0, r1


' CHECK: if_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xac]
' CHECK-INST: if_z wrlut r0, r1


' CHECK: if_nc_or_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xbc]
' CHECK-INST: if_nc_or_z wrlut r0, r1


' CHECK: if_c wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xcc]
' CHECK-INST: if_c wrlut r0, r1


' CHECK: if_c_or_nz wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xdc]
' CHECK-INST: if_c_or_nz wrlut r0, r1


' CHECK: if_c_or_z wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xec]
' CHECK-INST: if_c_or_z wrlut r0, r1


' CHECK: wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0xfc]
' CHECK-INST: wrlut r0, r1


' CHECK: wrlut r0, #3 ' encoding: [0x03,0xa0,0x37,0xfc]
' CHECK-INST: wrlut r0, #3


' CHECK: wrlut #3, r0 ' encoding: [0xd0,0x07,0x38,0xfc]
' CHECK-INST: wrlut #3, r0


' CHECK: wrlut #3, #3 ' encoding: [0x03,0x06,0x3c,0xfc]
' CHECK-INST: wrlut #3, #3


' CHECK: _ret_ wrlut r0, r1 ' encoding: [0xd1,0xa1,0x33,0x0c]
' CHECK-INST: _ret_ wrlut r0, r1

