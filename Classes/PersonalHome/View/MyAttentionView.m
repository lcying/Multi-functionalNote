//
//  MyAttentionView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyAttentionView.h"

@implementation MyAttentionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attentionTableView];
    }
    return self;
}

- (UITableView *)attentionTableView{
    if (_attentionTableView == nil) {
        _attentionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_attentionTableView];
        [_attentionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _attentionTableView.tableFooterView = [UIView new];
    }
    return _attentionTableView;
}

@end
