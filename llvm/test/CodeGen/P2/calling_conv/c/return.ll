; RUN: llc < %s -march=p2 | FileCheck %s

define i8 @ret_i8() {
; CHECK-LABEL:  ret_i8: 
; CHECK:        mov r31, #10
; CHECK:        reta
    ret i8 10
}

define i16 @ret_i16() {
; CHECK-LABEL:  ret_i16: 
; CHECK:        augs #1
; CHECK:        mov r31, #488
; CHECK:        reta
    ret i16 1000
}

define i32 @ret_i32() {
; CHECK-LABEL:  ret_i32: 
; CHECK:        augs #1953
; CHECK:        mov r31, #64
; CHECK:        reta
    ret i32 1000000
}

define i64 @ret_i64() {
; CHECK-LABEL:  ret_i64: 
; CHECK:        mov r30, #1
; CHECK:        mov r31, #2
; CHECK:        reta
    ret i64 8589934593
}