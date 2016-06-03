//
//  UIView+BadgedView.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/26.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/**
 *  类别关联属性操作用例
 *  制作小红点
 */

#import "UIView+BadgedView.h"

@implementation UIView (BadgedView)

#define BadgedDefaultFont ([UIFont systemFontOfSize:9])
#define BadgeMaxNumber 99

static char badgedLabelKey;
static char badgedBgColorKey;
static char badgedFontKey;
static char badgedTextColorKey;
static char badgedFrameKey;
static char badgedValueKey;

- (void)showBadgedWithStyle:(WBadgedStyle)style value:(NSInteger)value {
    switch (style) {
        case WBadgedStyleNumber:
            [self showRedDotBadge];
            break;
        case WBadgedStyleRedDot:
            [self showNumbserBadgeWithValue: value];
            break;
        default:
            break;
    }
}

- (void)showRedDotBadge {
    [self badgeInit];
    self.badge.text = @"";
    self.badge.layer.cornerRadius = CGRectGetWidth(self.badge.frame) / 2;
    self.badge.hidden = false;
}

- (void)showNumbserBadgeWithValue:(NSInteger)value {
    if (value < 0) {return;}
    [self badgeInit];
    self.badge.tag = WBadgedStyleNumber;
    self.badge.font = self.badgeFont;
    self.badge.text = value >= BadgeMaxNumber ? [NSString stringWithFormat:@"%d+", BadgeMaxNumber] : [NSString stringWithFormat:@"%@", @(value)];
}

- (void)badgeInit {
    if (self.badgeBgColor == nil) {
        self.badgeBgColor = [UIColor orangeColor];
    }
    if (self.badgeTextColor == nil) {
        self.badgeTextColor = [UIColor whiteColor];
    }
    if (self.badge == nil) {
        static dispatch_once_t t;
        dispatch_once(&t, ^{
            CGFloat w = 8;
            CGFloat x = CGRectGetWidth(self.frame);
            CGFloat y = -w;
            CGFloat h = w;
            CGRect f = CGRectMake(x, y, w, h);
            self.badge = [[UILabel alloc] initWithFrame:f];
            [self addSubview:self.badge];
            self.badge.textAlignment = NSTextAlignmentCenter;
            self.badge.backgroundColor = self.badgeBgColor;
            self.badge.textColor = self.badgeTextColor;
            self.badge.text = @"";
            self.badge.layer.cornerRadius = w / 2;
            self.badge.layer.masksToBounds = true;
            self.badge.hidden = false;
        });
    }
}

- (void)clearBadge {
    self.badge.hidden = true;
}

- (UILabel *)badge {
    return objc_getAssociatedObject(self, &badgedLabelKey);
}

- (void)setBadge:(UILabel *)badge {
    objc_setAssociatedObject(self, &badgedLabelKey, badge, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)badgeFont {
    id font = objc_getAssociatedObject(self, &badgedFontKey);
    return font == nil ? BadgedDefaultFont : font;
}

- (void)setBadgeFont:(UIFont *)badgeFont {
    objc_setAssociatedObject(self, &badgedFontKey, badgeFont, OBJC_ASSOCIATION_RETAIN);
    if (self.badge) {
        self.badge.font = badgeFont;
    }
}

- (UIColor *)badgeBgColor {
    id obj = objc_getAssociatedObject(self, &badgedBgColorKey);
    if (obj == nil) {
        return [UIColor orangeColor];
    }
    return obj;
}

- (void)setBadgeBgColor:(UIColor *)badgeBgColor {
    objc_setAssociatedObject(self, &badgedBgColorKey, badgeBgColor, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)badgeTextColor {
    id obj = objc_getAssociatedObject(self, &badgedTextColorKey);
    if (obj == nil) {
        return [UIColor whiteColor];
    }
    return obj;
}

- (void)setBadgeTextColor:(UIColor *)badgeTextColor {
    objc_setAssociatedObject(self, &badgeTextColor, badgeTextColor, OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)badgeFrame {
    id obj = objc_getAssociatedObject(self, &badgedFrameKey);
    if (obj != nil && [obj isKindOfClass:[NSDictionary class]] && [obj count] == 4) {
        CGFloat x = [obj[@"x"] floatValue];
        CGFloat y = [obj[@"y"] floatValue];
        CGFloat w = [obj[@"width"] floatValue];
        CGFloat h = [obj[@"height"] floatValue];
        return CGRectMake(x, y, w, h);
    } else {
        return CGRectZero;
    }
}

- (void)setBadgeFrame:(CGRect)badgeFrame {
    CGFloat x = badgeFrame.origin.x;
    CGFloat y = badgeFrame.origin.y;
    CGFloat w = badgeFrame.size.width;
    CGFloat h = badgeFrame.size.height;
    NSDictionary *dic = @{@"x" : @(x), @"y" : @(y), @"width" : @(w), @"heigh" : @(h)};
    objc_setAssociatedObject(self, &badgedFrameKey, dic, OBJC_ASSOCIATION_RETAIN);
    if (self.badge) {
        self.badge.frame = badgeFrame;
        self.badge.layer.cornerRadius = h / 2;
    }
}

- (NSInteger)badgeValue {
    NSInteger value = [objc_getAssociatedObject(self, &badgedValueKey) integerValue];
    return value;
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    objc_setAssociatedObject(self, &badgedValueKey, [NSNumber numberWithInteger:badgeValue], OBJC_ASSOCIATION_ASSIGN);
    self.badge.text = [NSString stringWithFormat:@"%lu", badgeValue];
}

@end
