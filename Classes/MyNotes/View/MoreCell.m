//
//  MoreCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (UILabel *)moreLabel{
    if (_moreLabel == nil) {
        _moreLabel = [[UILabel alloc] init];
        [self addSubview:_moreLabel];
        [_moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _moreLabel.textColor = [UIColor whiteColor];
        _moreLabel.font = [UIFont systemFontOfSize:14];
        _moreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moreLabel;
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
