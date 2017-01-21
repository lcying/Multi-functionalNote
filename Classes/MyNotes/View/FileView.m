//
//  FileView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "FileView.h"

@implementation FileView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headView];
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
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
        }];
    }
    return _fileTableView;
}

@end
