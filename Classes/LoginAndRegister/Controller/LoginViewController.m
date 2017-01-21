//
//  LoginViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "NotesHomeViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@property (nonatomic) LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    
    self.loginView = [[LoginView alloc] init];
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __block __weak LoginViewController *weakself = self;

    [self.loginView setLoginCallBack:^(id obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.view endEditing:YES];
            weakself.loginView.loginButton.userInteractionEnabled = NO;
        });
        
        [Utils toastview:@"登录..."];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //原密码
            NSString *password = weakself.loginView.passwordTF.text;
            //加密后的密码
            NSString *encryptPassword = [Utils md5String:password];
            
            [BmobUser loginWithUsernameInBackground:weakself.loginView.usernameTF.text password:encryptPassword block:^(BmobUser *user, NSError *error) {
                weakself.loginView.loginButton.userInteractionEnabled = YES;
                if (user) {
                    
                    [[EaseMobManager shareManager] loginWithName:weakself.loginView.usernameTF.text andPassword:encryptPassword];
                    
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app showHomeVC];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
            
        });
    }];
}

@end
