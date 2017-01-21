//
//  ForgetPasswordView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ForgetPasswordView.h"

@implementation ForgetPasswordView

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
        
        //验证码倒计时60s
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(countDownAction)];
        self.link.frameInterval = 60;
        [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.link.paused = YES;
        
        [self phoneTF];
        [self sureButton];
    }
    return self;
}

- (UITextField *)phoneTF{
    if (_phoneTF == nil) {
        _phoneTF = [Utils returnTextFieldWithImageName:@"phone" andPlaceholder:@"请输入手机号"];
        _phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_phoneTF];
        [_phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(104);
        }];
    }
    return _phoneTF;
}

- (UIButton *)sureButton{
    if (_sureButton == nil) {
        _sureButton = [Utils returnButtonWithTitle:@"获取验证码"];
        [self addSubview:_sureButton];
        [_sureButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneTF.mas_bottom).mas_equalTo(40);
            make.centerX.mas_equalTo(0);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(40);
        }];
    }
    return _sureButton;
}

- (UITextField *)captchaTF{
    if (_captchaTF == nil) {
        _captchaTF = [Utils returnTextFieldWithImageName:@"captcha" andPlaceholder:@"请输入验证码"];
        _captchaTF.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_captchaTF];
        [_captchaTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-80);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.phoneTF.mas_bottom).mas_equalTo(20);
        }];
    }
    return _captchaTF;
}

- (UILabel *)captchaLabel{
    if (_captchaLabel == nil) {
        _captchaLabel = [[UILabel alloc] init];
        [self addSubview:_captchaLabel];
        _captchaLabel.backgroundColor = [UIColor whiteColor];
        _captchaLabel.text = @"60s";
        _captchaLabel.textColor = [Utils colorRGB:@"#cd0000"];
        _captchaLabel.layer.cornerRadius = 20;
        _captchaLabel.layer.masksToBounds = YES;
        _captchaLabel.textAlignment = NSTextAlignmentCenter;
        self.link.paused = NO;
        [_captchaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.captchaTF.mas_right).mas_equalTo(10);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(self.phoneTF.mas_bottom).mas_equalTo(20);
        }];
    }
    return _captchaLabel;
}

- (UITextField *)passwordTF{
    if (_passwordTF == nil) {
        _passwordTF = [Utils returnTextFieldWithImageName:@"password" andPlaceholder:@"请输入6-12位新密码"];
        [self addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.captchaTF.mas_bottom).mas_equalTo(20);
        }];
    }
    return _passwordTF;
}

#pragma mark - Method ----------------------------------------

- (void)buttonClickedAction:(UIButton *)button{
    NSString *titleString = button.currentTitle;
    if ([titleString isEqualToString:@"获取验证码"]) {
        NSString *phoneString = self.phoneTF.text;
        if ([Utils isMobile:phoneString] == YES) {
            //验证手机号格式
            [self captchaTF];
            [self passwordTF];
            [self captchaLabel];
            [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(40);
                make.width.mas_equalTo(180);
                make.top.mas_equalTo(self.passwordTF.mas_bottom).mas_equalTo(40);
            }];
            [self.sureButton setTitle:@"确  定" forState:UIControlStateNormal];
        }else{
            [Utils toastViewWithTitle:@"请输入正确手机号" andBackColor:[UIColor whiteColor] andTextColor:[UIColor darkGrayColor]];
            return;
        }
    }
    if ([titleString isEqualToString:@"确  定"]) {
        [self endEditing:YES];
        if ([self.captchaTF.text isEqualToString:@""]) {
            [Utils toastViewWithTitle:@"请输入验证码" andBackColor:[UIColor whiteColor] andTextColor:[UIColor darkGrayColor]];
            return;
        }
        //验证密码安全性
        if ([Utils checkPassword:self.passwordTF.text] == NO) {
            [Utils toastViewWithTitle:@"请输入6-12位数字字母组合新密码" andBackColor:[UIColor whiteColor] andTextColor:[UIColor darkGrayColor]];
            return;
        }
    }
    _ForgetPasswordCallBack(titleString);
}

- (void)countDownAction{
    NSString *titleString = [self.captchaLabel.text componentsSeparatedByString:@"s"].firstObject;
    int titleNumber = [titleString intValue] - 1;
    NSString *changeTitle = [NSString stringWithFormat:@"%ds",titleNumber];
    self.captchaLabel.text = changeTitle;
    if (titleNumber == 0) {
        self.link.paused = YES;
        return;
    }
}

@end
