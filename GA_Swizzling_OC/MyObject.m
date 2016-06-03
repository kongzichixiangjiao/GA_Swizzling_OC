//
//  MyObject.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/2.
//  Copyright © 2016年 houjianan. All rights reserved.
//


/**
 *  消息发送用例
 *
 */

#import "MyObject.h"
#import <objc/runtime.h>
#import "RuntimeMethodHelper.h"
static NSMutableDictionary *map = nil;
@interface MyObject() {
    RuntimeMethodHelper *_helper;
    
}

@end
@implementation MyObject

+ (void)load {
    map             = [NSMutableDictionary dictionary];
    map[@"name1"]   = @"name";
    map[@"status1"] = @"status";
    map[@"name2"]   = @"name";
    map[@"status2"] = @"status";
}

- (void)setDataWithDic:(NSDictionary *)dic {
    [map enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        NSLog(@"key == %@, obj == %@", key, obj);
        NSString *propertyKey = [self propertyForKey:key];
        NSLog(@"propertyKey == %@", propertyKey);
        if (propertyKey) {
            objc_property_t property = class_getProperty([self class], [propertyKey UTF8String]);
            // TODO: 针对特殊数据类型做处理
            NSString *attributeString = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            NSLog(@"attributeString == %@", attributeString);
            [self setValue:obj forKey:propertyKey];
        }
    }];
}

- (NSString *)propertyForKey:(NSString *)originalKey
{
    return [map objectForKey:originalKey];
}

void functionForMethod1(id self, SEL _cmd) {
    
    NSLog(@"functionForMethod1 == %@, %p", self, _cmd);
    
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"%@", selectorString);
    if ([selectorString isEqualToString:@"testResolveInstance"]) {
        class_addMethod(self.class, @selector(testResolveInstance), (IMP)functionForMethod1, "@:");
    }
    return [super resolveInstanceMethod:sel];
}

void functionForMethod2(id self, SEL _cmd) {
    
    NSLog(@"functionForMethod2 == %@, %p", self, _cmd);
    
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    NSString *selectorString = NSStringFromSelector(sel);
    NSLog(@"%@", selectorString);
    if ([selectorString isEqualToString:@"testResolveClass"]) {
        if (class_addMethod(self.class, @selector(testResolveClass), (IMP)functionForMethod2, "@:")) {
            NSLog(@"添加functionForMethod2成功");
        }
    }
    return [super resolveClassMethod:sel];
}

//+ (void)testResolveClass {
//    NSLog(@"testResolveClass");
//}


+ (instancetype)object {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _helper = [[RuntimeMethodHelper alloc] init];
    }
    return self;
}

- (void)testForwardingTarget {
    [self performSelector:@selector(helperMethod)];
}

//- (void)helperMethod {
//    NSLog(@"helperMethod");
//}

// 调用helperMethod该方法的类没有实现此方法，
// resolveClassMethod没有做操作
// 则会调用下面方法方法forwardingTargetForSelector
// 经过返回一个对象，改对象内实现了方法helperMethod则处理完成
// 如果没有实现，则崩溃
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector");
    NSString *selectorString = NSStringFromSelector(aSelector);
    // 将消息转发给_helper来处理
//    if ([selectorString isEqualToString:@"helperMethod"]) {
//        return _helper;
//    }
    return [super forwardingTargetForSelector:aSelector];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([RuntimeMethodHelper instancesRespondToSelector:aSelector]) {
            signature = [RuntimeMethodHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([RuntimeMethodHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}


@end

/*
// 不确定一个对象是否能接收某个消息时使用respondsToSelector函数进行判断
if ([self respondsToSelector:@selector(method)]) {
    [self performSelector:@selector(method)];
}
//如果不进行判断直接调用方法，方法不存在会报如下错误：
-[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[SUTRuntimeMethod method]: unrecognized selector sent to instance 0x100111940'
//这个错误是由NSObject的”doesNotRecognizeSelector”抛出。
/**
 当一个对象无法接收某一消息时，就会启动所谓”消息转发(message forwarding)“机制，通过这一机制，我们可
 以告诉对象如何处理未知的消息
 */
/*
消息转发机制基本上分为三个步骤：
 1、动态方法解析
 +(BOOL)resolveInstanceMethod:(SEL)sel {return true} //实例方法
 +(BOOL)resolveClassMethod:(SEL)sel {return true} //类方法
 这种方案更多的是为了实现@dynamic属性。
2、备用接收者
 - (id)forwardingTargetForSelector:(SEL)aSelector
 如果一个对象实现了这个方法，并返回一个非nil的结果，则这个对象会作为消息的新接收者，且消息会被分发到这个对象。
 当然这个对象不能是self自身，否则就是出现无限循环。当然，如果我们没有指定相应的对象来处理aSelector，则应该调
 用父类的实现来返回结果。
 使用这个方法通常是在对象内部，可能还有一系列其它对象能处理该消息，我们便可借这些对象来处理消息并返回，这样在对
 象外部看来，还是由该对象亲自处理了这一消息。
3、完整转发
 - (void)forwardInvocation:(NSInvocation *)anInvocation
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector //重写此方法获取方法签名
*/

















