//
//  ForgetPasswordView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordView : UIView

@property (nonatomic) void(^ForgetPasswordCallBack) (NSString *title);

@property (nonatomic) UITextField *phoneTF;
@property (nonatomic) UIButton *sureButton;
@property (nonatomic) UITextField *captchaTF;
@property (nonatomic) UITextField *passwordTF;
@property (nonatomic) UILabel *captchaLabel;
@property (nonatomic) CADisplayLink *link;

@end
