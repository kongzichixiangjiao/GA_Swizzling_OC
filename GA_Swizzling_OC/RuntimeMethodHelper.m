//
//  RuntimeMethodHelper.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/3.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/**
 *  消息发送相关类 
 *  具体查看MyObject类
 *
 *  使用位置 ：forwardingTargetForSelector  forwardInvocation
 *
 *  @return
 */

#import "RuntimeMethodHelper.h"

@implementation RuntimeMethodHelper

- (void)helperMethod {
    
    NSLog(@"%@, %p", self, _cmd);
    
}


@end
