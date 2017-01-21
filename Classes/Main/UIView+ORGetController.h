//
//  UIView+ORGetController.h
//  OrangeDouYu
//
//  Created by orange on 16/9/11.
//  Copyright © 2016年 orange. All rights reserved.

//写完这个分类之后，就可以在需要获取控制器view中调用
//UIViewController *controller = [self viewController]; 得到的这个controller就是当前view所在的控制器。

#import <UIKit/UIKit.h>

@interface UIView (ORGetController)
- (UIViewController *)viewController;
@end
