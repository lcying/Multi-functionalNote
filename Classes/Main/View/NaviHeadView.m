//
//  NaviHeadView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "NaviHeadView.h"

@implementation NaviHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self leftButton];
        [self rightButton];
        [self titleLabel];
        UIView *lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = [Utils colorRGB:@"#cdcdcd"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.tag = 10;
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(70);
            make.bottom.mas_equalTo(0);
        }];
        [_leftButton setImage:[UIImage imageNamed:@"left"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(8.5, 20, 10.5, 25);
        [_leftButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        [self addSubview:_rightButton];
        _rightButton.tag = 11;
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(70);
            make.bottom.mas_equalTo(0);
        }];
        [_rightButton setImage:[UIImage imageNamed:@"addFile"] forState:UIControlStateNormal];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(8.5, 20, 10.5, 25);
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
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (void)buttonClickedAction:(UIButton *)button{
    _NaviHeadCallBack(button.tag);
}

@end
