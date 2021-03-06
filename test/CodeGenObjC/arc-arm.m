// RUN: %clang_cc1 -triple armv7-apple-darwin10 -emit-llvm -fblocks -fobjc-arc -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple arm64-apple-ios -emit-llvm -fblocks -fobjc-arc -o - %s | FileCheck %s

// <rdar://12438598>: use an autorelease marker on ARM64.

id test0(void) {
  extern id test0_helper(void);
  // CHECK:      [[T0:%.*]] = call [[CC:(arm_aapcscc )?]]i8* @test0_helper()
  // CHECK-NEXT: ret i8* [[T0]]
  return test0_helper();
}

void test1(void) {
  extern id test1_helper(void);
  // CHECK:      [[T0:%.*]] = call [[CC]]i8* @test1_helper()
  // CHECK-NEXT: call void asm sideeffect "mov
  // CHECK-NEXT: [[T1:%.*]] = call [[CC]]i8* @objc_retainAutoreleasedReturnValue(i8* [[T0]])
  // CHECK-NEXT: store i8* [[T1]],
  // CHECK-NEXT: call [[CC]]void @objc_storeStrong(
  // CHECK-NEXT: ret void
  id x = test1_helper();
}

// rdar://problem/12133032
@class A;
A *test2(void) {
  extern A *test2_helper(void);
  // CHECK:      [[T0:%.*]] = call [[CC]][[A:%.*]]* @test2_helper()
  // CHECK-NEXT: ret [[A]]* [[T0]]
  return test2_helper();
}

id test3(void) {
  extern A *test3_helper(void);
  // CHECK:      [[T0:%.*]] = call [[CC]][[A:%.*]]* @test3_helper()
  // CHECK-NEXT: [[T1:%.*]] = bitcast [[A]]* [[T0]] to i8*
  // CHECK-NEXT: ret i8* [[T1]]
  return test3_helper();
}
