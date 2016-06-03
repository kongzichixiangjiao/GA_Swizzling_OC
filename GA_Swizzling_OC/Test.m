//
//  Test.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/27.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>


@interface Test() <TestDelegate>
{
    NSString* _testVarName;
    int _testVarAge;
    
    NSInteger       _instance1;
    NSString    *   _instance2;
}

@property (nonatomic, assign) NSUInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation Test

+ (void)classMethod1 {
   
}

- (void)method1 {
    NSLog(@"call method method1");
}

- (void)method2 {

}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

-(void)test {
    NSLog(@"test");
}

//#error "ee"
//#warning "This method can not be used"
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", NSStringFromClass([self class]));
        NSLog(@"%@", NSStringFromClass([super class]));
//    clang之后如下：
//        NSLog((NSString *)&__NSConstantStringImpl__var_folders_gm_0jk35cwn1d3326x0061qym280000gn_T_main_a5cecc_mi_0, NSStringFromClass(((Class (*)(id, SEL))(void *)objc_msgSend)((id)self, sel_registerName("class"))));
//        
//        NSLog((NSString *)&__NSConstantStringImpl__var_folders_gm_0jk35cwn1d3326x0061qym280000gn_T_main_a5cecc_mi_1, NSStringFromClass(((Class (*)(__rw_objc_super *, SEL))(void *)objc_msgSendSuper)((__rw_objc_super){ (id)self, (id)class_getSuperclass(objc_getClass("Son")) }, sel_registerName("class"))));
    }
    return self;
}

- (void)ex_registerClassPair {
    /**
     *  Test类继承NSError
     *  1、使用objc_allocateClassPair方法创建一个类
     *  Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)
     *  2、给类添加方法class_addMethod  IMP指针
     *  BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
     *  "v@:"表示返回值和参数
     *  3、登记类方法
     *  void objc_registerClassPair(Class cls)
     *  4、创建对象
     *  5、校验方法
     *  performSelector是运行时系统负责去找方法的,在编译时候不做任何校验;如果直接调用编译是会自动校验。
     */
    Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
    class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
    objc_registerClassPair(newClass);
    id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [instance performSelector:@selector(testMetaClass)];
}
/**
 *  IMP
 */
void TestMetaClass(id self, SEL _cmd) {
    NSLog(@"This objcet is %p", self); //打印类地址
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]); //打印类和超类
    Class currentClass = [self class]; //当前类
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        //对meta类的理解
        currentClass = objc_getClass((__bridge void *)currentClass); //我们通过objc_getClass来获取对象的isa
    }
    NSLog(@"NSObject's class is %p", [NSObject class]); //打印当前类地址
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class])); //打印meta类地址
}

- (void)testMetaClass {
    NSLog(@"testMetaClass");
}

@end
