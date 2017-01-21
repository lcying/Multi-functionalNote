//
//  OtherNoresViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "OtherNoresViewController.h"
#import "OtherNotesView.h"
#import "OtherTextCell.h"
#import "OtherPicCell.h"
#import "TextNoteViewController.h"
#import "PicNoteViewController.h"
#import "RecommandUserViewController.h"
#import "PaintingNoteViewController.h"
#import "RecordNoteViewController.h"

@interface OtherNoresViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) OtherNotesView *otherNoteView;
@property (nonatomic) NSMutableArray<NoteModel *> *allOpenedNotesArray;

@end

@implementation OtherNoresViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"笔记分享";
    self.allOpenedNotesArray = [NSMutableArray array];
    
    self.otherNoteView = [[OtherNotesView alloc] init];
    [self.view addSubview:self.otherNoteView];
    [self.otherNoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.otherNoteView.noteTableView.delegate = self;
    self.otherNoteView.noteTableView.dataSource = self;
    
    [self.otherNoteView.noteTableView registerNib:[UINib nibWithNibName:@"OtherTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherTextCell"];
    [self.otherNoteView.noteTableView registerNib:[UINib nibWithNibName:@"OtherPicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherPicCell"];

    
    self.otherNoteView.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.otherNoteView.noteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
    
    [self.otherNoteView.noteTableView.mj_header beginRefreshing];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"推荐用户" style:UIBarButtonItemStylePlain target:self action:@selector(recommandUser)];
}

#pragma mark - UITableView Delegate ---------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allOpenedNotesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *noteModel = self.allOpenedNotesArray[indexPath.row];
    if ([noteModel.type isEqualToString:@"0"]) {
        //文字笔记
        OtherTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherTextCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OtherTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherTextCell"];
        }
        cell.noteModel = noteModel;
        return cell;
    }else{
        OtherPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPicCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OtherPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherPicCell"];
        }
        cell.noteModel = noteModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *noteModel = self.allOpenedNotesArray[indexPath.row];
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
    NoteModel *noteModel = self.allOpenedNotesArray[indexPath.row];
    if (![noteModel.type isEqualToString:@"0"]) {
        //有图
        if ([noteModel.type isEqualToString:@"1"]) {
            PicNoteViewController *vc = [[PicNoteViewController alloc] init];
            vc.noteModel = noteModel;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        //录音
        if ([noteModel.type isEqualToString:@"2"]) {
            RecordNoteViewController *vc = [[RecordNoteViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.noteModel = noteModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
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

#pragma mark - Method -------------------------------------------

//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    bq.limit = 10;
    [bq whereKey:@"isOpen" equalTo:@"YES"];
    [bq orderByDescending:@"zanCount"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.otherNoteView.noteTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allOpenedNotesArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allOpenedNotesArray addObject:note];
            }
            [self.otherNoteView.noteTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    //限制得到的类型
    [bq whereKey:@"isOpen" equalTo:@"YES"];
    bq.limit = 10;
    bq.skip = self.allOpenedNotesArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"zanCount"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.otherNoteView.noteTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allOpenedNotesArray addObject:note];
            }
            [self.otherNoteView.noteTableView reloadData];
        }
    }];
}

- (void)recommandUser{
    //推荐用户
    RecommandUserViewController *vc = [[RecommandUserViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
