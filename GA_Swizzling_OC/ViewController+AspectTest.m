//
//  ViewController+AspectTest.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/31.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/**
 *  第三方AspectTest的使用
*/

#import "ViewController+AspectTest.h"
#import "OneViewController.h"
#import <Aspects.h>
@implementation ViewController (AspectTest)


+ (void)load {
    
    [ViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo, BOOL animation) {
        
        NSLog(@"aspect_hookSelector = %d", animation);
        
    } error:NULL];
    
    [ViewController aspect_hookSelector:@selector(viewControllerTest: andAge:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, NSString* name) {
        
        NSLog(@"%@", aspectInfo);
        NSLog(@"%f", aspectInfo.originalInvocation.accessibilityFrame.origin.x);
        NSLog(@"%f", aspectInfo.originalInvocation.accessibilityFrame.origin.y);
        NSLog(@"%f", aspectInfo.originalInvocation.accessibilityFrame.size.width);
        NSLog(@"%f", aspectInfo.originalInvocation.accessibilityFrame.size.height);
        NSLog(@"%@", aspectInfo.arguments);
        
    } error:NULL];

}

- (void)viewControllerTest: (NSString*)name andAge: (int)age {
    NSLog(@"name == %@, age == %d", name, age);
}

@end
