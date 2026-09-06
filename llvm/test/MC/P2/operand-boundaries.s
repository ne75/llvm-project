# RUN: llvm-mc -triple=p2 -show-encoding %s | FileCheck %s
# Long immediate lowering must preserve ## even when the numeric value fits.
rdlong r0, ##256
# CHECK: augs #0
# CHECK-NEXT: rdlong r0, ptra[0]
_ret_ mov r0, ##1000
# CHECK: augs #1
# CHECK-NEXT: _ret_{{.*}}mov r0, #488
tjz r0, #-1
# CHECK: tjz r0, #-1
setnib r0, ##1000, #7
# CHECK: augs #1
# CHECK-NEXT: setnib r0, #488, #7
rdlong r0, ptra[-1]
# CHECK: rdlong r0, ptra[-1]
wrlong #353, r2
# CHECK: wrlong #353, r2
testb r0, #0 wz
# CHECK: testb r0, #0{{.*}}wz{{.*}}encoding: [0x00,0xa0,0x0f,0xf4]
testp #0 wz
# CHECK: testp #0{{.*}}wz{{.*}}encoding: [0x40,0x00,0x6c,0xfd]
