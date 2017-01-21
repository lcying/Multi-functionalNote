//
//  MyPersonalNoteView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyPersonalNoteView.h"

@implementation MyPersonalNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self noteTableView];
    }
    return self;
}

- (UITableView *)noteTableView{
    if (_noteTableView == nil) {
        _noteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_noteTableView];
        [_noteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _noteTableView.tableFooterView = [UIView new];
    }
    return _noteTableView;
}

@end
