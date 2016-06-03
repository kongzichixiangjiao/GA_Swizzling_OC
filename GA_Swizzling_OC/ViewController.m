//
//  ViewController.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/24.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+GA_Array.h"
#import "OneViewController.h"
#import "UIView+BadgedView.h"
#import "Test.h"
#import <Aspects.h>
#import <libkern/OSAtomic.h>
#import "NSMutableArray+GA_SaveMArray.h"
#import "TestMRCClass.h"
#import "MyObject.h"
#import "RuntimeCategoryClass.h"
#import "RuntimeCategoryClass+Category.h"
#import "RuntimeBlock.h"

static char kDTActionHandlerTapGestureKey;
static char kDTActionHandlerTapBlockKey;

@interface ViewController ()
@property(nonatomic, strong) NSString* viewControllerString;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];

    
    NSArray* arr = @[@1, @2, @3, @4, @5, @6];
    [arr objectAtIndex:2];
    
    NSString* str;
    NSMutableArray* mArr = [NSMutableArray array];
    
//    [mArr safeAddObject:str];

    Test *myClass = [[Test alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    Ivar string = class_getInstanceVariable(cls, "_string");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    NSLog(@"==========================================================");
    // 协议 （对类操作）
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");
    
    //MARK: TODO
    // 替换类的属性
    void class_replaceProperty ( Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount );
    
    //类别里面创建属性的使用例子
    UIView* v = [[UIView alloc] initWithFrame: CGRectMake(100, 100, 100, 100)];
    v.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:v];
    [v showBadgedWithStyle:WBadgedStyleRedDot value:12];
    v.badgeFrame = CGRectMake(10, 10, 30, 20);
    
    //对meta类理解例子
    Test* t = [[Test alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
    [t ex_registerClassPair];
    NSLog(@"t == %@", t);
    
    //mita类面试题例子
    NSLog(@"%@", (id)[NSObject class]); // NSObject
    NSLog(@"%@", [NSObject class]); // NSObject
    NSLog(@"%d", [(id)[NSObject class] isKindOfClass:[NSObject class]]); // 1
    NSLog(@"%d", [(id)[NSObject class] isMemberOfClass:[NSObject class]]); // 0
    NSLog(@"%@", (id)[Test class]); // Test
    NSLog(@"%@", [Test class]); // Test
    NSLog(@"%d", [(id)[Test class] isKindOfClass:[Test class]]); // 0
    NSLog(@"%d", [(id)[Test class] isMemberOfClass:[Test class]]); // 0
    NSLog(@"%d", [(id)[Test class] isKindOfClass:[NSObject class]]); // 1
    
/*
 - (BOOL)isKindOf:aClass {
    Class cls;
    for (cls = isa; cls; cls = cls->superclass)
        if (cls == (Class)aClass)
            return YES;
    return NO;
 }
 

 - (BOOL)isMemberOf:aClass {
    return isa == (Class)aClass;
 }
*/
    
    id test = [Test class];
    void *obj = &test;
    [(__bridge id)obj test]; // NSLog...

    
   aspect_performLocked(^{
       
   });
    
    
    TestMRCClass* mrcClass = [[TestMRCClass alloc] init];
    [mrcClass testChange];
    [mrcClass testGetClassList];
    
    NSObject* myTest = [[mrcClass createClass] class];
    NSLog(@"%@", myTest);
    
    MyObject* object1 = [MyObject getObjectClassAction];
    NSLog(@"%@", object1.name);
    
    
    MyObject* ob = [[MyObject alloc] init];
    [ob setDataWithDic:nil];
    NSLog(@"name == %@, status == %@", ob.name, ob.status);
    
    
    //消息转发测试  动态方法解析
    [ob testResolveInstance];
    //类方法添加
//    [MyObject testResolveClass];
    //备用接收者
    [ob testForwardingTarget];
    
    // 关联属性 属性策略使用
    [self setTapActionWithBlock:^{
        NSLog(@"2");
    }];
    
    //NSInvocation的使用
    //消息发送forwardInvocation处使用NSInvocation
    [self myTestNSMethodSignature];
    
    //categoryTest
    Method *methodList = class_copyMethodList(RuntimeCategoryClass.class, &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method method = methodList[i];
        const char *name = sel_getName(method_getName(method));
        NSLog(@"RuntimeCategoryClass's method: %s", name);
        if (strcmp(name, sel_getName(@selector(method2)))) {
            NSLog(@"分类方法在objc_class的方法列表中");
        }
    }
    
    //库操作
    NSLog(@"获取指定类所在动态库");
    NSLog(@"UIView's Framework: %s", class_getImageName(NSClassFromString(@"UIView")));
    NSLog(@"获取指定库或框架中所有类的类名");
    const char ** classes = objc_copyClassNamesForImage(class_getImageName(NSClassFromString(@"UIView")), &outCount);
    for (int i = 0; i < outCount; i++) {
        NSLog(@"class name: %s", classes[i]);
    }
    
    //块操作
    [self runtimeBlock];
    
}

-(void)runtimeBlock {
    //块操作
    IMP imp = imp_implementationWithBlock(^(id obj, NSString *str) {
        NSLog(@"%@", str);
    });
    class_addMethod(RuntimeBlock.class, @selector(testBlock:), imp, "v@:@");
    RuntimeBlock *runtime = [[RuntimeBlock alloc] init];
    [runtime performSelector:@selector(testBlock:) withObject:@"hello world!"];
}

//这个方法不会调用，调用的是RuntimeBlock类里的方法，去警告。
-(void)testBlock: (NSString*)blockStr {
    NSLog(@"blockStr = %@", blockStr);
}

- (void)myTestNSMethodSignature {
    //1、根据方法来初始化NSMethodSignature
    NSMethodSignature  *signature = [ViewController instanceMethodSignatureForSelector:@selector(run:name:age:)];
    //此时我们应该判断方法是否存在，如果不存在这抛出异常
    if (signature == nil) {
        //aSelector为传进来的方法
        NSString *info = [NSString stringWithFormat:@"%@方法找不到", NSStringFromSelector(@selector(run:name:age:))];
        [NSException raise:@"方法调用出现异常" format:info, nil];
    }
    // NSInvocation中保存了方法所属的对象/方法名称/参数/返回值
    //其实NSInvocation就是将一个方法变成一个对象
    //2、创建NSInvocation对象
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    //设置方法调用者
    invocation.target = self;
    //注意：这里的方法名一定要与方法签名类中的方法一致
    invocation.selector = @selector(run:name:age:);
    
    //此处不能通过遍历参数数组来设置参数，因为外界传进来的参数个数是不可控的
    //因此通过numberOfArguments方法获取的参数个数,是包含self和_cmd的，然后比较方法需要的参数和外界传进来的参数个数，并且取它们之间的最小值
    NSArray* objects = @[@"car", @"jianan", @22];
    NSUInteger argsCount = signature.numberOfArguments - 2;
    NSUInteger arrCount = objects.count;
    NSUInteger count = MIN(argsCount, arrCount);
    for (int i = 0; i < count; i++) {
        id obj = objects[i];
        // 判断需要设置的参数是否是NSNull, 如果是就设置为nil
        if ([obj isKindOfClass:[NSNull class]]) {
            obj = nil;
        }
        //这里的Index要从2开始，以为0跟1已经被占据了，分别是self（target）,selector(_cmd)
        [invocation setArgument:&obj atIndex:i + 2];
    }
    
    //获得返回值类型
    const char *returnType = signature.methodReturnType;
    //声明返回值变量
    id returnValue;
    //如果没有返回值，也就是消息声明为void，那么returnValue=nil
    if( !strcmp(returnType, @encode(void)) ){
        returnValue =  nil;
    }
    //如果返回值为对象，那么为变量赋值
    else if( !strcmp(returnType, @encode(id)) ){
        [invocation getReturnValue:&returnValue];
    }
    else{
        //如果返回值为普通类型NSInteger  BOOL
        
        //返回值长度
        NSUInteger length = [signature methodReturnLength];
        //根据长度申请内存
        void *buffer = (void *)malloc(length);
        //为变量赋值
        [invocation getReturnValue:buffer];
        
        //以下代码为参考:具体地址我忘记了，等我找到后补上，(很对不起原作者)
        if( !strcmp(returnType, @encode(BOOL)) ) {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }
        else if( !strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
    }
    
    NSLog(@"%@", returnValue);
    
    //3、调用invoke方法
    [invocation invoke];
    
    //performSelector最多传两个参数
    [self performSelector:@selector(run:name:age:) withObject:@"all"];
    [self performSelector:@selector(run:name:age:) withObject:@"run" withObject:@"name"];
}

//实现run:方法
- (int)run: (NSString*)method name: (NSString*)name age:(int)age{
    NSLog(@"%@", method);
    NSLog(@"%@", name);
    NSLog(@"%i", age);
    return age;
}

- (void)setTapActionWithBlock:(void (^)(void))block {
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        
        [self.view addGestureRecognizer:gesture];
        
        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &kDTActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"1");
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        void(^block)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
        if (block) {
            block();
        }
    }
}

static void aspect_performLocked(dispatch_block_t block) {
    static OSSpinLock aspect_lock = OS_SPINLOCK_INIT;
    OSSpinLockLock(&aspect_lock);
    block();
    OSSpinLockUnlock(&aspect_lock);
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self presentViewController:[[OneViewController alloc] init] animated:true completion:nil];
//}

- (void)test {
    NSLog(@"22");
}
+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    if(aSelector == @selector(mysteriousMethod)){
        return [NSArray array];
    }
    return [super forwardingTargetForSelector:aSelector];
}
- (void)mysteriousMethod {
    NSLog(@"mysteriousMethod");
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL
{
    if (aSEL == @selector(resolveThisMethodDynamically)) {
        class_addMethod([self class], aSEL, (IMP)dynamicMethodIMP, "v@:");
        return NO;
    }
    return [super resolveInstanceMethod:aSEL];
}

- (void)resolveThisMethodDynamically {
    NSLog(@"resolveThisMethodDynamically");
}

void dynamicMethodIMP(id self, SEL _cmd) {
    // implementation ....
}


- (void)viewWillAppear:(BOOL)animater {
    [super viewWillAppear:animater];
    NSLog(@"viewWillAppear222");
    [self viewControllerTest:@"jianan" andAge:19];
}

- (void)viewControllerTest: (NSString*)name andAge: (int)age {
    NSLog(@"name1 == %@, age1 == %d", name, age);
}

+(void)load {
    
}



@end
