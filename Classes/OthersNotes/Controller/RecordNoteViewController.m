//
//  RecordNoteViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/10.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "RecordNoteViewController.h"
#import "RecordView.h"
#import "CommentCell.h"

@interface RecordNoteViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic) RecordView *noteView;
@property (nonatomic) NSMutableArray *allCommentsArray;
@property (nonatomic) NSMutableArray *allZanedCommentIdArray;

@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) UIButton *finishButton;
@property (nonatomic) UIView *backView;
@property (nonatomic) UIButton *cancelButton;

@property (nonatomic) BmobObject *currentComment;
@property (nonatomic) int length;

@end

@implementation RecordNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.noteView.commentsTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCommentsArray = [NSMutableArray array];
    self.allZanedCommentIdArray = [NSMutableArray array];
    
    [self findAllZanObjectId];
    
    self.noteView = [[RecordView alloc] init];
    [self.view addSubview:self.noteView];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.noteView.noteModel = self.noteModel;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.noteView.commentsTableView.delegate = self;
    self.noteView.commentsTableView.dataSource = self;
    
    self.noteView.commentsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self findAllObjects];
    }];
    
    self.noteView.commentsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
    
    [self hasAttention];
    
    __block __weak RecordNoteViewController *weakself = self;
    
    [self.noteView.readBottomView setReadBottomCallBack:^(id obj) {
        //分享
        [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            
            [Utils shareTextToPlatformType:platformType andText:weakself.noteModel.title];
        }];
    }];
    
    [self backView];
    [self commentTextView];
    [self finishButton];
    [self cancelButton];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCommentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
    }
    CommentModel *model = self.allCommentsArray[indexPath.row];
    cell.commentModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.allCommentsArray[indexPath.row];
    CGSize size = [Utils sizeWithFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(screenWidth - 50 - 24, 0) andStr:model.comment];
    return 82 + size.height + 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentModel *model = self.allCommentsArray[indexPath.row];
    
    //评论评论
    self.commentTextView.text = [NSString stringWithFormat:@"回复：@%@ ",[model.User objectForKey:@"username"]];
    self.length = (int)self.commentTextView.text.length;
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.hidden = NO;
        CGRect frameTV = CGRectMake(8, 79, screenWidth - 16, 150);
        self.commentTextView.frame = frameTV;
        
        CGRect frameBtn = CGRectMake(screenWidth - 8 - 60, 79 + 153, 60, 30);
        self.finishButton.frame = frameBtn;
        
        CGRect frameCancel = CGRectMake(8, 79 + 153, 60, 30);
        self.cancelButton.frame = frameCancel;
    }];
    
    self.currentComment = model.bmobObject;
    
    [self.commentTextView becomeFirstResponder];

}


#pragma mark - UITextView Delegate -------------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location <= self.length - 1) {
        return NO;
    }
    return YES;
}

#pragma mark - Method ------------------------------------------

//请求数据
- (void)findAllObjects{//下拉刷新
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Comment"];
    [bq includeKey:@"User"];
    bq.limit = 10;
    [bq whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [bq orderByDescending:@"updatedAt"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.noteView.commentsTableView.mj_header endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            self.allCommentsArray = [NSMutableArray array];
            for (BmobObject *obj in array) {
                CommentModel *comment = [[CommentModel alloc] initWithBmobObject:obj];
                //如果在zan数组中
                comment.isZaned = NO;
                if ([self.allZanedCommentIdArray containsObject:obj.objectId]) {
                    comment.isZaned = YES;
                }
                [self.allCommentsArray addObject:comment];
            }
            self.noteView.commentCountLabel.text = [NSString stringWithFormat:@"共%ld条",self.allCommentsArray.count];
            [self.noteView.commentsTableView reloadData];
        }
    }];
}

- (void)loadMoreNews{//上拉加载
    BmobQuery *bq = [[BmobQuery alloc] initWithClassName:@"Comment"];
    [bq includeKey:@"User"];
    //限制得到的类型
    
    bq.limit = 10;
    bq.skip = self.allCommentsArray.count;//跳过已有数据的个数
    [bq orderByDescending:@"updatedAt"];
    [bq whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.noteView.commentsTableView.mj_footer endRefreshing];
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            for (BmobObject *obj in array) {
                CommentModel *comment = [[CommentModel alloc] initWithBmobObject:obj];
                comment.isZaned = NO;
                if ([self.allZanedCommentIdArray containsObject:obj.objectId]) {
                    comment.isZaned = YES;
                }
                [self.allCommentsArray addObject:comment];
            }
            self.noteView.commentCountLabel.text = [NSString stringWithFormat:@"共%ld条",self.allCommentsArray.count];
            [self.noteView.commentsTableView reloadData];
        }
    }];
}

//加载当前笔记当前用户的所有赞
- (void)findAllZanObjectId{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query includeKey:@"User"];
    [query includeKey:@"Comment"];
    [query includeKey:@"Note"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [query whereKeyExists:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array && array.count > 0) {
            self.allZanedCommentIdArray = [NSMutableArray array];
            for (BmobObject *zanObj in array) {
                BmobObject *commentObject = [zanObj objectForKey:@"Comment"];
                [self.allZanedCommentIdArray addObject:commentObject.objectId];
            }
        }
    }];
}

//判断是否已关注
- (void)hasAttention{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"ToUser" equalTo:self.noteModel.User];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            //已关注
            [self.noteView.readHeadView.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.noteView.readHeadView.focusButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }];
}

- (void)finishButtonClickedAction:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.backView.hidden = YES;
        CGRect frameTV = CGRectMake(8, screenHeight - 64, screenWidth - 16, 150);
        self.commentTextView.frame = frameTV;
        
        CGRect frameBtn = CGRectMake(screenWidth - 8 - 60, screenHeight - 64 + 153, 60, 30);
        self.finishButton.frame = frameBtn;
        
        CGRect frameBtnCancel = CGRectMake(8, screenHeight - 64 + 153, 60, 30);
        self.cancelButton.frame = frameBtnCancel;
    }];
    
    if ([button.currentTitle isEqualToString:@"完成"]) {
        //上传评论
        BmobObject *object = [BmobObject objectWithClassName:@"Comment"];
        [object setObject:[BmobUser currentUser] forKey:@"User"];
        [object setObject:self.noteModel.User forKey:@"ToUser"];
        [object setObject:self.noteModel.bmobObject forKey:@"Note"];
        [object setObject:self.commentTextView.text forKey:@"comment"];
        [object setObject:self.currentComment forKey:@"CommentPointer"];
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.objectId];
                
                [currentNote incrementKey:@"commentCount" byNumber:@1];
                
                [currentNote updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        
                    }
                }];
            }
        }];
    }
    
}

#pragma mark - LazyLoading -----------------------------

- (UITextView *)commentTextView{
    if (_commentTextView == nil) {
        _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(8, screenHeight - 64, screenWidth - 16, 150)];
        _commentTextView.layer.cornerRadius = 4;
        _commentTextView.layer.masksToBounds = YES;
        _commentTextView.delegate = self;
        [self.view addSubview:_commentTextView];
    }
    return _commentTextView;
}

- (UIButton *)finishButton{
    if (_finishButton == nil) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 8 - 60, screenHeight - 64 + 153, 60, 30)];
        [self.view addSubview:_finishButton];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setBackgroundColor:[UIColor whiteColor]];
        [_finishButton setTitleColor:[Utils colorRGB:@"#ec6c00"] forState:UIControlStateNormal];
        _finishButton.layer.cornerRadius = 3;
        _finishButton.layer.masksToBounds = YES;
        _finishButton.layer.borderColor = [Utils colorRGB:@"#ec6c00"].CGColor;
        _finishButton.layer.borderWidth = 1;
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_finishButton addTarget:self action:@selector(finishButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

- (UIButton *)cancelButton{
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(8, screenHeight - 64 + 153, 60, 30)];
        [self.view addSubview:_cancelButton];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setTitleColor:[Utils colorRGB:@"#333333"] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 3;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderColor = [Utils colorRGB:@"#333333"].CGColor;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(finishButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
        [self.view addSubview:_backView];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.4;
        _backView.hidden = YES;
    }
    return _backView;
}


@end
