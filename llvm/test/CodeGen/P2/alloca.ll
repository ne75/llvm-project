; RUN: llc -march=p2 < %s | FileCheck %s

define i8* @alloca8() {
; CHECK-LABEL: alloca8:
; CHECK: add ptra, #1
    %ptr = alloca i8
    ret i8* %ptr
}

define i16* @alloca16() {
; CHECK-LABEL: alloca16:
; CHECK: add ptra, #2
    %ptr = alloca i16
    ret i16* %ptr
}

define i32* @alloca32() {
; CHECK-LABEL: alloca32:
; CHECK: add ptra, #4
    %ptr = alloca i32
    ret i32* %ptr
}

define i64* @alloca64() {
; CHECK-LABEL: alloca64:
; CHECK: add ptra, #8
    %ptr = alloca i64
    ret i64* %ptr
}

define i8* @alloca8_2() {
; CHECK-LABEL: alloca8_2:
; CHECK: add ptra, #2
    %ptr = alloca i8, i8 2
    ret i8* %ptr
}

define i16* @alloca16_2() {
; CHECK-LABEL: alloca16_2:
; CHECK: add ptra, #4
    %ptr = alloca i16, i16 2
    ret i16* %ptr
}

define i32* @alloca32_2() {
; CHECK-LABEL: alloca32_2:
; CHECK: add ptra, #8
    %ptr = alloca i32, i32 2
    ret i32* %ptr
}

define i64* @alloca64_2() {
; CHECK-LABEL: alloca64_2:
; CHECK: add ptra, #16
    %ptr = alloca i64, i64 2
    ret i64* %ptr
}