//
//  UIView+ORGetController.m
//  OrangeDouYu
//
//  Created by orange on 16/9/11.
//  Copyright © 2016年 orange. All rights reserved.
//

#import "UIView+ORGetController.h"

@implementation UIView (ORGetController)
- (UIViewController *)viewController
{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}
@end
