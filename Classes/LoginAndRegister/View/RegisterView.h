//
//  RegisterView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterView : UIView

@property (nonatomic) void(^RegisterCallBack) (NSString *title);

@property (nonatomic) UITextField *phoneTF;
@property (nonatomic) UIButton *registerButton;
@property (nonatomic) UITextField *captchaTF;
@property (nonatomic) UITextField *passwordTF;
@property (nonatomic) UILabel *captchaLabel;
@property (nonatomic) UITextField *nickTF;
@property (nonatomic) CADisplayLink *link;

@end
