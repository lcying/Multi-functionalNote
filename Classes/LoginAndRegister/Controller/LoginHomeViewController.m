//
//  LoginHomeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LoginHomeViewController.h"
#import "LoginHomeView.h"

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginHomeViewController ()

@property (nonatomic) LoginHomeView *loginHomeView;

@end

@implementation LoginHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [Utils returnBackButton];
    
    self.loginHomeView = [[LoginHomeView alloc] init];
    [self.view addSubview:self.loginHomeView];
    [self.loginHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __block __weak LoginHomeViewController *weakself = self;
    
    [self.loginHomeView setLoginCallBack:^(NSInteger tag) {
        switch (tag) {
            case 1:
            {//登录
                LoginViewController *vc = [[LoginViewController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {//注册
                RegisterViewController *vc = [[RegisterViewController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {//忘记密码
                ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 10:
            {//微信登录
                
            }
                break;
            case 11:
            {//微博登录
                
            }
                break;
        }
    }];
    
}

@end
