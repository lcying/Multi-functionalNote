//
//  AttentMeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "AttentMeView.h"
#import "AttentMeCell.h"

@implementation AttentMeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self attentTableView];
    }
    return self;
}

- (UITableView *)attentTableView{
    if (_attentTableView == nil) {
        _attentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_attentTableView];
        [_attentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        [_attentTableView registerNib:[UINib nibWithNibName:@"AttentMeCell" bundle:nil] forCellReuseIdentifier:@"AttentMeCell"];
        _attentTableView.tableFooterView = [UIView new];
    }
    return _attentTableView;
}

@end
