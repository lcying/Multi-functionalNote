//
//  LoginView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc] init];
        [self addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        backImageView.image = [UIImage imageNamed:@"backImageW"];
        [self usernameTF];
        [self passwordTF];
        [self loginButton];
    }
    return self;
}

- (UITextField *)usernameTF{
    if (_usernameTF == nil) {
        _usernameTF = [Utils returnTextFieldWithImageName:@"username" andPlaceholder:@"请输入用户名／手机号码"];
        [self addSubview:_usernameTF];
        [_usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(104);
        }];
    }
    return _usernameTF;
}

- (UITextField *)passwordTF{
    if (_passwordTF == nil) {
        _passwordTF = [Utils returnTextFieldWithImageName:@"password" andPlaceholder:@"请输入密码"];
        _passwordTF.secureTextEntry = YES;
        [self addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.usernameTF.mas_bottom).mas_equalTo(20);
        }];
    }
    return _passwordTF;
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [Utils returnButtonWithTitle:@"登  录"];
        [self addSubview:_loginButton];
        _loginButton.tag = 1;
        [_loginButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.passwordTF.mas_bottom).mas_equalTo(40);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(40);
        }];
    }
    return _loginButton;
}

#pragma mark - Method -----------------------------
- (void)buttonClickedAction:(UIButton *)button{
    _LoginCallBack(button);
}

@end
