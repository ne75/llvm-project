
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ setq2 r0
	if_nc_and_nz setq2 r0
	if_nc_and_z setq2 r0
	if_nc setq2 r0
	if_c_and_nz setq2 r0
	if_nz setq2 r0
	if_c_ne_z setq2 r0
	if_nc_or_nz setq2 r0
	if_c_and_z setq2 r0
	if_c_eq_z setq2 r0
	if_z setq2 r0
	if_nc_or_z setq2 r0
	if_c setq2 r0
	if_c_or_nz setq2 r0
	if_c_or_z setq2 r0
	setq2 r0
	_ret_ setq2 #1


' CHECK: _ret_ setq2 r0 ' encoding: [0x29,0xa0,0x63,0x0d]
' CHECK-INST: _ret_ setq2 r0


' CHECK: if_nc_and_nz setq2 r0 ' encoding: [0x29,0xa0,0x63,0x1d]
' CHECK-INST: if_nc_and_nz setq2 r0


' CHECK: if_nc_and_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0x2d]
' CHECK-INST: if_nc_and_z setq2 r0


' CHECK: if_nc setq2 r0 ' encoding: [0x29,0xa0,0x63,0x3d]
' CHECK-INST: if_nc setq2 r0


' CHECK: if_c_and_nz setq2 r0 ' encoding: [0x29,0xa0,0x63,0x4d]
' CHECK-INST: if_c_and_nz setq2 r0


' CHECK: if_nz setq2 r0 ' encoding: [0x29,0xa0,0x63,0x5d]
' CHECK-INST: if_nz setq2 r0


' CHECK: if_c_ne_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0x6d]
' CHECK-INST: if_c_ne_z setq2 r0


' CHECK: if_nc_or_nz setq2 r0 ' encoding: [0x29,0xa0,0x63,0x7d]
' CHECK-INST: if_nc_or_nz setq2 r0


' CHECK: if_c_and_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0x8d]
' CHECK-INST: if_c_and_z setq2 r0


' CHECK: if_c_eq_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0x9d]
' CHECK-INST: if_c_eq_z setq2 r0


' CHECK: if_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0xad]
' CHECK-INST: if_z setq2 r0


' CHECK: if_nc_or_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0xbd]
' CHECK-INST: if_nc_or_z setq2 r0


' CHECK: if_c setq2 r0 ' encoding: [0x29,0xa0,0x63,0xcd]
' CHECK-INST: if_c setq2 r0


' CHECK: if_c_or_nz setq2 r0 ' encoding: [0x29,0xa0,0x63,0xdd]
' CHECK-INST: if_c_or_nz setq2 r0


' CHECK: if_c_or_z setq2 r0 ' encoding: [0x29,0xa0,0x63,0xed]
' CHECK-INST: if_c_or_z setq2 r0


' CHECK: setq2 r0 ' encoding: [0x29,0xa0,0x63,0xfd]
' CHECK-INST: setq2 r0


' CHECK: _ret_ setq2 #1 ' encoding: [0x29,0x02,0x64,0x0d]
' CHECK-INST: _ret_ setq2 #1

