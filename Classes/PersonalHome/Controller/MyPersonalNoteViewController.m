//
//  MyPersonalNoteViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyPersonalNoteViewController.h"
#import "MyPersonalNoteView.h"
#import "LatestNoteCell.h"
#import "WritePicNoteViewController.h"
#import "WriteRecordNoteViewController.h"
#import "WriteTextNoteViewController.h"

@interface MyPersonalNoteViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) MyPersonalNoteView *noteView;
@property (nonatomic) NSMutableArray *allNotesArray;
@end

@implementation MyPersonalNoteViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.noteView.noteTableView.mj_header beginRefreshing];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleString;
    self.allNotesArray = [NSMutableArray array];
    
    self.noteView = [[MyPersonalNoteView alloc] init];
    [self.view addSubview:self.noteView];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    self.noteView.noteTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.noteView.noteTableView.delegate = self;
    self.noteView.noteTableView.dataSource = self;
    
    [self.noteView.noteTableView registerClass:[LatestNoteCell class] forCellReuseIdentifier:@"latestCell"];

    
    self.noteView.noteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.noteView.noteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
    
}

#pragma mark - Method -------------------------------------------

//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    if ([self.titleString isEqualToString:@"个人笔记"]) {
        [bq whereKey:@"isOpen" equalTo:@"NO"];
    }else{
        [bq whereKey:@"isOpen" equalTo:@"YES"];
    }
    bq.limit = 10;
    [bq orderByDescending:@"updatedAt"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.noteView.noteTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allNotesArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allNotesArray addObject:note];
            }
            [self.noteView.noteTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    //限制得到的类型
    if ([self.titleString isEqualToString:@"个人笔记"]) {
        [bq whereKey:@"isOpen" equalTo:@"NO"];
    }else{
        [bq whereKey:@"isOpen" equalTo:@"YES"];
    }
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.allNotesArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.noteView.noteTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allNotesArray addObject:note];
            }
            [self.noteView.noteTableView reloadData];
        }
    }];
}

#pragma mark - UITableView Delegate -----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allNotesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoteModel *model = self.allNotesArray[indexPath.row];
    LatestNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LatestNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latestCell"];
    }
    cell.noteModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NoteModel *model = self.allNotesArray[indexPath.row];
    if ([self.titleString isEqualToString:@"个人笔记"]) {
        LatestNoteCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.noteModel.readOpen isEqualToString:@"YES"]) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *readPass = ac.textFields.firstObject.text;
                if (![readPass isEqualToString:[[BmobUser currentUser] objectForKey:@"readPassword"]]) {
                    [Utils toastview:@"密码错误"];
                    return ;
                }else{
                    [self lookUpNoteWithNoteModel:model];
                }
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
               textField.placeholder = @"请输入阅读密码";
            }];
            [self presentViewController:ac animated:YES completion:nil];
        }else{
            [self lookUpNoteWithNoteModel:model];
        }
    }else{
        [self lookUpNoteWithNoteModel:model];
    }
    
}

- (void)lookUpNoteWithNoteModel:(NoteModel *)model{
    if ([model.type isEqualToString:@"0"]) {
        WriteTextNoteViewController *vc = [[WriteTextNoteViewController alloc] init];
        vc.noteModel = model;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"1"]) {
        WritePicNoteViewController *vc = [[WritePicNoteViewController alloc] init];
        vc.noteModel = model;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"2"]) {
        WriteRecordNoteViewController *vc = [[WriteRecordNoteViewController alloc] init];
        vc.noteModel = model;
        [self presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"3"]) {
        
    }
}

@end
