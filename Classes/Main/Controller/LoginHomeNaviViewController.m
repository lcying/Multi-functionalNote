//
//  LoginNaviViewController.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/12/15.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "LoginHomeNaviViewController.h"

@interface LoginHomeNaviViewController ()

@end

@implementation LoginHomeNaviViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//透明背景的导航栏
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = YES;
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    UIImageView *lineImageView = [Utils findHairlineImageViewUnder:self.navigationBar];
    lineImageView.hidden = YES;
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviBack"] forBarMetrics:UIBarMetricsDefault];
}

@end
