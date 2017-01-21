//
//  ForgetPasswordViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "ForgetPasswordView.h"

@interface ForgetPasswordViewController ()

@property (nonatomic) ForgetPasswordView *forgetPasswordView;

@end

@implementation ForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码找回";
    self.forgetPasswordView = [[ForgetPasswordView alloc] init];
    [self.view addSubview:self.forgetPasswordView];
    [self.forgetPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __block __weak ForgetPasswordViewController *weakself = self;
    
    [self.forgetPasswordView setForgetPasswordCallBack:^(NSString *title) {
        //判断格式已经在forgetPasswordView中做过了
        //        NSString *phoneNumber = weakself.forgetPasswordView.phoneTF.text;
        if ([title isEqualToString:@"获取验证码"]) {
            
        }
        
        if ([title isEqualToString:@"确  定"]) {
            //            NSString *captcha = weakself.forgetPasswordView.captchaTF.text;
            
            //先验证验证码是否正确
            
            //注册
            NSString *password = weakself.forgetPasswordView.passwordTF.text;
            //加密后的密码
            NSString *encryptPassword = [Utils md5String:password];
            NSLog(@"%@",encryptPassword);
            
        }
    }];
}

@end
