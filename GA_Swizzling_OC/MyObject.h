//
//  MyObject.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/2.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import "TestMRCClass.h"

@interface MyObject : TestMRCClass
@property(nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* status;


- (void)setDataWithDic:(NSDictionary *)dic;

- (void)testResolveInstance;
+ (void)testResolveClass;

- (void)testForwardingTarget;

@end
