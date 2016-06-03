//
//  OneViewController.m
//  GA_Swizzling_OC
//
//  Created by houjianan on 16/5/26.
//  Copyright © 2016年 houjianan. All rights reserved.
//

/**
 *  配合OneViewController+Tracking使用
*/
#import "OneViewController.h"

@implementation OneViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor brownColor];
    NSLog(@"%@", self);
    [self test];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)test {
    NSLog(@"test == %@", self);
}

@end
