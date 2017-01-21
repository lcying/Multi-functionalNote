//
//  CommentsViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "CommentsViewController.h"
#import "CommentModel.h"

@interface CommentsViewController ()

@property (nonatomic) NSMutableArray *allCommentsArray;

@end

@implementation CommentsViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self findAllZanObjectId];
    [self.commentView.commentTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentView = [[CommentView alloc] init];
    self.commentView.commentObject = self.noteModel.bmobObject;
    self.commentView.user = self.noteModel.User;
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.commentView.commentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.commentView.commentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
}

//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Comment"];
    [bq includeKey:@"User"];
    bq.limit = 10;
    [bq whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [bq orderByDescending:@"updatedAt"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.commentView.commentTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allCommentsArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                CommentModel *comment = [[CommentModel alloc] initWithBmobObject:obj];
                //如果在zan数组中
                comment.isZaned = NO;
                if ([self.allZanedCommentIdArray containsObject:obj.objectId]) {
                    comment.isZaned = YES;
                }
                [self.allCommentsArray addObject:comment];
            }
            self.commentView.countLabel.text = [NSString stringWithFormat:@"共%ld条",self.allCommentsArray.count];
            self.commentView.allCommentsArray = self.allCommentsArray;
            [self.commentView.commentTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Comment"];
    [bq includeKey:@"User"];
    //限制得到的类型
    
    bq.limit = 10;
    bq.skip = self.allCommentsArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    [bq whereKey:@"Note" equalTo:self.noteModel.bmobObject];

    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.commentView.commentTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                CommentModel *comment = [[CommentModel alloc] initWithBmobObject:obj];
                comment.isZaned = NO;
                if ([self.allZanedCommentIdArray containsObject:obj.objectId]) {
                    comment.isZaned = YES;
                }
                [self.allCommentsArray addObject:comment];
            }
            self.commentView.countLabel.text = [NSString stringWithFormat:@"共%ld条",self.allCommentsArray.count];
            self.commentView.allCommentsArray = self.allCommentsArray;
            [self.commentView.commentTableView reloadData];
        }
    }];
}

//加载当前笔记当前用户的所有赞
- (void)findAllZanObjectId{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query includeKey:@"Comment"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [query whereKeyExists:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array && array.count > 0) {
            self.allZanedCommentIdArray = [NSMutableArray array];
            for (BmobObject *zanObj in array) {
                BmobObject *commentObject = [zanObj objectForKey:@"Comment"];
                [self.allZanedCommentIdArray addObject:commentObject.objectId];
            }
        }
    }];
}

@end
