//
//  MainTabBarViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "NotesHomeViewController.h"
#import "OtherNoresViewController.h"
#import "ClocksViewController.h"
#import "PersonalInfoViewController.h"
#import "MyCollectionViewController.h"
#import "UserSatisfactionViewController.h"
#import "SettingTableViewController.h"
#import "LoginHomeNaviViewController.h"
#import "PersonalCenterViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NotesHomeViewController *myNotesVC = [[NotesHomeViewController alloc] init];
    myNotesVC.tabBarItem.image = [UIImage imageNamed:@"tabNote"];
    myNotesVC.tabBarItem.title = @"我的笔记";
    
    MainNavigationViewController *mynoteNavi = [[MainNavigationViewController alloc] initWithRootViewController:myNotesVC];
    mynoteNavi.navigationBar.hidden = YES;
    
    OtherNoresViewController *othersVC = [[OtherNoresViewController alloc] init];
    othersVC.tabBarItem.image = [UIImage imageNamed:@"tabShare"];
    othersVC.tabBarItem.title = @"笔记分享";
    
    ClocksViewController *clockVC = [[ClocksViewController alloc] init];
    clockVC.tabBarItem.image = [UIImage imageNamed:@"tabClock"];
    clockVC.tabBarItem.title = @"事件提醒";
    
    /*
    PersonalInfoViewController *personVC = [[PersonalInfoViewController alloc] init];
    personVC.tabBarItem.image = [UIImage imageNamed:@"tabPersonal"];
    personVC.tabBarItem.title = @"个人中心";
    */
    
    //新版本
    PersonalCenterViewController *personVC = [[PersonalCenterViewController alloc] init];
    personVC.tabBarItem.image = [UIImage imageNamed:@"tabPersonal"];
    personVC.tabBarItem.title = @"个人中心";
    
    
    MyCollectionViewController *collectionVC = [[MyCollectionViewController alloc] init];
    
    UserSatisfactionViewController *userVC = [[UserSatisfactionViewController alloc] init];
    
    UIStoryboard *settingStoryboard = [UIStoryboard storyboardWithName:@"setting" bundle:[NSBundle mainBundle]];
    
    SettingTableViewController *settingVC = (SettingTableViewController *)[settingStoryboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    
    self.viewControllers = @[mynoteNavi,[[MainNavigationViewController alloc] initWithRootViewController:othersVC],[[MainNavigationViewController alloc] initWithRootViewController:clockVC],[[MainNavigationViewController alloc] initWithRootViewController:personVC]];
    
    [self addChildViewController:[[MainNavigationViewController alloc] initWithRootViewController:collectionVC]];
    [self addChildViewController:[[MainNavigationViewController alloc] initWithRootViewController:userVC]];
    [self addChildViewController:[[MainNavigationViewController alloc] initWithRootViewController:settingVC]];
    
    self.tabBar.tintColor = [UIColor blackColor];
    self.tabBar.translucent = NO;
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor lightGrayColor],[UIColor lightGrayColor]);
}

@end
