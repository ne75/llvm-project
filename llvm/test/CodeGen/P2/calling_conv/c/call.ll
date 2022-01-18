; RUN: llc < %s -march=p2 | FileCheck %s

; basic function arguments
declare void @void_void()
declare void @void_i8(i8 %a)
declare void @void_i16(i16 %a)
declare void @void_i32(i32 %a)
declare void @void_i64(i64 %a)

; register based arguments
declare void @void_i32_i32_i32_i32(i32 %a, i32 %b, i32 %c, i32 %d)
declare void @void_i64_i64(i64 %a, i64 %b)

; register + stack arguments
declare void @void_i64_i64_i32(i64 %a, i64 %b, i32 %c)
declare void @void_i64_i64_i64(i64 %a, i64 %b, i64 %c)

; variable arguments
declare void @void_vaarg(i32 %a, ...)

define void @call_void_void() {
; CHECK-LABEL:  call_void_void: 
; CHECK:        calla #void_void
    call void @void_void()
    ret void
}

define void @call_void_i8() {
; CHECK-LABEL:  call_void_i8: 
; CHECK:        mov r0, #1
; CHECK:        calla #void_i8
    call void @void_i8(i8 1)
    ret void
}

define void @call_void_i16() {
; CHECK-LABEL:  call_void_i16: 
; CHECK:        augs #1
; CHECK:        mov r0, #488
; CHECK:        calla #void_i16
    call void @void_i16(i16 1000)
    ret void
}

define void @call_void_i32() {
; CHECK-LABEL:  call_void_i32: 
; CHECK:        augs #1
; CHECK:        mov r0, #488
; CHECK:        calla #void_i32
    call void @void_i32(i32 1000)
    ret void
}

define void @call_void_i64() {
; CHECK-LABEL:  call_void_i64: 
; CHECK:        augs #8388607
; CHECK-NEXT:   mov r0, #511
; CHECK:        augs #127
; CHECK-NEXT:   mov r1, #511
; CHECK:        calla #void_i64
    call void @void_i64(i64 281474976710655)
    ret void
}

define void @call_void_i32_i32_i32_i32() {
; CHECK-LABEL:  call_void_i32_i32_i32_i32: 
; CHECK:        mov r0, #1
; CHECK:        mov r1, #2
; CHECK:        mov r2, #3
; CHECK:        mov r3, #4
; CHECK:        calla #void_i32_i32_i32_i32
    call void @void_i32_i32_i32_i32(i32 1, i32 2, i32 3, i32 4)
    ret void
}

define void @call_void_i64_i64() {
; CHECK-LABEL:  call_void_i64_i64: 
; CHECK:        mov r0, #1
; CHECK:        mov r1, #2
; CHECK:        mov r2, #3
; CHECK:        mov r3, #4
; CHECK:        calla #void_i64_i64
    call void @void_i64_i64(i64 8589934593, i64 17179869187)
    ret void
}

define void @call_void_i64_i64_i32() {
; CHECK-LABEL:  call_void_i64_i64_i32: 
; CHECK:        wrlong #100, ptra
; CHECK:        mov r0, #1
; CHECK:        mov r1, #2
; CHECK:        mov r2, #3
; CHECK:        mov r3, #4
; CHECK:        add ptra, #4
; CHECK:        calla #void_i64_i64_i32
    call void @void_i64_i64_i32(i64 8589934593, i64 17179869187, i32 100)
    ret void
}

define void @call_void_i64_i64_i64() {
; CHECK-LABEL:  call_void_i64_i64_i64: 
; CHECK:        mov r0, #200	
; CHECK:        mov r1, #0	
; CHECK:        setq #1
; CHECK:        wrlong r0, ptra
; CHECK:        mov r0, #1
; CHECK:        mov r1, #2
; CHECK:        mov r2, #3
; CHECK:        mov r3, #4
; CHECK:        add ptra, #8
; CHECK:        calla #void_i64_i64_i64
    call void @void_i64_i64_i64(i64 8589934593, i64 17179869187, i64 200)
    ret void
}

define void @call_void_vaarg() {
; CHECK-LABEL:  call_void_vaarg: 
; CHECK:        mov r0, ptra	
; CHECK:        add r0, #4	
; CHECK:        wrlong #2, r0
; CHECK:        wrlong #3, ptra
; CHECK:        mov r0, ptra
; CHECK:        add r0, #8
; CHECK:        wrlong #1, r0
; CHECK:        add ptra, #12
; CHECK:        calla #void_vaarg
    call void (i32, ...) @void_vaarg(i32 1, i32 2, i32 3)
    ret void
}

define void @call_multiple() {
    call void @void_i64_i64_i32(i64 8589934593, i64 17179869187, i32 100)
    call void @void_i64_i64_i64(i64 8589934593, i64 17179869187, i64 200)
    ret void
}