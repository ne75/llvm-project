; RUN: llc -march=p2 < %s | FileCheck %s

define void @store8_r(i8 %val) {
; CHECK-LABEL:  store8_r:
; CHECK:        add ptra, #1
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #1
; CHECK-NEXT:   wrbyte r0, pa
    %ptr = alloca i8
    store i8 %val, i8* %ptr
    ret void
}

define void @store16_r(i16 %val) {
; CHECK-LABEL:  store16_r:
; CHECK:        add ptra, #2
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #2
; CHECK-NEXT:   wrword r0, pa
    %ptr = alloca i16
    store i16 %val, i16* %ptr
    ret void
}

define void @store32_r(i32 %val) {
; CHECK-LABEL:  store32_r:
; CHECK:        add ptra, #4
; CHECK-NEXT:   wrlong r0, ptra[-1]
    %ptr = alloca i32
    store i32 %val, i32* %ptr
    ret void
}

define void @store8_i() {
; CHECK-LABEL:  store8_i:
; CHECK:        add ptra, #1
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #1
; CHECK-NEXT:   wrbyte #1, pa
    %ptr = alloca i8
    store i8 1, i8* %ptr
    ret void
}

define void @store16_i() {
; CHECK-LABEL:  store16_i:
; CHECK:        add ptra, #2
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #2
; CHECK-NEXT:   wrword #1, pa
    %ptr = alloca i16
    store i16 1, i16* %ptr
    ret void
}

define void @store32_i() {
; CHECK-LABEL:  store32_i:
; CHECK:        add ptra, #4
; CHECK-NEXT:   wrlong #1, ptra[-1]
    %ptr = alloca i32
    store i32 1, i32* %ptr
    ret void
}

define void @store32_large_i() {
; CHECK-LABEL:  store32_large_i:
; CHECK:        add ptra, #4
; CHECK-NEXT:   augd #1
; CHECK-NEXT:   wrlong #488, ptra[-1]
    %ptr = alloca i32
    store i32 1000, i32* %ptr
    ret void
}