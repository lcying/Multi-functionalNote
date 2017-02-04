//
//  OtherPersonalHomeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "OtherPersonalHomeViewController.h"
#import "OtherPersonalHomeView.h"
#import "OtherPersonalHomeCell.h"
#import "PicNoteViewController.h"
#import "TextNoteViewController.h"
#import "RecordNoteViewController.h"
#import "PaintingNoteViewController.h"
#import "SendMessageViewController.h"

@interface OtherPersonalHomeViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic) OtherPersonalHomeView *homeView;
@property (nonatomic) NSMutableArray<NoteModel *> *allNotesArray;

@end

@implementation OtherPersonalHomeViewController

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.homeView.headImageView.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.homeView.headImageView.hidden = NO;
}

- (void)dealloc{
    [self.homeView.headImageView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.allNotesArray = [NSMutableArray array];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"私信" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessageAction)];
    
    self.homeView = [[OtherPersonalHomeView alloc] init];
    [self.view addSubview:self.homeView];
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.homeView.currentUser = self.currentUser;
    self.homeView.contentTableView.delegate = self;
    self.homeView.contentTableView.dataSource = self;
    [self.homeView.contentTableView registerNib:[UINib nibWithNibName:@"OtherPersonalHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherPersonalHomeCell"];
    
    self.homeView.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestAllNote];
    }];
    
    self.homeView.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self requestMoreNote];
    }];
    
    [self.homeView.contentTableView.mj_header beginRefreshing];
    [self didFocus];
    [self didZan];
}

#pragma mark - UITableView Delegate --------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allNotesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherPersonalHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPersonalHomeCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[OtherPersonalHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherPersonalHomeCell"];
    }
    cell.noteModel = self.allNotesArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoteModel *noteModel = self.allNotesArray[indexPath.row];
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

#pragma mark - UIScrollView Delegate ----------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y >= 0) {
        //向上
        CGFloat width = (1-scrollView.contentOffset.y/150) * 60;
        if (width <= 60 && width >= 25) {
            self.homeView.headImageView.layer.cornerRadius = width/2.0;
            [self.homeView.headImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.top.mas_equalTo(34);
                make.width.height.mas_equalTo(width);
            }];
        }
    }
}

#pragma mark - Method --------------------------------

- (void)requestAllNote{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    query.limit = 10;
    [query whereKey:@"User" equalTo:self.currentUser];
    [query whereKey:@"isOpen" equalTo:@"YES"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.homeView.contentTableView.mj_header endRefreshing];
        if (array.count > 0) {
            self.allNotesArray = [NSMutableArray array];
            for (BmobObject *object in array) {
                NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                noteModel.User = self.currentUser;
                [self.allNotesArray addObject:noteModel];
            }
            self.homeView.countLabel.text = [NSString stringWithFormat:@"共%ld篇文章",self.allNotesArray.count];
            [self.homeView.contentTableView reloadData];
        }
    }];
}

- (void)requestMoreNote{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    query.limit = 10;
    [query whereKey:@"User" equalTo:self.currentUser];
    [query whereKey:@"isOpen" equalTo:@"YES"];
    query.skip = self.allNotesArray.count;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.homeView.contentTableView.mj_footer endRefreshing];
        if (array.count > 0) {
            for (BmobObject *object in array) {
                NoteModel *noteModel = [[NoteModel alloc] initWithBmobObject:object];
                noteModel.User = self.currentUser;
                [self.allNotesArray addObject:noteModel];
            }
            self.homeView.countLabel.text = [NSString stringWithFormat:@"共%ld篇文章",self.allNotesArray.count];
            [self.homeView.contentTableView reloadData];
        }
    }];
}

//判断是否关注过
- (void)didFocus{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"ToUser" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [self.homeView.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.homeView.attentionButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }];
}

//判断是否点赞过
- (void)didZan{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"ToUser" equalTo:self.currentUser];
    [query whereKeyDoesNotExist:@"Note"];
    [query whereKeyDoesNotExist:@"Comment"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            [self.homeView.zanButton setTitle:@"已赞" forState:UIControlStateNormal];
            [self.homeView.zanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.homeView.zanButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }];
}

- (void)sendMessageAction{
    //跳转到私信界面
    SendMessageViewController *sendVc = [[SendMessageViewController alloc] init];
    sendVc.hidesBottomBarWhenPushed = YES;
    sendVc.toUser = self.currentUser;
    [self.navigationController pushViewController:sendVc animated:YES];
    
}

@end
