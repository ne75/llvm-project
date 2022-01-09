
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitct1
	if_nc_and_nz waitct1
	if_nc_and_z waitct1
	if_nc waitct1
	if_c_and_nz waitct1
	if_nz waitct1
	if_c_ne_z waitct1
	if_nc_or_nz waitct1
	if_c_and_z waitct1
	if_c_eq_z waitct1
	if_z waitct1
	if_nc_or_z waitct1
	if_c waitct1
	if_c_or_nz waitct1
	if_c_or_z waitct1
	waitct1
	_ret_ waitct1 wc
	_ret_ waitct1 wz
	_ret_ waitct1 wcz


' CHECK: _ret_ waitct1 ' encoding: [0x24,0x22,0x60,0x0d]
' CHECK-INST: _ret_ waitct1


' CHECK: if_nc_and_nz waitct1 ' encoding: [0x24,0x22,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitct1


' CHECK: if_nc_and_z waitct1 ' encoding: [0x24,0x22,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitct1


' CHECK: if_nc waitct1 ' encoding: [0x24,0x22,0x60,0x3d]
' CHECK-INST: if_nc waitct1


' CHECK: if_c_and_nz waitct1 ' encoding: [0x24,0x22,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitct1


' CHECK: if_nz waitct1 ' encoding: [0x24,0x22,0x60,0x5d]
' CHECK-INST: if_nz waitct1


' CHECK: if_c_ne_z waitct1 ' encoding: [0x24,0x22,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitct1


' CHECK: if_nc_or_nz waitct1 ' encoding: [0x24,0x22,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitct1


' CHECK: if_c_and_z waitct1 ' encoding: [0x24,0x22,0x60,0x8d]
' CHECK-INST: if_c_and_z waitct1


' CHECK: if_c_eq_z waitct1 ' encoding: [0x24,0x22,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitct1


' CHECK: if_z waitct1 ' encoding: [0x24,0x22,0x60,0xad]
' CHECK-INST: if_z waitct1


' CHECK: if_nc_or_z waitct1 ' encoding: [0x24,0x22,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitct1


' CHECK: if_c waitct1 ' encoding: [0x24,0x22,0x60,0xcd]
' CHECK-INST: if_c waitct1


' CHECK: if_c_or_nz waitct1 ' encoding: [0x24,0x22,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitct1


' CHECK: if_c_or_z waitct1 ' encoding: [0x24,0x22,0x60,0xed]
' CHECK-INST: if_c_or_z waitct1


' CHECK: waitct1 ' encoding: [0x24,0x22,0x60,0xfd]
' CHECK-INST: waitct1


' CHECK: _ret_ waitct1 wc ' encoding: [0x24,0x22,0x70,0x0d]
' CHECK-INST: _ret_ waitct1 wc


' CHECK: _ret_ waitct1 wz ' encoding: [0x24,0x22,0x68,0x0d]
' CHECK-INST: _ret_ waitct1 wz


' CHECK: _ret_ waitct1 wcz ' encoding: [0x24,0x22,0x78,0x0d]
' CHECK-INST: _ret_ waitct1 wcz

