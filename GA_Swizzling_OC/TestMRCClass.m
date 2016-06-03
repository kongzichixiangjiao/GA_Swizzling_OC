//
//  TestMRCClass.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/2.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/**
 *  这是一个MRC的类，runtime有的方法必须在MRC下使用
 *
 */

#import "TestMRCClass.h"
#import <objc/runtime.h>
#import "Test.h"
#import "MyObject.h"
@implementation TestMRCClass

//获取已注册的类定义的列表
- (void)testGetClassList {
    int numClasses;
    
    Class * classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0) {
        classes = malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"number of classes: %d", numClasses);
            for (int i = 0; i < numClasses; i++) {
                Class cls = classes[i];
                NSLog(@"class name: %s", class_getName(cls));
            }
             free(classes);
        });
    }
}

- (void)testClass_createInstance {
    id theObject = class_createInstance(NSString.class, sizeof(unsigned));
    id str1 = [theObject init];
    NSLog(@"%@", [str1 class]);
    id str2 = [[NSString alloc] initWithString:@"test"];
    NSLog(@"%@", [str2 class]);
    //结论：使用class_createInstance函数获取的是NSString实例，而不是类簇中的默认占位符类__NSCFConstantString。
}

/**
 有这样一种场景，假设我们有类A和类B，且类B是类A的子类。类B通过添加一些额外的属性来扩展类A。现在我们创建了个
 A类的实例对象，并希望在运行时将这个对象转换为B类的实例对象，这样可以添加数据到B类的属性中。这种情况下，我们
 没有办法直接转换，因为B类的实例会比A类的实例更大，没有足够的空间来放置对象。
 */
- (void)testChange {
    NSObject *a = [[NSObject alloc] init];
    
    id newB = object_copy(a, class_getInstanceSize(Test.class));
    
    object_setClass(newB, Test.class);
    
    object_dispose(a);
}

- (NSObject *)createClass {
    //动态创建类
    //如果类已经存在，则不走IMP方法
    Class cls = objc_allocateClassPair([NSObject class], "MyTest", 0);
    
    class_addMethod(cls, @selector(submethod1:), (IMP)imp_submethod1, "v@:");
    class_replaceMethod(cls, @selector(method1), (IMP)imp_submethod1, "v@:");
    //添加一个NSString的变量，第四个参数是对其方式，第五个参数是参数类型
    if (class_addIvar(cls, "ivar1", sizeof(NSString *), 0, "@")) {
        NSLog(@"add ivar1 success");
    }
    
    if (class_addIvar(cls, "date", sizeof(NSDate *), 0, "@")) {
        NSLog(@"add date success");
    }

    objc_property_attribute_t typeSting = {"T", "@\"NSString\""};
    objc_property_attribute_t ownershipClass = { "C", "" };
    objc_property_attribute_t backingivar_property2 = { "V", "_property2"};
    objc_property_attribute_t attrs1[] = {typeSting, ownershipClass, backingivar_property2};
    
    objc_property_attribute_t typeInt = {"T", "\"Int\""}; //类型
    objc_property_attribute_t onnerShipClass = {"C", ""}; //拥有者是类
    objc_property_attribute_t backingivar_property = { "V", "_property"}; //变量的名字
    objc_property_attribute_t attrs2[] = {typeInt, onnerShipClass, backingivar_property};

    class_addProperty(cls, "property2", attrs1, 3);
    class_addProperty(cls, "property", attrs2, 3);
    objc_registerClassPair(cls);
    
    id instance = [[cls alloc] init];
    [instance setValue:@"我是ivar1" forKey:@"ivar1"];
    [instance setValue:[NSDate date] forKey:@"date"];
    [instance submethod1:@"jianan"];
//    [instance performSelector:@selector(submethod1:)];
//    [instance performSelector:@selector(method1)];
    return (NSObject*)cls;
}

void imp_submethod1(id self, SEL _cmd, NSString* str) {
    NSLog(@"方法参数 = %@", str);
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
    unsigned int outCount;
    
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        Ivar v = class_getInstanceVariable([self class], ivar_getName(ivar));
        id o = object_getIvar(self, v);
        NSLog(@"instance variable's name: %s at index: %d, value: %@", ivar_getName(ivar), i, o);
    }
//    class_getInstanceVariable
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
}

- (void)submethod1: (NSString*)str {
    NSLog(@"submethod1");
}

- (void)method1 {
    NSLog(@"method1");
}

- (void)getObject {
    
}
+ (TestMRCClass*)getObjectClassAction {
    Class cls = [self class];
//    unsigned int outCount;
//    Ivar *ivars = class_copyIvarList(cls, &outCount);
//    for (int i = 0; i < outCount; i++) {
//        Ivar ivar = ivars[i];
//        Ivar v = class_getInstanceVariable(cls, ivar_getName(ivar));
//        id o = object_getIvar(self, v);
//        object_setIvar(o, v, @"333");
//        NSLog(@"instance variable's name: %s at index: %d, value: %@", ivar_getName(ivar), i, o);
//    }
    
    id instance = [[cls alloc] init];
    [instance setValue:[NSDate date].description forKey:@"name"];
    return (TestMRCClass*)instance;
}

@end
