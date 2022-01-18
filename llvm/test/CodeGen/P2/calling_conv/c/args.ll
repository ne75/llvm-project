; RUN: llc < %s -march=p2 | FileCheck %s

; basic function arguments
define void @void_i8(i8 %a) {
; CHECK-LABEL:  void_i8:
; CHECK:        wrbyte r0, pa    
    %ptr = alloca i8
    store i8 %a, i8* %ptr
    ret void
}

define void @void_i16(i16 %a) {
; CHECK-LABEL:  void_i16:
; CHECK:        wrword r0, pa
    %ptr = alloca i16
    store i16 %a, i16* %ptr
    ret void
}

define void @void_i32(i32 %a) {
; CHECK-LABEL:  void_i32:
; CHECK:        wrlong r0, #319  
    %ptr = alloca i32
    store i32 %a, i32* %ptr
    ret void
}

define void @void_i64(i64 %a) {
; CHECK-LABEL:  void_i64:
; CHECK:        setq #1
; CHECK-NEXT:   wrlong r0, pa  
    %ptr = alloca i64
    store i64 %a, i64* %ptr
    ret void
}

; register based arguments
define void @void_i32_i32_i32_i32(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL:  void_i32_i32_i32_i32:
; CHECK:        add ptra, #16
; CHECK:        wrlong r3, r5
; CHECK:        wrlong r2, r3
; CHECK:        wrlong r1, r4
; CHECK:        wrlong r0, #316
    %ptr = alloca i32, i32 4
    %ptr0 = getelementptr i32, i32* %ptr, i32 0
    %ptr1 = getelementptr i32, i32* %ptr, i32 1
    %ptr2 = getelementptr i32, i32* %ptr, i32 2
    %ptr3 = getelementptr i32, i32* %ptr, i32 3
    store i32 %a, i32* %ptr0
    store i32 %b, i32* %ptr1
    store i32 %c, i32* %ptr2
    store i32 %d, i32* %ptr3
    ret void
}

define void @void_i64_i64(i64 %a, i64 %b) {
; CHECK-LABEL:  void_i64_i64:
; CHECK:        setq #1
; CHECK-NEXT:   wrlong r2, r4
; CHECK:        setq #1
; CHECK-NEXT:   wrlong r0, pa
    %ptr = alloca i64, i64 2
    %ptr0 = getelementptr i64, i64* %ptr, i64 0
    %ptr1 = getelementptr i64, i64* %ptr, i64 1
    store i64 %a, i64* %ptr0
    store i64 %b, i64* %ptr1
    ret void
}

; ; register + stack arguments
; define void @void_i64_i64_i32(i64 %a, i64 %b, i32 %c) {
;     ret void
; }

; define void @void_i64_i64_i64(i64 %a, i64 %b, i64 %c) {
;     ret void
; }

; ; variable arguments
; define void @void_vaarg(i32 %a, ...) {
;     ret void
; }