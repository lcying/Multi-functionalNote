//
//  NormalTableViewCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "NormalTableViewCell.h"

@implementation NormalTableViewCell

- (UIImageView *)leftImageView{
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
    }
    return _leftImageView;
}

- (UILabel *)rightLabel{
    if (_rightLabel == nil) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.leftImageView.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
    }
    return _rightLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
