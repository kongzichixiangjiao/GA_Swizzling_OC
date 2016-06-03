//
//  NSArray+GA_Array.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/24.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import "NSArray+GA_Array.h"

@implementation NSArray (GA_Array)

+(void)load {
    [super load];
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(lxz_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)lxz_objectAtIndex:(NSUInteger)index {
//    if (self.count-1 < index) {
        // 这里做一下异常处理，不然都不知道出错了。
        @try {
            return [self lxz_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
//    } else {
//        return [self lxz_objectAtIndex:index];
//    }
}




@end
