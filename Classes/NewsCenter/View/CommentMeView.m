//
//  CommentMeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "CommentMeView.h"

@implementation CommentMeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commentTableView];
    }
    return self;
}

- (UITableView *)commentTableView{
    if (_commentTableView == nil) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_commentTableView];
        [_commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        [_commentTableView registerNib:[UINib nibWithNibName:@"ZanMeCell" bundle:nil] forCellReuseIdentifier:@"ZanMeCell"];
        
        _commentTableView.tableFooterView = [UIView new];
    }
    return _commentTableView;
}


@end
