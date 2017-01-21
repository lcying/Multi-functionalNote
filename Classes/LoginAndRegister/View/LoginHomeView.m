//
//  LoginHomeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LoginHomeView.h"

@implementation LoginHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backImageView];
        [self loginButton];
        [self registerButton];
        [self forgetPasswordButton];
        
        UILabel *otherLabel = [[UILabel alloc] init];
        otherLabel.text = @"———— 其它登录方式 ————";
        [self addSubview:otherLabel];
        otherLabel.textColor = [UIColor whiteColor];
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
        }];
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.font = [UIFont systemFontOfSize:14];
        
        [self weixinButton];
        [self sinaButton];
    }
    return self;
}

#pragma mark - LazyLoading--------------------------------

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        _backImageView.image = [UIImage imageNamed:@"cityBackImage"];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _backImageView;
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [Utils returnButtonWithTitle:@"登  录"];
        [self addSubview:_loginButton];
        _loginButton.tag = 1;
        [_loginButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(40);
        }];
    }
    return _loginButton;
}

- (UIButton *)registerButton{
    if (_registerButton == nil) {
        _registerButton = [Utils returnButtonWithTitle:@"注  册"];
        [self addSubview:_registerButton];
        _registerButton.tag = 2;
        [_registerButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.loginButton.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(40);
        }];
    }
    return _registerButton;
}

- (UIButton *)forgetPasswordButton{
    if (_forgetPasswordButton == nil) {
        _forgetPasswordButton = [[UIButton alloc] init];
        [self addSubview:_forgetPasswordButton];
        [_forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetPasswordButton.tag = 3;
        [_forgetPasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:16];

        [_forgetPasswordButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.registerButton.mas_bottom).mas_equalTo(20);
        }];
    }
    return _forgetPasswordButton;
}

- (UIButton *)weixinButton{
    if (_weixinButton == nil) {
        _weixinButton = [[UIButton alloc] init];
        [self addSubview:_weixinButton];
        [_weixinButton setBackgroundImage:[UIImage imageNamed:@"weixinlogo"] forState:UIControlStateNormal];
        _weixinButton.tag = 10;
        [_weixinButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-40);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _weixinButton;
}

- (UIButton *)sinaButton{
    if (_sinaButton == nil) {
        _sinaButton = [[UIButton alloc] init];
        [self addSubview:_sinaButton];
        [_sinaButton setBackgroundImage:[UIImage imageNamed:@"sinalogo"] forState:UIControlStateNormal];
        _sinaButton.tag = 11;
        [_sinaButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(40);
            make.width.mas_equalTo(35);
            make.height.mas_equalTo(30);
            make.bottom.mas_equalTo(-15);
        }];
    }
    return _sinaButton;
}

#pragma mark - Method-------------------------------

- (void)buttonClickedAction:(UIButton *)button{
    _LoginCallBack(button.tag);
}

@end
