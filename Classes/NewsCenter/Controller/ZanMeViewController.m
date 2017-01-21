//
//  ZanMeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ZanMeViewController.h"
#import "ZanMeView.h"
#import "ZanModel.h"
#import "ZanMeCell.h"

@interface ZanMeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) ZanMeView *zanView;
@property (nonatomic) NSMutableArray<ZanModel *> *allZansArray;
@end

@implementation ZanMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allZansArray = [NSMutableArray array];
    
    self.title = @"赞过我的";
    
    self.zanView = [[ZanMeView alloc] init];
    [self.view addSubview:self.zanView];
    [self.zanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    self.zanView.zanTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    
    self.zanView.zanTableView.delegate = self;
    self.zanView.zanTableView.dataSource = self;
    
    self.zanView.zanTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findZans];
    }];
    
    self.zanView.zanTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreZans];
    }];
    
    [self.zanView.zanTableView.mj_header beginRefreshing];
}

#pragma mark - Method request

- (void)findZans{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query includeKey:@"User"];
    [query includeKey:@"Note"];
    [query includeKey:@"Comment"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query orderByDescending:@"createdAt"];
    query.limit = 10;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.zanView.zanTableView.mj_header endRefreshing];
        if (array.count > 0) {
            self.allZansArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                ZanModel *model = [[ZanModel alloc] initWithBmobObject:object];
                [self.allZansArray addObject:model];
            }
            [self.zanView.zanTableView reloadData];
        }
    }];
}

- (void)loadMoreZans{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query includeKey:@"User"];
    [query includeKey:@"Note"];
    [query includeKey:@"Comment"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    query.skip = self.allZansArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.zanView.zanTableView.mj_footer endRefreshing];
        if (array.count > 0) {
            for (BmobObject *object in array) {
                ZanModel *model = [[ZanModel alloc] initWithBmobObject:object];
                [self.allZansArray addObject:model];
            }
            [self.zanView.zanTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allZansArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZanModel *model = self.allZansArray[indexPath.row];
    ZanMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZanMeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ZanMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZanMeCell"];
    }
    cell.zanModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZanModel *model = self.allZansArray[indexPath.row];
    if (model.Note == nil) {
        return 93;
    }else{
        if (model.Comment == nil) {
            return 124;
        }else{
            return 172;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
