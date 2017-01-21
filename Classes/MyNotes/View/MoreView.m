//
//  MoreView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MoreView.h"

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"windowBack"]];
        [self addSubview:backImageView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        backImageView.alpha = 0.7;
        
        [self moreTableView];
        
    }
    return self;
}

- (UITableView *)moreTableView{
    if (_moreTableView == nil) {
        _moreTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_moreTableView];
        [_moreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
        }];
        _moreTableView.backgroundColor = [UIColor clearColor];
        _moreTableView.bounces = NO;
    }
    return _moreTableView;
}

@end
