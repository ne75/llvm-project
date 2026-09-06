; RUN: llc -march=p2 -verify-machineinstrs < %s | FileCheck %s
; CHECK: rdbyte {{r[0-9]+}}, {{r[0-9]+}}
@val = external global i1

define i32 @main() {
    %1 = load i1, i1* @val
    %2 = zext i1 %1 to i32
    ret i32 %2
}
