//
//  RuntimeMethodHelper.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/6/3.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeMethodHelper : NSObject


//如果不写 [self performSelector:@selector(helperMethod)]; 这句有警报  .m不实现 会崩溃
- (void)helperMethod;

@end
