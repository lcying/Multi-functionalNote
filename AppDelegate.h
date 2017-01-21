//
//  AppDelegate.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MainTabBarViewController *tabBarController;

- (void)showHomeVC;

@end

