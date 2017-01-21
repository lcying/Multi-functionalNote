//
//  LoginView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic) void(^LoginCallBack) (id obj);

@property (nonatomic) UITextField *usernameTF;
@property (nonatomic) UITextField *passwordTF;
@property (nonatomic) UIButton *loginButton;

@end
