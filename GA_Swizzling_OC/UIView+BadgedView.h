//
//  UIView+BadgedView.h
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/26.
//  Copyright © 2016年 houjianan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, WBadgedStyle) {
    WBadgedStyleRedDot = 0,
    WBadgedStyleNumber
};

@interface UIView (BadgedView)

@property(nonatomic, strong)UILabel* badge;
@property(nonatomic, strong)UIFont* badgeFont;
@property(nonatomic, strong)UIColor* badgeBgColor;
@property(nonatomic, strong)UIColor* badgeTextColor;
@property(nonatomic, assign)CGRect badgeFrame;
@property(nonatomic, assign)NSInteger badgeValue;

- (void)showBadgedWithStyle:(WBadgedStyle)style value:(NSInteger)value;
- (void)clearBadge;
@end
