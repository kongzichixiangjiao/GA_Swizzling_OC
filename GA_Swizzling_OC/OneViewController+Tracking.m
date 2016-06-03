//
//  OneViewController+Tracking.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/31.
//  Copyright © 2016年 houjianan. All rights reserved.
//


/**
 *  Swizzling 黑魔法操作用例
 */
#import "OneViewController+Tracking.h"
#import <objc/runtime.h>
@implementation OneViewController (Tracking)

//***Swizzling应该总是在+load中执行
//***Swizzling应该总是在dispatch_once中执行

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class aClass = [self class];
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        // When swizzling a class method, use the following:
        // Class aClass = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(aClass, originalSelector);
        // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
        Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        Class aClass = object_getClass((id)self);
        SEL originalSelector = @selector(test);
        SEL swizzledSelector = @selector(xxx_test);
        // When swizzling a class method, use the following:
        // Class aClass = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(aClass, originalSelector);
        // Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
        Method originalMethod = class_getClassMethod(aClass, originalSelector);
        Method swizzledMethod = class_getClassMethod(aClass, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}



+ (BOOL)resolveInstanceMethod:(SEL)sel {
    return true;
}

- (void)createClass
{
    Class MyClass = objc_allocateClassPair([NSObject class], "myclass", 0);
    //添加一个NSString的变量，第四个参数是对其方式，第五个参数是参数类型
    if (class_addIvar(MyClass, "itest", sizeof(NSString *), 0, "@")) {
        NSLog(@"add ivar success");
    }
    //myclasstest是已经实现的函数，"v@:"这种写法见参数类型连接
    class_addMethod(MyClass, @selector(myclasstest:), (IMP)myclasstest, "v@:");
    //注册这个类到runtime系统中就可以使用他了
    objc_registerClassPair(MyClass);
    //生成了一个实例化对象
    id myobj = [[MyClass alloc] init];
    NSString *str = @"asdb";
    //给刚刚添加的变量赋值
    //    object_setInstanceVariable(myobj, "itest", (void *)&str);在ARC下不允许使用
    [myobj setValue:str forKey:@"itest"];
    //调用myclasstest方法，也就是给myobj这个接受者发送myclasstest这个消息
    [myobj myclasstest:10];
    
}



//这个方法实际上没有被调用,但是必须实现否则不会调用下面的方法
- (void)myclasstest:(int)a {
    NSLog(@"%d", a);
}
//调用的是这个方法
static void myclasstest(id self, SEL _cmd, int a) //self和_cmd是必须的，在之后可以随意添加其他参数
{
    Ivar v = class_getInstanceVariable([self class], "itest");
    //返回名为itest的ivar的变量的值
    id o = object_getIvar(self, v);
    //成功打印出结果
    NSLog(@"%@", o);
    NSLog(@"int a is %d", a);
}

- (void)test {
    NSLog(@"test1");
}

#pragma mark - Method Swizzling
- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    NSLog(@"xxx_viewWillAppear: %@", self);
}

- (void)xxx_test {
    [self xxx_test];
    NSLog(@"11122");
}


@end
