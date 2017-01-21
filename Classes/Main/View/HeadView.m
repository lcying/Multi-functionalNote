//
//  HeadView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self leftButton];
        [self rightButton];
        [self titleLabel];
    }
    return self;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(20);
        }];
        [_leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_leftButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(20);
        }];
        [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_rightButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftButton.mas_right).mas_equalTo(0);
            make.right.mas_equalTo(self.rightButton.mas_left).mas_equalTo(0);
            make.top.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
        }];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (void)buttonClickedAction:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"返回"]) {
        UIViewController *viewController = [self viewController];
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        _HeadCallBack(button);
    }
}

@end
