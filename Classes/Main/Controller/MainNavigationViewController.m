//
//  MainNavigationViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MainNavigationViewController.h"

@interface MainNavigationViewController ()

@end

@implementation MainNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.dk_barTintColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor lightGrayColor],[UIColor lightGrayColor]);
    self.navigationBar.translucent = NO;
    self.navigationBar.tintColor = [UIColor blackColor];
        self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    UIImageView *lineImageView = [Utils findHairlineImageViewUnder:self.navigationBar];
    lineImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //当管理页面为1的时候(只显示一级页面的时候才添加)
    if(self.viewControllers.count == 1){
        self.topViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoLeftMenuView)];
    }
}

- (void)gotoLeftMenuView{
    XHDrawerController *vc = (XHDrawerController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [vc toggleDrawerSide:XHDrawerSideLeft animated:YES completion:nil];
}

@end
