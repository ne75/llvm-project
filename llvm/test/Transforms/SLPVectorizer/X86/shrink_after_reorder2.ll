; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -o - -slp-vectorizer -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

%class.e = type { i32, i32 }
%struct.a = type { i32, i32, i32, i32 }

define void @foo(%class.e* %this, %struct.a* %p, i32 %add7) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds [[STRUCT_A:%.*]], %struct.a* [[P:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_A]], %struct.a* [[P]], i64 0, i32 1
; CHECK-NEXT:    [[O:%.*]] = getelementptr inbounds [[STRUCT_A]], %struct.a* [[P]], i64 0, i32 2
; CHECK-NEXT:    [[D:%.*]] = getelementptr inbounds [[STRUCT_A]], %struct.a* [[P]], i64 0, i32 3
; CHECK-NEXT:    [[H:%.*]] = getelementptr inbounds [[CLASS_E:%.*]], %class.e* [[THIS:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[G:%.*]] = getelementptr inbounds [[CLASS_E]], %class.e* [[THIS]], i64 0, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i32> <i32 poison, i32 undef>, i32 [[ADD7:%.*]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = sdiv <2 x i32> [[TMP0]], <i32 2, i32 2>
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i32> [[TMP1]], <2 x i32> poison, <4 x i32> <i32 1, i32 1, i32 0, i32 0>
; CHECK-NEXT:    switch i32 undef, label [[SW_EPILOG:%.*]] [
; CHECK-NEXT:    i32 0, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 2, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i32* [[G]] to <2 x i32>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x i32>, <2 x i32>* [[TMP2]], align 4
; CHECK-NEXT:    [[SHRINK_SHUFFLE:%.*]] = shufflevector <4 x i32> [[SHUFFLE]], <4 x i32> poison, <2 x i32> <i32 0, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i32> [[SHRINK_SHUFFLE]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[TMP5:%.*]] = add <2 x i32> [[TMP3]], [[TMP4]]
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[TMP6:%.*]] = phi <2 x i32> [ undef, [[ENTRY:%.*]] ], [ [[TMP5]], [[SW_BB]] ]
; CHECK-NEXT:    [[SHUFFLE1:%.*]] = shufflevector <2 x i32> [[TMP6]], <2 x i32> poison, <4 x i32> <i32 1, i32 1, i32 0, i32 0>
; CHECK-NEXT:    [[TMP7:%.*]] = sub <4 x i32> poison, [[SHUFFLE]]
; CHECK-NEXT:    [[TMP8:%.*]] = add <4 x i32> [[TMP7]], [[SHUFFLE1]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i32* [[B]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP8]], <4 x i32>* [[TMP9]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %b = getelementptr inbounds %struct.a, %struct.a* %p, i64 0, i32 0
  %c = getelementptr inbounds %struct.a, %struct.a* %p, i64 0, i32 1
  %o = getelementptr inbounds %struct.a, %struct.a* %p, i64 0, i32 2
  %d = getelementptr inbounds %struct.a, %struct.a* %p, i64 0, i32 3
  %h = getelementptr inbounds %class.e, %class.e* %this, i64 0, i32 1
  %g = getelementptr inbounds %class.e, %class.e* %this, i64 0, i32 0
  %div = sdiv i32 undef, 2
  %div8 = sdiv i32 %add7, 2
  switch i32 undef, label %sw.epilog [
  i32 0, label %sw.bb
  i32 2, label %sw.bb
  ]

sw.bb:
  %0 = load i32, i32* %h, align 4
  %1 = xor i32 %div, -1
  %sub10 = add i32 %0, %1
  %2 = load i32, i32* %g, align 4
  %3 = xor i32 %div8, -1
  %sub13 = add i32 %2, %3
  br label %sw.epilog

sw.epilog:
  %l.0 = phi i32 [ undef, %entry ], [ %sub10, %sw.bb ]
  %m.0 = phi i32 [ undef, %entry ], [ %sub13, %sw.bb ]
  %add15 = sub i32 undef, %div
  %sub16 = add i32 %add15, %l.0
  store i32 %sub16, i32* %b, align 4
  %add19 = sub i32 undef, %div
  %sub20 = add i32 %add19, %l.0
  store i32 %sub20, i32* %c, align 4
  %add23 = sub i32 undef, %div8
  %sub24 = add i32 %add23, %m.0
  store i32 %sub24, i32* %o, align 4
  %add27 = sub i32 undef, %div8
  %sub28 = add i32 %add27, %m.0
  store i32 %sub28, i32* %d, align 4
  ret void
}
