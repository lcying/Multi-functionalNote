//
//  NotesHomeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "NotesHomeView.h"

@implementation NotesHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headerView];
        [self contentScrollView];
    }
    return self;
}

- (MainTableHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[MainTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
        [self addSubview:_headerView];
    }
    return _headerView;
}

- (UITableView *)latestNoteTableView{
    if (_latestNoteTableView == nil) {
        _latestNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64 - 46) style:UITableViewStylePlain];
        _latestNoteTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _latestNoteTableView.tag = 100;
        _latestNoteTableView.tableFooterView = [UIView new];
    }
    return _latestNoteTableView;
}

- (UITableView *)allNoteTableView{
    if (_allNoteTableView == nil) {
        _allNoteTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight - 64 - 46) style:UITableViewStylePlain];
        _allNoteTableView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        _allNoteTableView.tag = 200;
        _allNoteTableView.tableFooterView = [UIView new];
    }
    return _allNoteTableView;
}


- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] init];
        [self addSubview:_contentScrollView];
        [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.headerView.mas_bottom).mas_equalTo(0);
        }];
        _contentScrollView.contentSize = CGSizeMake(screenWidth*2, 0);
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.bounces = NO;
        _contentScrollView.pagingEnabled = YES;
        [_contentScrollView addSubview:self.latestNoteTableView];
        [_contentScrollView addSubview:self.allNoteTableView];
    }
    return _contentScrollView;
}

@end
