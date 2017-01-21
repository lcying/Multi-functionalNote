//
//  UserSatisfactionView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "UserSatisfactionView.h"

@implementation UserSatisfactionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self userTableView];
        [self headLabel];
        self.userTableView.tableHeaderView = self.headLabel;
    }
    return self;
}

- (UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
        _headLabel.textAlignment = NSTextAlignmentLeft;
        _headLabel.numberOfLines = 0;
        _headLabel.text = @"    请对随便笔记做个评价，谢谢！";
        _headLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor lightGrayColor],[UIColor lightGrayColor]);
        _headLabel.font = [UIFont systemFontOfSize:15];
        _headLabel.backgroundColor = [UIColor clearColor];
    }
    return _headLabel;
}

- (UITableView *)userTableView{
    if (_userTableView == nil) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_userTableView];
        [_userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _userTableView.tableFooterView = [UIView new];
    }
    return _userTableView;
}

@end
