//
//  MessageListView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/23.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MessageListView.h"

@implementation MessageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor], [UIColor lightGrayColor]);
        
    }
    return self;
}

- (UITableView *)listTableView{
    if (_listTableView == nil) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_listTableView];
        [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _listTableView.tableFooterView = [UIView new];
    }
    return _listTableView;
}

@end
