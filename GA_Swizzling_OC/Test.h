//
//  Test.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/27.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Test : NSError 

@property(nonatomic, strong) NSString* testName;
@property(nonatomic, assign) int testAge;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;


-(void)test;
- (void)ex_registerClassPair;


- (void)method1;
- (void)method2;
+ (void)classMethod1;
@end

@protocol TestDelegate <NSObject>

-(void)testDelegateTestAction;

@end
