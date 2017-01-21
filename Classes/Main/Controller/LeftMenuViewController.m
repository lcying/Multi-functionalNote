//
//  LeftMenuViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuView.h"
#import "MainTabBarViewController.h"

@interface LeftMenuViewController ()

@property (nonatomic) LeftMenuView *leftMenuView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftMenuView = [[LeftMenuView alloc] init];
    [self.view addSubview:self.leftMenuView];
    [self.leftMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak LeftMenuViewController *weakself = self;

    [self.leftMenuView setLeftCallBack:^(NSInteger tag) {
        switch (tag) {
            case 10:
            {//设置
                MainTabBarViewController *vc = (MainTabBarViewController *)weakself.drawerController.centerViewController;
                vc.selectedIndex = 6;
                vc.tabBar.hidden = YES;
                vc.tabBar.translucent = YES;
                [weakself.drawerController closeDrawerAnimated:YES completion:nil];
            }
                break;
            default:{
                MainTabBarViewController *vc = (MainTabBarViewController *)weakself.drawerController.centerViewController;
                vc.selectedIndex = tag;
                vc.tabBar.hidden = NO;
                vc.tabBar.translucent = NO;
                if (tag > 3) {
                    vc.tabBar.hidden = YES;
                    vc.tabBar.translucent = YES;
                }
                [weakself.drawerController closeDrawerAnimated:YES completion:nil];
            }
                break;
        }
    }];
}

@end
