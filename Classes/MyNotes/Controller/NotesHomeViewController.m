//
//  NotesHomeViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "NotesHomeViewController.h"
#import "NotesHomeView.h"
#import "NotesView.h"
#import "WriteTextNoteViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginHomeViewController.h"
#import "LoginHomeNaviViewController.h"
#import "NoteModel.h"
#import "LatestNoteCell.h"
#import "WritePicNoteViewController.h"
#import "WriteRecordNoteViewController.h"
#import "FileCell.h"
#import "WritePaintingViewController.h"
#import "LookPaintingViewController.h"

@interface NotesHomeViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UIScrollViewDelegate, UINavigationControllerDelegate>

@property (nonatomic) NotesHomeView *notesHomeView;

@property (nonatomic) UIButton *noteButton;

@property (nonatomic) UIButton *toolButton;

@property (nonatomic) NotesView *notesView;

@property (nonatomic) UIView *backView;//黑色半透明背景

@property (nonatomic) NSMutableArray *allNotesArray;//请求到的数据

@property (nonatomic) UISearchController *searchController;
@property (nonatomic) NSMutableArray *searchResultArray;

@property (nonatomic) NSMutableArray *allCategorysArray;//文件夹
@property (nonatomic) NSMutableArray *allNoCategorysNoteArray;//无分类的笔记

@end

@implementation NotesHomeViewController

#pragma mark - LifeCircle --------------------------------------

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.notesHomeView.latestNoteTableView.mj_header beginRefreshing];
    [self.notesHomeView.allNoteTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allNotesArray = [NSMutableArray array];
    self.allCategorysArray = [NSMutableArray array];
    self.allNoCategorysNoteArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.notesHomeView = [[NotesHomeView alloc] init];
    [self.view addSubview:self.notesHomeView];
    [self.notesHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.notesHomeView.contentScrollView.delegate = self;
    
    self.notesHomeView.latestNoteTableView.delegate = self;
    self.notesHomeView.latestNoteTableView.dataSource = self;
    [self.notesHomeView.latestNoteTableView registerClass:[LatestNoteCell class] forCellReuseIdentifier:@"latestCell"];
    
    self.notesHomeView.latestNoteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.notesHomeView.latestNoteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
    
    __block __weak NotesHomeViewController *weakself = self;

    [self.notesHomeView.headerView setRefreshCallBack:^(id obj) {
        [weakself.notesHomeView.allNoteTableView.mj_header beginRefreshing];
    }];
    
    [self.notesHomeView.headerView setHomeHeadCallBack:^(NSInteger tag) {
        switch (tag) {
            case 11:
            {//新建文件夹
                
            }
                break;
            case 12:
            {//最新
                [weakself.notesHomeView.contentScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
                break;
            case 13:
            {//全部
                [weakself.notesHomeView.contentScrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
            }
                break;
        }
    }];
    
    [self.view endEditing:YES];
    
    //allNoteTableView
    self.notesHomeView.allNoteTableView.delegate = self;
    self.notesHomeView.allNoteTableView.dataSource = self;
    [self.notesHomeView.allNoteTableView registerClass:[LatestNoteCell class] forCellReuseIdentifier:@"latestCell"];
    [self.notesHomeView.allNoteTableView registerClass:[FileCell class] forCellReuseIdentifier:@"FileCell"];

    
    self.notesHomeView.allNoteTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllNoteObjects];//请求数据方法
    }];
    
    self.notesHomeView.allNoteTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadAllNoteMoreNews];//请求数据方法
    }];
    
    //指纹解锁
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud boolForKey:@"loginAgain"] || [ud boolForKey:@"loginAgain"] == NO) {
        [self showFingerprintTouch];
    }
    
    //工具按钮
    self.toolButton = [[UIButton alloc] init];
    [self.view addSubview:self.toolButton];
    [self.toolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
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
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 11:
            {
                WritePicNoteViewController *vc = [[WritePicNoteViewController alloc] init];
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 12:
            {
                WriteRecordNoteViewController *vc = [[WriteRecordNoteViewController alloc] init];
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            case 13:
            {
                WritePaintingViewController *vc = [[WritePaintingViewController alloc] init];
                [weakself presentViewController:vc animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }];
    
    //添加搜索栏
    //参数用来显示结果，nil表示用当前页面显示结果
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //是否隐藏原来的tableView内容
    self.searchController.dimsBackgroundDuringPresentation = NO;//由于是复用当前页面，所以不能隐藏，否则显示不出
    //代理方法
    self.searchController.searchResultsUpdater = self;
    
    self.notesHomeView.latestNoteTableView.tableHeaderView = self.searchController.searchBar;
    
    //latestcell返回的刷新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAction) name:@"refreshAction" object:nil];
}

#pragma mark - UIScrollView Delegate ----------------------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.width < screenWidth * 2 - 10) {
        return;
    }
    
    CGRect frame = CGRectMake(screenWidth/2.0 - 40, 57, 38, 1);
    CGFloat x = screenWidth/2.0 - 40 + 42 * scrollView.contentOffset.x/screenWidth;
    frame.origin.x = x;
    self.notesHomeView.headerView.lineView.frame = frame;
    
    if (scrollView.contentOffset.x < 20) {
        self.notesHomeView.headerView.latestButton.selected = YES;
        self.notesHomeView.headerView.allButton.selected = NO;
    }
    if (scrollView.contentOffset.x > screenWidth - 20) {
        self.notesHomeView.headerView.latestButton.selected = NO;
        self.notesHomeView.headerView.allButton.selected = YES;
    }
}

#pragma mark - UISearchController Delegate -----------------------
//当搜索栏中内容发生改变的时候执行
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    /*--在这里初始化防治下次搜索的时候原来的会出现--*/
    self.searchResultArray = [NSMutableArray array];
    //得到搜索栏中内容
    NSString *searchInfo = searchController.searchBar.text;
    //遍历得到
    
    for (NoteModel *noteModel in self.allNotesArray) {
        if ([noteModel.title containsString:searchInfo]) {
            [self.searchResultArray addObject:noteModel];
        }
    }
    
    [self.notesHomeView.latestNoteTableView reloadData];
}

#pragma mark - UITableView Delegate -----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 100) {
        if (self.searchController.isActive == YES) {
            return self.searchResultArray.count;
        }
        return self.allNotesArray.count;
    }else{
        return self.allCategorysArray.count + self.allNoCategorysNoteArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 100) {
        NoteModel *model = self.allNotesArray[indexPath.row];
        if (self.searchController.isActive == YES) {
            model = self.searchResultArray[indexPath.row];
        }
        LatestNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[LatestNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latestCell"];
        }
        cell.noteModel = model;
        return cell;
    }else{
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
            NoteModel *model = self.allNoCategorysNoteArray[indexPath.row - self.allCategorysArray.count];
            LatestNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[LatestNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latestCell"];
            }
            cell.noteModel = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    if (tableView.tag == 200 && indexPath.row < self.allCategorysArray.count) {
        
        FileCell *fileCell = [tableView cellForRowAtIndexPath:indexPath];
        if ([fileCell.fileModel.readOpen isEqualToString:@"YES"] || [ud boolForKey:@"openReadPassword"] == YES) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *readPass = ac.textFields.firstObject.text;
                if (![readPass isEqualToString:[[BmobUser currentUser] objectForKey:@"readPassword"]]) {
                    [Utils toastview:@"密码错误"];
                    return ;
                }else{
                    //文件夹
                    FileModel *model = self.allCategorysArray[indexPath.row];
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
            //文件夹
            FileModel *model = self.allCategorysArray[indexPath.row];
            FileViewController *vc = [[FileViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.fileModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        
        NoteModel *model = nil;
        if (tableView.tag == 100) {
            model = self.allNotesArray[indexPath.row];
        }else{
            model = self.allNoCategorysNoteArray[indexPath.row - self.allCategorysArray.count];
        }
        
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

#pragma mark - Method -------------------------------------------

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
        LookPaintingViewController *vc = [[LookPaintingViewController alloc] init];
        vc.noteModel = model;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//请求数据-----------latestTableView----------------
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    [bq orderByDescending:@"updatedAt"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.notesHomeView.latestNoteTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allNotesArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allNotesArray addObject:note];
            }
            [self.notesHomeView.latestNoteTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    //限制得到的类型
    
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.allNotesArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.notesHomeView.latestNoteTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allNotesArray addObject:note];
            }
            [self.notesHomeView.latestNoteTableView reloadData];
        }
    }];
}

//请求数据-----------allNoteTableView----------------
- (void)findAllNoteObjects{//下拉刷新
    
    BmobQuery *fileQuery = [BmobQuery queryWithClassName:@"Category"];
    [fileQuery orderByDescending:@"createdAt"];
    [fileQuery whereKey:@"User" equalTo:[BmobUser currentUser]];
    [fileQuery whereKeyDoesNotExist:@"Category"];
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
        [bq whereKeyDoesNotExist:@"Category"];
        bq.limit = 10;
        [bq orderByDescending:@"createdAt"];
        [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.notesHomeView.allNoteTableView.mj_header endRefreshing];
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                self.allNoCategorysNoteArray = [NSMutableArray array];
                for (BmobObject *obj in array) {
                    NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                    [self.allNoCategorysNoteArray addObject:note];
                }
                [self.notesHomeView.allNoteTableView reloadData];
            }
        }];
        
    }];
}

- (void)loadAllNoteMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Note"];
    [bq includeKey:@"User"];
    //限制得到的类型
    [bq whereKeyDoesNotExist:@"Category"];
    [bq whereKey:@"User" equalTo:[BmobUser currentUser]];
    bq.limit = 10;
    bq.skip = self.allNoCategorysNoteArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"createdAt"];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.notesHomeView.allNoteTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                NoteModel *note = [[NoteModel alloc] initWithBmobObject:obj];
                [self.allNoCategorysNoteArray addObject:note];
            }
            [self.notesHomeView.allNoteTableView reloadData];
        }
    }];
}


//指纹按钮
- (void)showFingerprintTouch
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isOn = [ud boolForKey:@"fingerPrint"];
    if (isOn) {
        if (isOn == YES) {
            /*---------------指纹解锁---------------*/
            
            //系统支持，最低iOS 8.0
            if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
                LAContext * context = [[LAContext alloc] init];
                NSError * error;
                context.localizedFallbackTitle = @"重新登录";
                //如果支持指纹解锁
                if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
                    
                    //localizedReason: 指纹识别出现时的提示文字
                    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"指纹解锁" reply:^(BOOL success, NSError * _Nullable error) {
                        if (success){
                            //识别成功
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //在主线程中，处理 ......
                            });
                        }else if (error){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self logout];
                            });
                        }
                    }];
                }
            }
            
            /*---------------指纹解锁---------------*/
        }
    }
}

- (void)logout{
    //YES表示已经退出过，第二次登录不需要出现指纹输入
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"loginAgain"];
    [ud synchronize];
    [BmobUser logout];
    [[EaseMobManager shareManager] logout];
    LoginHomeViewController *vc = [[LoginHomeViewController alloc] init];
    [self presentViewController: [[LoginHomeNaviViewController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}


- (void)toolButtonClicked{
    self.allNotesArray = [[[self.allNotesArray reverseObjectEnumerator] allObjects] mutableCopy];
    [self.notesHomeView.latestNoteTableView reloadData];
}

- (void)noteButtonClicked{
    self.backView.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = CGRectMake(0, screenHeight - screenWidth/4.0 - 44, screenWidth, screenWidth/4.0);
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
    [self.notesHomeView.latestNoteTableView.mj_header beginRefreshing];
}

@end
