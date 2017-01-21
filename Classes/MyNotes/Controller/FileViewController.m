//
//  FileViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "FileViewController.h"
#import "FileView.h"
#import "LatestNoteCell.h"
#import "FileCell.h"
#import "WritePicNoteViewController.h"
#import "WriteTextNoteViewController.h"
#import "WriteRecordNoteViewController.h"
#import "NotesView.h"

@interface FileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) FileView *fileView;
@property (nonatomic) NSMutableArray *allCategorysArray;
@property (nonatomic) NSMutableArray *notesArray;

@property (nonatomic) UIButton *noteButton;
@property (nonatomic) UIButton *toolButton;
@property (nonatomic) NotesView *notesView;
@property (nonatomic) UIView *backView;//黑色半透明背景

@end

@implementation FileViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.fileView.fileTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCategorysArray = [NSMutableArray array];
    self.notesArray = [NSMutableArray array];
    
    self.title = self.fileModel.filename;
    self.fileView = [[FileView alloc] init];
    [self.view addSubview:self.fileView];
    [self.fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.fileView.headView.titleLabel.text = self.fileModel.filename;
    
    self.fileView.fileTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllNoteObjects];
    }];
    
    self.fileView.fileTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadAllNoteMoreNews];
    }];
    
    self.fileView.fileTableView.delegate = self;
    self.fileView.fileTableView.dataSource = self;
    
    [self.fileView.fileTableView registerClass:[LatestNoteCell class] forCellReuseIdentifier:@"latestCell"];
    [self.fileView.fileTableView registerClass:[FileCell class] forCellReuseIdentifier:@"FileCell"];
    
    __block __weak FileViewController *weakself = self;

    [self.fileView.headView setFileHeadCallBack:^(id obj) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:@"请输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *filename = ac.textFields.firstObject.text;
            if ([filename isEqualToString:@""]) {
                [Utils toastview:@"请输入文件名"];
                return ;
            }
            BmobObject *object = [BmobObject objectWithClassName:@"Category"];
            [object setObject:filename forKey:@"filename"];
            [object setObject:weakself.fileModel.currentObject forKey:@"Category"];//设置父分类
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:@"NO" forKey:@"readOpen"];

            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Utils toastview:@"创建成功！"];
                    
                    [weakself.fileView.fileTableView.mj_header beginRefreshing];
                    
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [weakself presentViewController:ac animated:YES completion:nil];
    }];
    
    //工具按钮
    self.toolButton = [[UIButton alloc] init];
    [self.view addSubview:self.toolButton];
    [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(45);
    }];
    [self.toolButton setImage:[UIImage imageNamed:@"tools"] forState:UIControlStateNormal];
    self.toolButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.toolButton addTarget:self action:@selector(toolButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //笔记按钮
    self.noteButton = [[UIButton alloc] init];
    [self.view addSubview:self.noteButton];
    [self.noteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(self.toolButton.mas_top).mas_equalTo(-15);
    }];
    [self.noteButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    self.noteButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.noteButton addTarget:self action:@selector(noteButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //半透明背景
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.backView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.backView];
    self.backView.alpha = 0;
    self.backView.hidden = YES;
    
    //添加笔记栏
    self.notesView = [[NotesView alloc] initWithFrame:CGRectMake(0, screenHeight, screenWidth, screenWidth/4.0)];
    [self.view addSubview:self.notesView];
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    [self.backView addGestureRecognizer:dismissTap];
    
    [self.notesView setNotesCallBack:^(NSInteger tag) {
        switch (tag) {
            case 10:
            {
                WriteTextNoteViewController *vc = [[WriteTextNoteViewController alloc] init];
                vc.categoryObject = weakself.fileModel.currentObject;
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 11:
            {
                WritePicNoteViewController *vc = [[WritePicNoteViewController alloc] init];
                vc.categoryObject = weakself.fileModel.currentObject;
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 12:
            {
                WriteRecordNoteViewController *vc = [[WriteRecordNoteViewController alloc] init];
                vc.categoryObject = weakself.fileModel.currentObject;
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    //latestcell返回的刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"refreshAction" object:nil];
}

#pragma mark - Method ------------------------------

- (void)findAllNoteObjects{//下拉刷新
    
    BmobQuery *fileQuery = [BmobQuery queryWithClassName:@"Category"];
    [fileQuery orderByDescending:@"createdAt"];
    [fileQuery whereKey:@"User" equalTo:[BmobUser currentUser]];
    [fileQuery whereKey:@"Category" equalTo:self.fileModel.currentObject];
    [fileQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            self.allCategorysArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                FileModel *fileModel = [[FileModel alloc] init];
                fileModel.currentObject = obj;
                [self.allCategorysArray addObject:fileModel];
            }
        }
        
        BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
        [bq includeKey:@"User"];
        [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
        [bq whereKey:@"Category" equalTo:self.fileModel.currentObject];
        bq.limit = 10;
        [bq orderByDescending:@"createdAt"];
        [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.fileView.fileTableView.mj_header endRefreshing];
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                self.notesArray = [NSMutableArray array];
                for (BmobObject *obj in array) {
                    NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                    [self.notesArray addObject:note];
                }
                [self.fileView.fileTableView reloadData];
            }
        }];
        
    }];
}

- (void)loadAllNoteMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    //限制得到的类型
    [bq whereKey:@"Category" equalTo:self.fileModel.currentObject];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.notesArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"createdAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.fileView.fileTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.notesArray addObject:note];
            }
            [self.fileView.fileTableView reloadData];
        }
    }];
}

- (void)toolButtonClicked{
    self.notesArray = [[[self.notesArray reverseObjectEnumerator] allObjects] mutableCopy];
    [self.fileView.fileTableView reloadData];
}

- (void)noteButtonClicked{
    self.backView.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = CGRectMake(0, screenHeight - screenWidth/4.0, screenWidth, screenWidth/4.0);
        self.notesView.frame = frame;
        self.backView.alpha = 0.4;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAction{
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = CGRectMake(0, screenHeight, screenWidth, screenWidth/4.0);
        self.notesView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
    }];
}

- (void)refreshAction{
    [self.fileView.fileTableView.mj_header beginRefreshing];
}

#pragma mark - UITableView Delegate ------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCategorysArray.count + self.notesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row < self.allCategorysArray.count) {
            //文件夹
            FileCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"FileCell" forIndexPath:indexPath];
            if (fileCell == nil) {
                fileCell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FileCell"];
            }
            FileModel *model = self.allCategorysArray[indexPath.row];
            fileCell.fileModel = model;
            return fileCell;
        }else{
            //笔记啊
            NoteModel *model = self.notesArray[indexPath.row - self.allCategorysArray.count];
            LatestNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[LatestNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latestCell"];
            }
            cell.noteModel = model;
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (indexPath.row < self.allCategorysArray.count) {
        //文件夹
        FileModel *model = self.allCategorysArray[indexPath.row];
        
        if ([ud boolForKey:@"openReadPassword"] == YES || [model.readOpen isEqualToString:@"YES"]) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *readPass = ac.textFields.firstObject.text;
                if (![readPass isEqualToString:[[BmobUser currentUser] objectForKey:@"readPassword"]]) {
                    [Utils toastview:@"密码错误"];
                    return ;
                }else{
                    //文件夹
                    FileViewController *vc = [[FileViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    vc.fileModel = model;
                    [self.navigationController pushViewController:vc animated:YES];
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
            FileViewController *vc = [[FileViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.fileModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        NoteModel *model = self.notesArray[indexPath.row - self.allCategorysArray.count];
        LatestNoteCell *noteCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([noteCell.noteModel.readOpen isEqualToString:@"YES"] || [ud boolForKey:@"openReadPassword"] == YES) {
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
    }
}

#pragma mark - Method
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
