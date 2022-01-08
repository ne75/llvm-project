
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ cmps r0, r1
	if_nc_and_nz cmps r0, r1
	if_nc_and_z cmps r0, r1
	if_nc cmps r0, r1
	if_c_and_nz cmps r0, r1
	if_nz cmps r0, r1
	if_c_ne_z cmps r0, r1
	if_nc_or_nz cmps r0, r1
	if_c_and_z cmps r0, r1
	if_c_eq_z cmps r0, r1
	if_z cmps r0, r1
	if_nc_or_z cmps r0, r1
	if_c cmps r0, r1
	if_c_or_nz cmps r0, r1
	if_c_or_z cmps r0, r1
	cmps r0, r1
	cmps r0, #1
	_ret_ cmps r0, r1 wc
	_ret_ cmps r0, r1 wz
	_ret_ cmps r0, r1 wcz


' CHECK: _ret_ cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x02]
' CHECK-INST: _ret_ cmps r0, r1


' CHECK: if_nc_and_nz cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x12]
' CHECK-INST: if_nc_and_nz cmps r0, r1


' CHECK: if_nc_and_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x22]
' CHECK-INST: if_nc_and_z cmps r0, r1


' CHECK: if_nc cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x32]
' CHECK-INST: if_nc cmps r0, r1


' CHECK: if_c_and_nz cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x42]
' CHECK-INST: if_c_and_nz cmps r0, r1


' CHECK: if_nz cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x52]
' CHECK-INST: if_nz cmps r0, r1


' CHECK: if_c_ne_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x62]
' CHECK-INST: if_c_ne_z cmps r0, r1


' CHECK: if_nc_or_nz cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x72]
' CHECK-INST: if_nc_or_nz cmps r0, r1


' CHECK: if_c_and_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x82]
' CHECK-INST: if_c_and_z cmps r0, r1


' CHECK: if_c_eq_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0x92]
' CHECK-INST: if_c_eq_z cmps r0, r1


' CHECK: if_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xa2]
' CHECK-INST: if_z cmps r0, r1


' CHECK: if_nc_or_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xb2]
' CHECK-INST: if_nc_or_z cmps r0, r1


' CHECK: if_c cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xc2]
' CHECK-INST: if_c cmps r0, r1


' CHECK: if_c_or_nz cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xd2]
' CHECK-INST: if_c_or_nz cmps r0, r1


' CHECK: if_c_or_z cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xe2]
' CHECK-INST: if_c_or_z cmps r0, r1


' CHECK: cmps r0, r1 ' encoding: [0xd1,0xa1,0x43,0xf2]
' CHECK-INST: cmps r0, r1


' CHECK: cmps r0, #1 ' encoding: [0x01,0xa0,0x47,0xf2]
' CHECK-INST: cmps r0, #1


' CHECK: _ret_ cmps r0, r1 wc ' encoding: [0xd1,0xa1,0x53,0x02]
' CHECK-INST: _ret_ cmps r0, r1 wc


' CHECK: _ret_ cmps r0, r1 wz ' encoding: [0xd1,0xa1,0x4b,0x02]
' CHECK-INST: _ret_ cmps r0, r1 wz


' CHECK: _ret_ cmps r0, r1 wcz ' encoding: [0xd1,0xa1,0x5b,0x02]
' CHECK-INST: _ret_ cmps r0, r1 wcz

