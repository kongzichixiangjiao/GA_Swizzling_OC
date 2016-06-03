//
//  NSMutableArray+GA_SaveMArray.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/31.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (GA_SaveMArray)


- (void)safeAddObject:(id)anObject;
- (id)safeObjectAtIndex:(NSInteger)index;

@end
