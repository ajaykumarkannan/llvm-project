; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

define i1 @cond_eq_and(i8 %X, i8 %Y, i8 noundef %C) {
; CHECK-LABEL: @cond_eq_and(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[X:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 [[LHS]], i1 false
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp eq i8 %X, %C
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 %lhs, i1 false
  ret i1 %res
}

define i1 @cond_eq_and_const(i8 %X, i8 %Y) {
; CHECK-LABEL: @cond_eq_and_const(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[X:%.*]], 10
; CHECK-NEXT:    [[LHS:%.*]] = icmp ugt i8 [[Y:%.*]], 10
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 [[LHS]], i1 false
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp eq i8 %X, 10
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 %lhs, i1 false
  ret i1 %res
}

define i1 @cond_eq_or(i8 %X, i8 %Y, i8 noundef %C) {
; CHECK-LABEL: @cond_eq_or(
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i8 [[X:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[LHS:%.*]] = icmp ult i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 true, i1 [[LHS]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp ne i8 %X, %C
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 true, i1 %lhs
  ret i1 %res
}

define i1 @cond_eq_or_const(i8 %X, i8 %Y) {
; CHECK-LABEL: @cond_eq_or_const(
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i8 [[X:%.*]], 10
; CHECK-NEXT:    [[LHS:%.*]] = icmp ugt i8 [[Y:%.*]], 10
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[COND]], i1 true, i1 [[LHS]]
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cond = icmp ne i8 %X, 10
  %lhs = icmp ult i8 %X, %Y
  %res = select i1 %cond, i1 true, i1 %lhs
  ret i1 %res
}

define i1 @xor_and(i1 %c, i32 %X, i32 %Y) {
; CHECK-LABEL: @xor_and(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT_C:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_C]], i1 true, i1 [[COMP]]
; CHECK-NEXT:    ret i1 [[SEL]]
;
  %comp = icmp ult i32 %X, %Y
  %sel = select i1 %c, i1 %comp, i1 false
  %res = xor i1 %sel, true
  ret i1 %res
}

define <2 x i1> @xor_and2(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_and2(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> [[COMP]], <2 x i1> <i1 false, i1 true>
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> %comp, <2 x i1> <i1 true, i1 false>
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

@glb = global i8 0

define <2 x i1> @xor_and3(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_and3(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> [[COMP]], <2 x i1> <i1 icmp ne (ptr inttoptr (i64 1234 to ptr), ptr @glb), i1 true>
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> %comp, <2 x i1> <i1 icmp eq (ptr @glb, ptr inttoptr (i64 1234 to ptr)), i1 false>
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

define i1 @xor_or(i1 %c, i32 %X, i32 %Y) {
; CHECK-LABEL: @xor_or(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[NOT_C:%.*]] = xor i1 [[C:%.*]], true
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[NOT_C]], i1 [[COMP]], i1 false
; CHECK-NEXT:    ret i1 [[SEL]]
;
  %comp = icmp ult i32 %X, %Y
  %sel = select i1 %c, i1 true, i1 %comp
  %res = xor i1 %sel, true
  ret i1 %res
}

define <2 x i1> @xor_or2(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_or2(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> <i1 false, i1 true>, <2 x i1> [[COMP]]
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> <i1 true, i1 false>, <2 x i1> %comp
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

define <2 x i1> @xor_or3(<2 x i1> %c, <2 x i32> %X, <2 x i32> %Y) {
; CHECK-LABEL: @xor_or3(
; CHECK-NEXT:    [[COMP:%.*]] = icmp uge <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SEL:%.*]] = select <2 x i1> [[C:%.*]], <2 x i1> <i1 icmp ne (ptr inttoptr (i64 1234 to ptr), ptr @glb), i1 true>, <2 x i1> [[COMP]]
; CHECK-NEXT:    ret <2 x i1> [[SEL]]
;
  %comp = icmp ult <2 x i32> %X, %Y
  %sel = select <2 x i1> %c, <2 x i1> <i1 icmp eq (ptr @glb, ptr inttoptr (i64 1234 to ptr)), i1 false>, <2 x i1> %comp
  %res = xor <2 x i1> %sel, <i1 true, i1 true>
  ret <2 x i1> %res
}

define i1 @and_orn_cmp_1_logical(i32 %a, i32 %b, i1 %y) {
; CHECK-LABEL: @and_orn_cmp_1_logical(
; CHECK-NEXT:    [[X:%.*]] = icmp sgt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[X]], i1 [[Y:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp sgt i32 %a, %b
  %x_inv = icmp sle i32 %a, %b
  %or = select i1 %y, i1 true, i1 %x_inv
  %and = select i1 %x, i1 %or, i1 false
  ret i1 %and
}

define i1 @andn_or_cmp_2_logical(i16 %a, i16 %b, i1 %y) {
; CHECK-LABEL: @andn_or_cmp_2_logical(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp slt i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[Y:%.*]], i1 [[X_INV]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %x = icmp sge i16 %a, %b
  %x_inv = icmp slt i16 %a, %b
  %or = select i1 %y, i1 true, i1 %x
  %and = select i1 %or, i1 %x_inv, i1 false
  ret i1 %and
}

define i1 @bools_logical(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools_logical(
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[C:%.*]], i1 [[B:%.*]], i1 [[A:%.*]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %not = xor i1 %c, -1
  %and1 = select i1 %not, i1 %a, i1 false
  %and2 = select i1 %c, i1 %b, i1 false
  %or = select i1 %and1, i1 true, i1 %and2
  ret i1 %or
}

define i1 @bools2_logical(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @bools2_logical(
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[C:%.*]], i1 [[A:%.*]], i1 [[B:%.*]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %not = xor i1 %c, -1
  %and1 = select i1 %c, i1 %a, i1 false
  %and2 = select i1 %not, i1 %b, i1 false
  %or = select i1 %and1, i1 true, i1 %and2
  ret i1 %or
}

define i1 @orn_and_cmp_1_logical(i37 %a, i37 %b, i1 %y) {
; CHECK-LABEL: @orn_and_cmp_1_logical(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp sle i37 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[X_INV]], i1 true, i1 [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %x = icmp sgt i37 %a, %b
  %x_inv = icmp sle i37 %a, %b
  %and = select i1 %y, i1 %x, i1 false
  %or = select i1 %x_inv, i1 true, i1 %and
  ret i1 %or
}

define i1 @orn_and_cmp_2_logical(i16 %a, i16 %b, i1 %y) {
; CHECK-LABEL: @orn_and_cmp_2_logical(
; CHECK-NEXT:    [[X_INV:%.*]] = icmp slt i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR:%.*]] = select i1 [[Y:%.*]], i1 true, i1 [[X_INV]]
; CHECK-NEXT:    ret i1 [[OR]]
;
  %x = icmp sge i16 %a, %b
  %x_inv = icmp slt i16 %a, %b
  %and = select i1 %y, i1 %x, i1 false
  %or = select i1 %and, i1 true, i1 %x_inv
  ret i1 %or
}
