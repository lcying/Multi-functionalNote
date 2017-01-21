//
//  OnlyFileView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/14.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "OnlyFileView.h"

@implementation OnlyFileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headView];
        [self changeButton];
        [self fileTableView];
    }
    return self;
}

- (FileHeadView *)headView{
    if (_headView == nil) {
        _headView = [[FileHeadView alloc] init];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
    }
    return _headView;
}

- (UITableView *)fileTableView{
    if (_fileTableView == nil) {
        _fileTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _fileTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _fileTableView.tableFooterView = [UIView new];
        [self addSubview:_fileTableView];
        [_fileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(self.changeButton.mas_top).mas_equalTo(0);
        }];
    }
    return _fileTableView;
}

- (UIButton *)changeButton{
    if (_changeButton == nil) {
        _changeButton = [[UIButton alloc] init];
        [self addSubview:_changeButton];
        [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(60);
        }];
        [_changeButton setTitle:@"确定移动" forState:UIControlStateNormal];
        [_changeButton setBackgroundColor:[Utils colorRGB:@"#cccccc"]];
        [_changeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _changeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _changeButton;
}

@end
