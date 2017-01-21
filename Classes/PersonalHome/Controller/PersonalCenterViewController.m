//
//  PersonalCenterViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/6.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "PersonalCenterView.h"
#import "NewsCenterViewController.h"

@interface PersonalCenterViewController ()

@property (nonatomic) PersonalCenterView *personalCenterView;

@end

@implementation PersonalCenterViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.view.backgroundColor = [Utils colorRGB:@"#f9f9f9"];
    
    self.personalCenterView = [[PersonalCenterView alloc] init];
    [self.view addSubview:self.personalCenterView];
    [self.personalCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    UITableView *openNoteTableView = self.personalCenterView.contentTableViewsArray[0];
    openNoteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestNotesWithString:@"YES"];
    }];
    
    openNoteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreNotesWithString:@"YES"];
    }];
    
    self.personalCenterView.contentTableViewsArray[1].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestNotesWithString:@"NO"];
    }];
    
    self.personalCenterView.contentTableViewsArray[1].mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreNotesWithString:@"NO"];
    }];
    
    self.personalCenterView.contentTableViewsArray[2].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestAttentions];
    }];
    
    self.personalCenterView.contentTableViewsArray[2].mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreAttentions];
    }];
    
    self.personalCenterView.contentTableViewsArray[3].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestCollections];
    }];
    
    self.personalCenterView.contentTableViewsArray[3].mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreCollections];
    }];
    
    self.personalCenterView.contentTableViewsArray[4].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestComments];
    }];
    
    self.personalCenterView.contentTableViewsArray[4].mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreComments];
    }];
    
    for (UITableView *tableView in self.personalCenterView.contentTableViewsArray) {
        [tableView.mj_header beginRefreshing];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bell"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoNewsCenterAction)];;
    
}

#pragma mark - Method --------------------------------------

- (void)gotoNewsCenterAction{
    NewsCenterViewController *vc = [[NewsCenterViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Method get data ----------------------------
//公开私密笔记
- (void)requestNotesWithString:(NSString *)key{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    query.limit = 10;
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"isOpen" equalTo:key];
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if ([key isEqualToString:@"YES"]) {
            [self.personalCenterView.contentTableViewsArray.firstObject.mj_header endRefreshing];
        }else{
            [self.personalCenterView.contentTableViewsArray[1].mj_header endRefreshing];
        }
        
        if (array.count > 0) {
            
            if ([key isEqualToString:@"YES"]) {
                self.personalCenterView.openNotesArray = [NSMutableArray array];
                for (BmobObject *object in array) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                    [self.personalCenterView.openNotesArray addObject:noteModel];
                }
                [self.personalCenterView.contentTableViewsArray.firstObject reloadData];
            }else{
                self.personalCenterView.secretNoteArray = [NSMutableArray array];
                for (BmobObject *object in array) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                    [self.personalCenterView.secretNoteArray addObject:noteModel];
                }
                [self.personalCenterView.contentTableViewsArray[1] reloadData];
            }
            
        }
    }];
}

- (void)requestMoreNotesWithString:(NSString *)key{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    query.limit = 10;
    query.skip = self.personalCenterView.openNotesArray.count;
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"isOpen" equalTo:key];
    [query orderByDescending:@"createdAt"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if ([key isEqualToString:@"YES"]) {
            [self.personalCenterView.contentTableViewsArray.firstObject.mj_footer endRefreshing];
        }else{
            [self.personalCenterView.contentTableViewsArray[1].mj_footer endRefreshing];
        }
        
        if (array.count > 0) {
            if ([key isEqualToString:@"YES"]) {
                for (BmobObject *object in array) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                    [self.personalCenterView.openNotesArray addObject:noteModel];
                }
                [self.personalCenterView.contentTableViewsArray.firstObject reloadData];
            }else{
                for (BmobObject *object in array) {
                    NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                    [self.personalCenterView.secretNoteArray addObject:noteModel];
                }
                [self.personalCenterView.contentTableViewsArray[1] reloadData];
            }
        }
    }];
}

//我的关注
- (void)requestAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    query.limit = 10;
    [query includeKey:@"ToUser"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[2].mj_header endRefreshing];
        if (array) {
            self.personalCenterView.myAttentionsArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                BmobUser *toUser = [object objectForKey:@"ToUser"];
                [self.personalCenterView.myAttentionsArray addObject:toUser];
            }
            [self.personalCenterView.contentTableViewsArray[2] reloadData];
        }
    }];
}

- (void)requestMoreAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    query.limit = 10;
    query.skip = self.personalCenterView.myAttentionsArray.count;
    [query includeKey:@"ToUser"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[2].mj_footer endRefreshing];
        if (array) {
            for (BmobObject *object in array) {
                BmobUser *toUser = [object objectForKey:@"ToUser"];
                [self.personalCenterView.myAttentionsArray addObject:toUser];
            }
            [self.personalCenterView.contentTableViewsArray[2] reloadData];
        }
    }];
}

//我的收藏
- (void)requestCollections{
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Collection"];
    [bq includeKey:@"Note"];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[3].mj_header endRefreshing];
        if (array.count > 0){
            self.personalCenterView.myCollectionsArray = [NSMutableArray array];
            self.personalCenterView.myCollectionsIDsArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:[obj objectForKey:@"Note"]];
                [self.personalCenterView.myCollectionsIDsArray addObject:obj.objectId];
                [self.personalCenterView.myCollectionsArray addObject:note];
            }
            [self.personalCenterView.contentTableViewsArray[3] reloadData];
        }
    }];
}

- (void)requestMoreCollections{
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Collection"];
    [bq includeKey:@"Note"];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.personalCenterView.myCollectionsArray.count;
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[3].mj_footer endRefreshing];
        if (array.count > 0){
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:[obj objectForKey:@"Note"]];
                [self.personalCenterView.myCollectionsIDsArray addObject:obj.objectId];
                [self.personalCenterView.myCollectionsArray addObject:note];
            }
            [self.personalCenterView.contentTableViewsArray[3] reloadData];
        }
    }];
}

//我的评论
- (void)requestComments{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"Note"];
    query.limit = 10;
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[4].mj_header endRefreshing];
        if (array.count > 0) {
            self.personalCenterView.myCommentsArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                [self.personalCenterView.myCommentsArray addObject:object];
            }
            [self.personalCenterView.contentTableViewsArray[4] reloadData];
        }
    }];
}

- (void)requestMoreComments{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query includeKey:@"Note"];
    query.limit = 10;
    query.skip = self.personalCenterView.myCommentsArray.count;
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.personalCenterView.contentTableViewsArray[4].mj_footer endRefreshing];
        if (array.count > 0) {
            for (BmobObject *object in array) {
                [self.personalCenterView.myCommentsArray addObject:object];
            }
            [self.personalCenterView.contentTableViewsArray[4] reloadData];
        }
    }];
}

@end
