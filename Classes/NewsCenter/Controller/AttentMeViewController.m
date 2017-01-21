//
//  AttentMeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "AttentMeViewController.h"
#import "AttentMeView.h"
#import "AttentMeCell.h"
#import "OtherPersonalHomeViewController.h"

@interface AttentMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) AttentMeView *attentView;
@property (nonatomic) NSMutableArray<BmobUser *> *allAttentionsArray;
@end

@implementation AttentMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allAttentionsArray = [NSMutableArray array];
    
    self.title = @"关注我的";
    
    self.attentView = [[AttentMeView alloc] init];
    [self.view addSubview:self.attentView];
    [self.attentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    self.attentView.attentTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    
    self.attentView.attentTableView.delegate = self;
    self.attentView.attentTableView.dataSource = self;
    
    self.attentView.attentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAttentions];
    }];
    
    self.attentView.attentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreAttentions];
    }];
    
    [self.attentView.attentTableView.mj_header beginRefreshing];
}

#pragma mark - Method request

- (void)findAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query includeKey:@"ToUser"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.attentView.attentTableView.mj_header endRefreshing];
        if (array.count > 0) {
            self.allAttentionsArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                BmobUser *user = [object objectForKey:@"ToUser"];
                [self.allAttentionsArray addObject:user];
            }
            [self.attentView.attentTableView reloadData];
        }
    }];
}

- (void)loadMoreAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query includeKey:@"ToUser"];
    query.limit = 10;
    query.skip = self.allAttentionsArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.attentView.attentTableView.mj_footer endRefreshing];
        if (array.count > 0) {
            for (BmobObject *object in array) {
                BmobUser *user = [object objectForKey:@"ToUser"];
                [self.allAttentionsArray addObject:user];
            }
            [self.attentView.attentTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allAttentionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AttentMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentMeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AttentMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttentMeCell"];
    }
    BmobUser *user = self.allAttentionsArray[indexPath.row];
    cell.usernameLabel.text = [user objectForKey:@"username"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 93;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OtherPersonalHomeViewController *vc = [[OtherPersonalHomeViewController alloc] init];
    vc.currentUser = self.allAttentionsArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
