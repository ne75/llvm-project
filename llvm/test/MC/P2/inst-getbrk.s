
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ getbrk r0 wc
	_ret_ getbrk r0 wc
	if_nc_and_nz getbrk r0 wc
	if_nc_and_z getbrk r0 wc
	if_nc getbrk r0 wc
	if_c_and_nz getbrk r0 wc
	if_nz getbrk r0 wc
	if_c_ne_z getbrk r0 wc
	if_nc_or_nz getbrk r0 wc
	if_c_and_z getbrk r0 wc
	if_c_eq_z getbrk r0 wc
	if_z getbrk r0 wc
	if_nc_or_z getbrk r0 wc
	if_c getbrk r0 wc
	if_c_or_nz getbrk r0 wc
	if_c_or_z getbrk r0 wc
	getbrk r0 wc


' CHECK: _ret_ getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x0d]
' CHECK-INST: _ret_ getbrk r0 wc


' CHECK: _ret_ getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x0d]
' CHECK-INST: _ret_ getbrk r0 wc


' CHECK: if_nc_and_nz getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x1d]
' CHECK-INST: if_nc_and_nz getbrk r0 wc


' CHECK: if_nc_and_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x2d]
' CHECK-INST: if_nc_and_z getbrk r0 wc


' CHECK: if_nc getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x3d]
' CHECK-INST: if_nc getbrk r0 wc


' CHECK: if_c_and_nz getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x4d]
' CHECK-INST: if_c_and_nz getbrk r0 wc


' CHECK: if_nz getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x5d]
' CHECK-INST: if_nz getbrk r0 wc


' CHECK: if_c_ne_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x6d]
' CHECK-INST: if_c_ne_z getbrk r0 wc


' CHECK: if_nc_or_nz getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x7d]
' CHECK-INST: if_nc_or_nz getbrk r0 wc


' CHECK: if_c_and_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x8d]
' CHECK-INST: if_c_and_z getbrk r0 wc


' CHECK: if_c_eq_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0x9d]
' CHECK-INST: if_c_eq_z getbrk r0 wc


' CHECK: if_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xad]
' CHECK-INST: if_z getbrk r0 wc


' CHECK: if_nc_or_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xbd]
' CHECK-INST: if_nc_or_z getbrk r0 wc


' CHECK: if_c getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xcd]
' CHECK-INST: if_c getbrk r0 wc


' CHECK: if_c_or_nz getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xdd]
' CHECK-INST: if_c_or_nz getbrk r0 wc


' CHECK: if_c_or_z getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xed]
' CHECK-INST: if_c_or_z getbrk r0 wc


' CHECK: getbrk r0 wc ' encoding: [0x35,0xa0,0x73,0xfd]
' CHECK-INST: getbrk r0 wc

