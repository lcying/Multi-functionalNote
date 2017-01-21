//
//  RecommandView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "RecommandView.h"

@implementation RecommandView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self recommandTableView];
    }
    return self;
}

- (UITableView *)recommandTableView{
    if (_recommandTableView == nil) {
        _recommandTableView = [[UITableView alloc] init];
        [self addSubview:_recommandTableView];
        [_recommandTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _recommandTableView.tableFooterView = [UIView new];
    }
    return _recommandTableView;
}

@end
