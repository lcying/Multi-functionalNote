//
//  MyAttentionViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "MyAttentionView.h"
#import "AttentionCell.h"

@interface MyAttentionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) MyAttentionView *attentionView;
@property (nonatomic) NSMutableArray<BmobUser *> *allAttentionsArray;

@end

@implementation MyAttentionViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.attentionView.attentionTableView.mj_header beginRefreshing];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)setCurrentTitleString:(NSString *)currentTitleString{
    _currentTitleString = currentTitleString;
    self.title = currentTitleString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allAttentionsArray = [NSMutableArray array];
    
    self.attentionView = [[MyAttentionView alloc] init];
    [self.view addSubview:self.attentionView];
    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.attentionView.attentionTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.attentionView.attentionTableView.delegate = self;
    self.attentionView.attentionTableView.dataSource = self;
    [self.attentionView.attentionTableView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AttentionCell"];
    self.attentionView.attentionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.attentionView.attentionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
}

#pragma mark - Method -------------------------------
//请求数据
- (void)findAllObjects{//下拉刷新
    NSString *key = @"ToUser";
    NSString *key2 = @"User";
    if ([self.currentTitleString isEqualToString:@"关注我的"]) {
        key = @"User";
        key2 = @"ToUser";
    }
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Attention"];
    [bq includeKey:key];
    [bq whereKey:key2 equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    [bq orderByDescending:@"updatedAt"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.attentionView.attentionTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allAttentionsArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                BmobUser *user = [obj objectForKey:key];
                [self.allAttentionsArray addObject:user];
            }
            [self.attentionView.attentionTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    NSString *key = @"ToUser";
    NSString *key2 = @"User";
    if ([self.currentTitleString isEqualToString:@"关注我的"]) {
        key = @"User";
        key2 = @"ToUser";
    }
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Attention"];
    [bq includeKey:key];
    //限制得到的类型
    
    [bq whereKey:key2 equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.allAttentionsArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.attentionView.attentionTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                BmobUser *user = [obj objectForKey:key];
                [self.allAttentionsArray addObject:user];
            }
            [self.attentionView.attentionTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate ----------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allAttentionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttentionCell"];
    }
    cell.stateString = self.currentTitleString;
    BmobUser *user = self.allAttentionsArray[indexPath.row];
    cell.toUser = user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
