//
//  CommentView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "CommentView.h"
#import "CommentCell.h"
#import "SendCommentsViewController.h"

@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allCommentsArray = [NSMutableArray array];
        [self headView];
        [self commentTableView];
        
        __block __weak CommentView *weakself = self;

        [self.headView setHeadCallBack:^(id obj) {
            SendCommentsViewController *vc = [[SendCommentsViewController alloc] init];
            vc.commentObject = weakself.commentObject;
            vc.user = weakself.user;
            [[weakself viewController] presentViewController:vc animated:YES completion:nil];
        }];
    }
    return self;
}

- (HeadView *)headView{
    if (_headView == nil) {
        _headView = [[HeadView alloc] init];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
        _headView.titleLabel.text = @"所有评论";
        [_headView.rightButton setTitle:@"评论" forState:UIControlStateNormal];
    }
    return _headView;
}

- (UITableView *)commentTableView{
    if (_commentTableView == nil) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_commentTableView];
        [_commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.left.right.bottom.mas_equalTo(0);
        }];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_commentTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCell"];
        _commentTableView.tableFooterView = [UIView new];
        _commentTableView.tableHeaderView = self.countLabel;
    }
    return _commentTableView;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 20)];
        _countLabel.text = @"共0条";
        _countLabel.textColor = [UIColor grayColor];
        _countLabel.font = [UIFont systemFontOfSize:13];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCommentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    CommentModel *model = self.allCommentsArray[indexPath.row];
    cell.commentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.allCommentsArray[indexPath.row];
    CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(screenWidth - 50 - 24, 0) andStr:model.comment];
    return 82 + size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
