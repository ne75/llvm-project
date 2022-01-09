
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ wrnz r0
	if_nc_and_nz wrnz r0
	if_nc_and_z wrnz r0
	if_nc wrnz r0
	if_c_and_nz wrnz r0
	if_nz wrnz r0
	if_c_ne_z wrnz r0
	if_nc_or_nz wrnz r0
	if_c_and_z wrnz r0
	if_c_eq_z wrnz r0
	if_z wrnz r0
	if_nc_or_z wrnz r0
	if_c wrnz r0
	if_c_or_nz wrnz r0
	if_c_or_z wrnz r0
	wrnz r0


' CHECK: _ret_ wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x0d]
' CHECK-INST: _ret_ wrnz r0


' CHECK: if_nc_and_nz wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x1d]
' CHECK-INST: if_nc_and_nz wrnz r0


' CHECK: if_nc_and_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x2d]
' CHECK-INST: if_nc_and_z wrnz r0


' CHECK: if_nc wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x3d]
' CHECK-INST: if_nc wrnz r0


' CHECK: if_c_and_nz wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x4d]
' CHECK-INST: if_c_and_nz wrnz r0


' CHECK: if_nz wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x5d]
' CHECK-INST: if_nz wrnz r0


' CHECK: if_c_ne_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x6d]
' CHECK-INST: if_c_ne_z wrnz r0


' CHECK: if_nc_or_nz wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x7d]
' CHECK-INST: if_nc_or_nz wrnz r0


' CHECK: if_c_and_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x8d]
' CHECK-INST: if_c_and_z wrnz r0


' CHECK: if_c_eq_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0x9d]
' CHECK-INST: if_c_eq_z wrnz r0


' CHECK: if_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xad]
' CHECK-INST: if_z wrnz r0


' CHECK: if_nc_or_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xbd]
' CHECK-INST: if_nc_or_z wrnz r0


' CHECK: if_c wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xcd]
' CHECK-INST: if_c wrnz r0


' CHECK: if_c_or_nz wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xdd]
' CHECK-INST: if_c_or_nz wrnz r0


' CHECK: if_c_or_z wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xed]
' CHECK-INST: if_c_or_z wrnz r0


' CHECK: wrnz r0 ' encoding: [0x6f,0xa0,0x63,0xfd]
' CHECK-INST: wrnz r0

