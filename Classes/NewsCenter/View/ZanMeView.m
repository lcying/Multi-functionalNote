//
//  ZanMeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ZanMeView.h"

@implementation ZanMeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self zanTableView];
    }
    return self;
}

- (UITableView *)zanTableView{
    if (_zanTableView == nil) {
        _zanTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_zanTableView];
        [_zanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        [_zanTableView registerNib:[UINib nibWithNibName:@"ZanMeCell" bundle:nil] forCellReuseIdentifier:@"ZanMeCell"];

        _zanTableView.tableFooterView = [UIView new];
    }
    return _zanTableView;
}

@end
