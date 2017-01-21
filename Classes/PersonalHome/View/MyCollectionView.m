//
//  MyCollectionView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyCollectionView.h"

@implementation MyCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self collectionTableView];
    }
    return self;
}

- (UITableView *)collectionTableView{
    if (_collectionTableView == nil) {
        _collectionTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_collectionTableView];
        [_collectionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _collectionTableView.tableFooterView = [UIView new];
    }
    return _collectionTableView;
}

@end
