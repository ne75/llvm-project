
' RUN: llvm-mc -triple p2 -show-encoding < %s | FileCheck %s
' RUN: llvm-mc -filetype=obj -triple p2 < %s | llvm-objdump -d - | FileCheck --check-prefix=CHECK-INST %s

test:
	_ret_ waitct3
	if_nc_and_nz waitct3
	if_nc_and_z waitct3
	if_nc waitct3
	if_c_and_nz waitct3
	if_nz waitct3
	if_c_ne_z waitct3
	if_nc_or_nz waitct3
	if_c_and_z waitct3
	if_c_eq_z waitct3
	if_z waitct3
	if_nc_or_z waitct3
	if_c waitct3
	if_c_or_nz waitct3
	if_c_or_z waitct3
	waitct3
	_ret_ waitct3 wc
	_ret_ waitct3 wz
	_ret_ waitct3 wcz


' CHECK: _ret_ waitct3 ' encoding: [0x24,0x26,0x60,0x0d]
' CHECK-INST: _ret_ waitct3


' CHECK: if_nc_and_nz waitct3 ' encoding: [0x24,0x26,0x60,0x1d]
' CHECK-INST: if_nc_and_nz waitct3


' CHECK: if_nc_and_z waitct3 ' encoding: [0x24,0x26,0x60,0x2d]
' CHECK-INST: if_nc_and_z waitct3


' CHECK: if_nc waitct3 ' encoding: [0x24,0x26,0x60,0x3d]
' CHECK-INST: if_nc waitct3


' CHECK: if_c_and_nz waitct3 ' encoding: [0x24,0x26,0x60,0x4d]
' CHECK-INST: if_c_and_nz waitct3


' CHECK: if_nz waitct3 ' encoding: [0x24,0x26,0x60,0x5d]
' CHECK-INST: if_nz waitct3


' CHECK: if_c_ne_z waitct3 ' encoding: [0x24,0x26,0x60,0x6d]
' CHECK-INST: if_c_ne_z waitct3


' CHECK: if_nc_or_nz waitct3 ' encoding: [0x24,0x26,0x60,0x7d]
' CHECK-INST: if_nc_or_nz waitct3


' CHECK: if_c_and_z waitct3 ' encoding: [0x24,0x26,0x60,0x8d]
' CHECK-INST: if_c_and_z waitct3


' CHECK: if_c_eq_z waitct3 ' encoding: [0x24,0x26,0x60,0x9d]
' CHECK-INST: if_c_eq_z waitct3


' CHECK: if_z waitct3 ' encoding: [0x24,0x26,0x60,0xad]
' CHECK-INST: if_z waitct3


' CHECK: if_nc_or_z waitct3 ' encoding: [0x24,0x26,0x60,0xbd]
' CHECK-INST: if_nc_or_z waitct3


' CHECK: if_c waitct3 ' encoding: [0x24,0x26,0x60,0xcd]
' CHECK-INST: if_c waitct3


' CHECK: if_c_or_nz waitct3 ' encoding: [0x24,0x26,0x60,0xdd]
' CHECK-INST: if_c_or_nz waitct3


' CHECK: if_c_or_z waitct3 ' encoding: [0x24,0x26,0x60,0xed]
' CHECK-INST: if_c_or_z waitct3


' CHECK: waitct3 ' encoding: [0x24,0x26,0x60,0xfd]
' CHECK-INST: waitct3


' CHECK: _ret_ waitct3 wc ' encoding: [0x24,0x26,0x70,0x0d]
' CHECK-INST: _ret_ waitct3 wc


' CHECK: _ret_ waitct3 wz ' encoding: [0x24,0x26,0x68,0x0d]
' CHECK-INST: _ret_ waitct3 wz


' CHECK: _ret_ waitct3 wcz ' encoding: [0x24,0x26,0x78,0x0d]
' CHECK-INST: _ret_ waitct3 wcz

