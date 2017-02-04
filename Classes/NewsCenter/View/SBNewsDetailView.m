//
//  SBNewsDetailView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/2/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "SBNewsDetailView.h"

@implementation SBNewsDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel];
        [self contentTextView];
    }
    return self;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(60);
        }];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        [self addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.textColor = [Utils colorRGB:@"#333333"];
        _contentTextView.editable = NO;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.bounces = NO;
    }
    return _contentTextView;
}

@end
