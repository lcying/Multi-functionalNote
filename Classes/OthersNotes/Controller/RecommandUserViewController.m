//
//  RecommandUserViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "RecommandUserViewController.h"
#import "RecommandView.h"
#import "AttentionCell.h"
#import "OtherPersonalHomeViewController.h"

@interface RecommandUserViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) RecommandView *recommandView;
@property (nonatomic) NSMutableArray<BmobUser *> *recommandUsersArray;

@end

@implementation RecommandUserViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.recommandView.recommandTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recommandUsersArray = [NSMutableArray array];
    self.recommandView = [[RecommandView alloc] init];
    [self.view addSubview:self.recommandView];
    [self.recommandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.recommandView.recommandTableView.delegate = self;
    self.recommandView.recommandTableView.dataSource = self;
    self.recommandView.recommandTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    [self.recommandView.recommandTableView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AttentionCell"];
    self.recommandView.recommandTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.recommandView.recommandTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
}

#pragma mark - UITableView Delegate ------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recommandUsersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttentionCell"];
    }
    BmobUser *user = self.recommandUsersArray[indexPath.row];
    cell.stateString = @"关注我的";
    cell.toUser = user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BmobUser *user = self.recommandUsersArray[indexPath.row];
    OtherPersonalHomeViewController *vc = [[OtherPersonalHomeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.currentUser = user;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Method -------------------------------
//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [BmobQuery queryWithClassName:@"UserCount"];
    bq.limit = 10;
    [bq includeKey:@"User"];
    [bq orderByDescending:@"attentionCount"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.recommandView.recommandTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.recommandUsersArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                [self.recommandUsersArray addObject:[obj objectForKey:@"User"]];
            }
            [self.recommandView.recommandTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [BmobQuery queryWithClassName:@"UserCount"];
    bq.limit = 10;
    [bq includeKey:@"User"];
    bq.skip = self.recommandUsersArray.count;
    [bq orderByDescending:@"attentionCount"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.recommandView.recommandTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                [self.recommandUsersArray addObject:[obj objectForKey:@"User"]];
            }
            [self.recommandView.recommandTableView reloadData];
        }
    }];
}

@end
