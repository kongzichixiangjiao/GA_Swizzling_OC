//
//  TestMRCClass.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/2.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestMRCClass : NSObject


- (NSObject *)createClass;
- (void)testChange;
- (void)testGetClassList;

- (void)getObject;
+ (TestMRCClass*)getObjectClassAction;
@end

