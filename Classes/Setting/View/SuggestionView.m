//
//  SuggestionView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SuggestionView.h"

@implementation SuggestionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self contentView];
        [self submitButton];
        self.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);

    }
    return self;
}

- (UITextView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UITextView alloc] init];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(200);
        }];
        _contentView.textColor = [UIColor darkGrayColor];
        _contentView.font = [UIFont systemFontOfSize:15];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIButton *)submitButton{
    if (_submitButton == nil) {
        _submitButton = [[UIButton alloc] init];
        [self addSubview:_submitButton];
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.contentView.mas_bottom).mas_equalTo(20);
            make.height.mas_equalTo(50);
        }];
        [_submitButton setTitle:@"提  交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor whiteColor];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (void)submitAction:(UIButton *)button{
    _SubmitCallBack(button);
}

@end
