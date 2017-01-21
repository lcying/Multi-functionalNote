//
//  MyCollectionViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionView.h"
#import "OtherPicCell.h"
#import "OtherTextCell.h"
#import "PicNoteViewController.h"
#import "TextNoteViewController.h"
#import "PaintingNoteViewController.h"

@interface MyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MyCollectionView *collectionView;
@property (nonatomic) NSMutableArray<NoteModel *> *allCollectionsArray;
@property (nonatomic) NSMutableArray *allCollectionIdsArray;
@end

@implementation MyCollectionViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏";
    self.allCollectionsArray = [NSMutableArray array];
    self.allCollectionIdsArray = [NSMutableArray array];
    self.collectionView = [[MyCollectionView alloc] init];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.collectionView.collectionTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.collectionView.collectionTableView.delegate = self;
    self.collectionView.collectionTableView.dataSource = self;
    
    [self.collectionView.collectionTableView registerNib:[UINib nibWithNibName:@"OtherTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherTextCell"];
    [self.collectionView.collectionTableView registerNib:[UINib nibWithNibName:@"OtherPicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherPicCell"];
    
    self.collectionView.collectionTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.collectionView.collectionTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"CollectionViewRefresh" object:nil];
    
    [self.collectionView.collectionTableView.mj_header beginRefreshing];
}

#pragma mark - Method -------------------------------

- (void)refreshAction{
    [self.collectionView.collectionTableView.mj_header beginRefreshing];
}

//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Collection"];
    [bq includeKey:@"Note"];

    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.collectionView.collectionTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allCollectionsArray = [NSMutableArray array];
            self.allCollectionIdsArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:[obj objectForKey:@"Note"]];
                [self.allCollectionIdsArray addObject:obj.objectId];
                [self.allCollectionsArray addObject:note];
            }
            [self.collectionView.collectionTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Collection"];
    [bq includeKey:@"Note"];
    //限制得到的类型
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.allCollectionsArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.collectionView.collectionTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:[obj objectForKey:@"Note"]];
                [self.allCollectionIdsArray addObject:obj.objectId];
                [self.allCollectionsArray addObject:note];
            }
            [self.collectionView.collectionTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCollectionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *noteModel = self.allCollectionsArray[indexPath.row];
    if ([noteModel.type isEqualToString:@"0"]) {
        //文字笔记
        OtherTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherTextCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OtherTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherTextCell"];
        }
        cell.noteModel = noteModel;
        cell.collectionObjectId = self.allCollectionIdsArray[indexPath.row];
        return cell;
    }else{
        OtherPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPicCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OtherPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherPicCell"];
        }
        cell.collectionObjectId = self.allCollectionIdsArray[indexPath.row];
        cell.noteModel = noteModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *noteModel = self.allCollectionsArray[indexPath.row];
    if (![noteModel.type isEqualToString:@"0"]) {
        //有图
        CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 84, 0) andStr:noteModel.title];
        if (size.height < 31) {
            return 114;
        }
        return size.height + 83;
    }else{
        CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 16, 0) andStr:noteModel.title];
        return size.height + 83;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoteModel *noteModel = self.allCollectionsArray[indexPath.row];
    if (![noteModel.type isEqualToString:@"0"]) {
        //有图
        if ([noteModel.type isEqualToString:@"1"]) {
            PicNoteViewController *vc = [[PicNoteViewController alloc] init];
            vc.noteModel = noteModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        //录音
        
        //画图
        if ([noteModel.type isEqualToString:@"3"]) {
            PaintingNoteViewController *vc = [[PaintingNoteViewController alloc] init];
            vc.noteModel = noteModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //文本
        TextNoteViewController *vc = [[TextNoteViewController alloc] init];
        vc.noteModel = noteModel;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
