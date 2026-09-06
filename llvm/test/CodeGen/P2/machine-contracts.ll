; RUN: llc -march=p2 -verify-machineinstrs < %s -o %t.s
; RUN: llc -march=p2 -O0 -verify-machineinstrs -stop-after=finalize-isel < %s -o %t.mir
; Frame fixed objects must also be printable by MIRPrinter.
declare i32 @callee(i32, i32, i32, i32, i32)
define i64 @pair(i64 %x) {
  %r = xor i64 %x, 1311768467463790320
  ret i64 %r
}
define i32 @select(i32 %x, i32 %y, i32 %a, i32 %b) {
  %c = icmp slt i32 %x, %y
  %r = select i1 %c, i32 %a, i32 %b
  ret i32 %r
}
define i32 @remainder(i32 %x, i32 %y) {
  %r = urem i32 %x, %y
  ret i32 %r
}
define i32 @call(i32 %x) {
  %r = call i32 @callee(i32 %x, i32 1, i32 2, i32 3, i32 4)
  ret i32 %r
}
define i64 @memory(i64* %p, i64 %x) {
  store volatile i64 %x, i64* %p, align 4
  %r = load volatile i64, i64* %p, align 4
  ret i64 %r
}
