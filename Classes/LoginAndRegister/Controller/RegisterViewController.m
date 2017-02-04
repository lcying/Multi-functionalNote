//
//  RegisterViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@property (nonatomic) RegisterView *registerView;

@property (nonatomic) FailedView *stateView;

@end

@implementation RegisterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.registerView = [[RegisterView alloc] init];
    [self.view addSubview:self.registerView];
    [self.registerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
    
    __block __weak RegisterViewController *weakself = self;

    [self.registerView setRegisterCallBack:^(NSString *title) {
        //判断格式已经在registerView中做过了
        NSString *phoneNumber = weakself.registerView.phoneTF.text;
        if ([title isEqualToString:@"获取验证码"]) {
            [Utils toastview:@"验证码已发送"];
            
            
        }
        
        if ([title isEqualToString:@"注  册"]) {
            NSString *captcha = weakself.registerView.captchaTF.text;
            
            
            
            //先验证验证码是否正确
            
        
            
            //原密码
            NSString *password = weakself.registerView.passwordTF.text;
            //加密后的密码
            NSString *encryptPassword = [Utils md5String:password];
            
            //判断有无昵称
            NSString *nick = weakself.registerView.nickTF.text;
            if ([nick isEqualToString:@""]) {
                //没有昵称
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"如果没有输入昵称，昵称将显示您的手机号！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakself registerActionWithUserName:phoneNumber andPassword:encryptPassword andPhoneNumber:phoneNumber];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [ac addAction:action1];
                [ac addAction:action2];
                [weakself presentViewController:ac animated:YES completion:nil];
            }else{
                //有昵称
                [weakself registerActionWithUserName:weakself.registerView.nickTF.text andPassword:encryptPassword andPhoneNumber:phoneNumber];
            }
            
        }
    }];
}

- (void)registerActionWithUserName:(NSString *)username andPassword:(NSString *)password andPhoneNumber:(NSString *)phoneNumber{
    
    self.registerView.registerButton.userInteractionEnabled = NO;
    
    self.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
    [[UIApplication sharedApplication].keyWindow addSubview:self.stateView];
    
    BmobUser *user = [[BmobUser alloc] init];
    [user setUsername:username];
    [user setPassword:password];
    [user setMobilePhoneNumber:phoneNumber];
    [user setObject:password forKey:@"pass"];
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        self.registerView.registerButton.userInteractionEnabled = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.stateView removeFromSuperview];
        });
        if (isSuccessful) {
            
            BmobObject *userCountObject = [BmobObject objectWithClassName:@"UserCount"];
            [userCountObject setObject:user forKey:@"User"];
            [userCountObject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    NSLog(@"--------注册的时候需要在UserCount表中加一行数据出错");
                }
            }];
            
            //注册环信
            [[EaseMobManager shareManager] registerWithName:phoneNumber andPassword:password];
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"注册成功！" message:@"是否立刻登录？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [BmobUser loginWithUsernameInBackground:username password:password block:^(BmobUser *user, NSError *error) {
                    if (user) {
                        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        [app showHomeVC];
                    }
                }];
                
                [[EaseMobManager shareManager] loginWithName:phoneNumber andPassword:password];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [self presentViewController:ac animated:YES completion:nil];
        }else{
            [Utils toastViewWithError:error];
        }
    }];

}

@end
