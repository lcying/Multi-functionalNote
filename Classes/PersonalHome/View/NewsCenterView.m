//
//  NewsCenterView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/10.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "NewsCenterView.h"
#import "LeftImageRightTitleCell.h"

@interface NewsCenterView ()

@property (nonatomic) NSArray *titlesArray;
@property (nonatomic) NSArray *imagesArray;

@end

@implementation NewsCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArray = @[@"私信",@"关注",@"赞",@"评论及回复",@"随便笔记"];
        self.imagesArray = @[@"orangeConnect",@"orangeAttention",@"orangeZan",@"orangeComment",@"orangeAboutUs"];
        [self newsTableView];
    }
    return self;
}

- (UITableView *)newsTableView{
    if (_newsTableView == nil) {
        _newsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_newsTableView];
        [_newsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(0);
        }];
        _newsTableView.tableFooterView = [UIView new];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        [_newsTableView registerNib:[UINib nibWithNibName:@"LeftImageRightTitleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LeftImageRightTitleCell"];
        _newsTableView.bounces = NO;
    }
    return _newsTableView;
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ec6c00
    LeftImageRightTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LeftImageRightTitleCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LeftImageRightTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LeftImageRightTitleCell"];
    }
    cell.leftImageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    cell.rightTitleLabel.text = self.titlesArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _NewsCallBack(indexPath.row);
}

@end
