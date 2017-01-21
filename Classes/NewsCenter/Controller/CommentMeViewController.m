//
//  CommentMeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "CommentMeViewController.h"
#import "CommentModel.h"
#import "CommentMeView.h"
#import "ZanMeCell.h"

@interface CommentMeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) CommentMeView *commentView;
@property (nonatomic) NSMutableArray<CommentModel *> *allCommentsArray;

@end

@implementation CommentMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allCommentsArray = [NSMutableArray array];
    
    self.title = @"评论及回复";
    
    self.commentView = [[CommentMeView alloc] init];
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    self.commentView.commentTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    
    self.commentView.commentTableView.delegate = self;
    self.commentView.commentTableView.dataSource = self;
    
    self.commentView.commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findZans];
    }];
    
    self.commentView.commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreZans];
    }];
    
    [self.commentView.commentTableView.mj_header beginRefreshing];
}

#pragma mark - Method request

- (void)findZans{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"User"];
    [query includeKey:@"Note"];
    [query includeKey:@"CommentPointer"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.commentView.commentTableView.mj_header endRefreshing];
        if (array.count > 0) {
            self.allCommentsArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                CommentModel *model = [[CommentModel alloc] initWithBmobObject:object];
                [self.allCommentsArray addObject:model];
            }
            [self.commentView.commentTableView reloadData];
        }
    }];
}

- (void)loadMoreZans{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"User"];
    [query includeKey:@"Note"];
    [query includeKey:@"CommentPointer"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    query.skip = self.allCommentsArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.commentView.commentTableView.mj_footer endRefreshing];
        if (array.count > 0) {
            for (BmobObject *object in array) {
                CommentModel *model = [[CommentModel alloc] initWithBmobObject:object];
                [self.allCommentsArray addObject:model];
            }
            [self.commentView.commentTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCommentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.allCommentsArray[indexPath.row];
    ZanMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanMeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZanMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZanMeCell"];
    }
    cell.commentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 172;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
