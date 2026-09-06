; RUN: llc -march=p2 < %s | FileCheck %s

define i8 @load8() {
; CHECK-LABEL:  load8:
; CHECK:        add ptra, #1
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #1
; CHECK-NEXT:   rdbyte r31, pa
    %ptr = alloca i8
    %val = load i8, i8* %ptr
    ret i8 %val
}

define i16 @load16() {
; CHECK-LABEL:  load16:
; CHECK:        add ptra, #4
; CHECK-NEXT:   mov pa, ptra	
; CHECK-NEXT:   sub pa, #3
; CHECK-NEXT:   andn pa, #1
; CHECK-NEXT:   rdword r31, pa
    %ptr = alloca i16
    %val = load i16, i16* %ptr
    ret i16 %val
}

define i32 @load32() {
; CHECK-LABEL:  load32:
; CHECK:        add ptra, #8
; CHECK-NEXT:   mov pa, ptra
; CHECK-NEXT:   sub pa, #5
; CHECK-NEXT:   andn pa, #3
; CHECK-NEXT:   rdlong r31, pa
    %ptr = alloca i32
    %val = load i32, i32* %ptr
    ret i32 %val
}