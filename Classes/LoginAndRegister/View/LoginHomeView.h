//
//  LoginHomeView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginHomeView : UIView

@property (nonatomic) void(^LoginCallBack) (NSInteger tag);

@property (nonatomic) UIImageView *backImageView;
@property (nonatomic) UIButton *loginButton;
@property (nonatomic) UIButton *registerButton;
@property (nonatomic) UIButton *forgetPasswordButton;
@property (nonatomic) UIButton *weixinButton;
@property (nonatomic) UIButton *sinaButton;

@end
