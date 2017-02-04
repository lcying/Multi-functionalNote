//
//  PersonalCenterView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/6.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "PersonalCenterView.h"
#import "LatestNoteCell.h"
#import "AttentionCell.h"
#import "OtherTextCell.h"
#import "OtherPicCell.h"
#import "WriteTextNoteViewController.h"
#import "WritePicNoteViewController.h"
#import "WriteRecordNoteViewController.h"
#import "PicNoteViewController.h"
#import "TextNoteViewController.h"
#import "MyCommentCell.h"
#import "PaintingNoteViewController.h"
#import "EditPersonalInfoViewController.h"
#import "OtherPersonalHomeViewController.h"
#import "LookPaintingViewController.h"

@interface PersonalCenterView ()

@property (nonatomic) NSArray *titlesArray;

@end

@implementation PersonalCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titlesArray = @[@"公开笔记",@"个人笔记",@"我的关注",@"我的收藏",@"我的评论"];
        self.openNotesArray = [NSMutableArray array];
        self.secretNoteArray = [NSMutableArray array];
        self.myAttentionsArray = [NSMutableArray array];
        self.myCommentsArray = [NSMutableArray array];
        self.myCollectionsArray = [NSMutableArray array];
        self.myCollectionsIDsArray = [NSMutableArray array];
        self.contentTableViewsArray = [NSMutableArray array];
        self.titleButtonsArray = [NSMutableArray array];
        
        [self headView];
        [self headImageView];
        [self rightImageView];
        [self usernameLabel];
        [self wordLabel];
        
        for (int i = 0; i < self.titlesArray.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*screenWidth/5.0, 76, screenWidth/5.0, 40)];
            [self addSubview:button];
            [button setTitle:self.titlesArray[i] forState:UIControlStateNormal];
            [button dk_setTitleColorPicker:DKColorPickerWithColors([UIColor darkGrayColor], [UIColor whiteColor], [UIColor lightGrayColor]) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
            [button dk_setTitleColorPicker:DKColorPickerWithColors([UIColor redColor], [UIColor yellowColor],[UIColor greenColor]) forState:UIControlStateSelected];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.titleButtonsArray addObject:button];
            if (i == 0) {
                button.selected = YES;
            }
        }
        
        [self contentScrollView];
        
        for (int i = 0; i < self.titlesArray.count; i ++) {
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, screenHeight - 116 - 44 - 64)];
            [self.contentScrollView addSubview:tableView];
            tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
            tableView.tag = 10 + i;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.tableFooterView = [UIView new];
            [self.contentTableViewsArray addObject:tableView];
            
            if (i == 0 || i == 1) {
                [tableView registerClass:[LatestNoteCell class] forCellReuseIdentifier:@"latestCell"];
            }
            if (i == 2) {
                [tableView registerNib:[UINib nibWithNibName:@"AttentionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AttentionCell"];
            }
            if (i == 3) {
                [tableView registerNib:[UINib nibWithNibName:@"OtherTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherTextCell"];
                [tableView registerNib:[UINib nibWithNibName:@"OtherPicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OtherPicCell"];
            }
            if (i == 4) {
                [tableView registerClass:[MyCommentCell class] forCellReuseIdentifier:@"MyCommentCell"];
            }
        }
        [self lineView];
        
        
        UITapGestureRecognizer *tapHeadView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadViewAction)];
        [self.headView addGestureRecognizer:tapHeadView];
        self.headView.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - LazyLoading ------------------------
- (UIView *)headView{
    if (_headView == nil) {
        _headView = [[UIView alloc] init];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(1);
            make.height.mas_equalTo(66);
        }];
        _headView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    }
    return _headView;
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self.headView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.width.height.mas_equalTo(50);
        }];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
        _headImageView.layer.cornerRadius = 25;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right"]];
        [self.headView addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-15);
        }];
    }
    return _rightImageView;
}

- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [self.headView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        _usernameLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor whiteColor]);
        _usernameLabel.font = [UIFont systemFontOfSize:16];
        _usernameLabel.text = [[BmobUser currentUser] objectForKey:@"username"];
    }
    return _usernameLabel;
}

- (UILabel *)wordLabel{
    if (_wordLabel == nil) {
        _wordLabel = [[UILabel alloc] init];
        [self.headView addSubview:_wordLabel];
        [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(self.rightImageView.mas_left).mas_equalTo(-8);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        _wordLabel.textColor = [UIColor lightGrayColor];
        _wordLabel.font = [UIFont systemFontOfSize:13];
        _wordLabel.text = @"点击查看或编辑个人资料";
    }
    return _wordLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 115, screenWidth/5.0, 1)];
        _lineView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor redColor],[UIColor yellowColor],[UIColor greenColor]);
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 116, screenWidth, screenHeight - 116 - 44 - 64)];
        [self addSubview:_contentScrollView];
        _contentScrollView.contentSize = CGSizeMake(screenWidth * 5, 0);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

#pragma mark - UITableView Delegate ------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag) {
        case 10:
        {
            return self.openNotesArray.count;
        }
            break;
        case 11:
        {
            return self.secretNoteArray.count;
        }
            break;
        case 12:
        {
            return self.myAttentionsArray.count;
        }
            break;
        case 13:
        {
            return self.myCollectionsArray.count;
        }
            break;
        case 14:
        {
            return self.myCommentsArray.count;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10 || tableView.tag == 11) {
        NoteModel *model = nil;
        if (tableView.tag == 11) {
            model = self.secretNoteArray[indexPath.row];
        }else{
            model = self.openNotesArray[indexPath.row];
        }
        LatestNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"latestCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[LatestNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"latestCell"];
        }
        cell.noteModel = model;
        return cell;
    }else if (tableView.tag == 12) {
        AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[AttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttentionCell"];
        }
        cell.stateString = @"关注我的";
        BmobUser *user = self.myAttentionsArray[indexPath.row];
        cell.toUser = user;
        return cell;
    }else if (tableView.tag == 13) {
        NoteModel *noteModel = self.myCollectionsArray[indexPath.row];
        if ([noteModel.type isEqualToString:@"0"]) {
            //文字笔记
            OtherTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherTextCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[OtherTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherTextCell"];
            }
            cell.noteModel = noteModel;
            cell.collectionObjectId = self.myCollectionsIDsArray[indexPath.row];
            return cell;
        }else{
            OtherPicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherPicCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[OtherPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OtherPicCell"];
            }
            cell.collectionObjectId = self.myCollectionsIDsArray[indexPath.row];
            cell.noteModel = noteModel;
            return cell;
        }
    }else{
        MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCommentCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[MyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCommentCell"];
        }
        cell.commentObject = self.myCommentsArray[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 10 || tableView.tag == 11) {
        return 62;
    }
    if (tableView.tag == 12) {
        return 60;
    }
    if (tableView.tag == 13) {
        NoteModel *noteModel = self.myCollectionsArray[indexPath.row];
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
    if (tableView.tag == 14) {
            
        BmobObject *obj = self.myCommentsArray[indexPath.row];
        BmobObject *noteObject = [obj objectForKey:@"Note"];
        
        NSString *title = [NSString stringWithFormat:@"你在 %@ 中评论",[noteObject objectForKey:@"title"]];
        CGSize titleSize = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 16, 0) andStr:title];
        CGSize commentSize = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 40, 0) andStr:[obj objectForKey:@"comment"]];
        
        return titleSize.height + commentSize.height + 2 + 52 + 18;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 10 || tableView.tag == 11) {
        NoteModel *model = nil;
        if (tableView.tag == 11) {
            model = self.secretNoteArray[indexPath.row];
        }else{
            model = self.openNotesArray[indexPath.row];
        }
        if (tableView.tag == 11) {
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
                [[self viewController] presentViewController:ac animated:YES completion:nil];
            }else{
                [self lookUpNoteWithNoteModel:model];
            }
        }else{
            [self lookUpNoteWithNoteModel:model];
        }
    }
    
    if (tableView.tag == 12) {
        //我的关注
        
        AttentionCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
        
        OtherPersonalHomeViewController *vc = [[OtherPersonalHomeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.currentUser = cell.toUser;
        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }
    
    if (tableView.tag == 13) {
        //我的收藏
        NoteModel *noteModel = self.myCollectionsArray[indexPath.row];
        if (![noteModel.type isEqualToString:@"0"]) {
            //有图
            if ([noteModel.type isEqualToString:@"1"]) {
                PicNoteViewController *vc = [[PicNoteViewController alloc] init];
                vc.noteModel = noteModel;
                vc.hidesBottomBarWhenPushed = YES;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }
            
            //录音
            
            
            //画图
            if ([noteModel.type isEqualToString:@"3"]) {
                PaintingNoteViewController *vc = [[PaintingNoteViewController alloc] init];
                vc.noteModel = noteModel;
                vc.hidesBottomBarWhenPushed = YES;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            //文本
            TextNoteViewController *vc = [[TextNoteViewController alloc] init];
            vc.noteModel = noteModel;
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIScrollView Delegate ------------

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%@",NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView.contentOffset.x != 0) {
        CGFloat x = scrollView.contentOffset.x/(screenWidth*5);
        CGRect frame =  CGRectMake(x*screenWidth, 115, screenWidth/5.0, 1);
        self.lineView.frame = frame;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"end ------  %@",NSStringFromCGPoint(scrollView.contentOffset));

    if (scrollView.contentOffset.y == 0) {
        int i = scrollView.contentOffset.x/screenWidth;
        for (UIButton *button in self.titleButtonsArray) {
            button.selected = NO;
        }
        UIButton *button =  self.titleButtonsArray[i];
        button.selected = YES;
    }
}

#pragma mark - Method -----------------------------
- (void)buttonClickedAction:(UIButton *)button{
    //100 + i
    for (UIButton *button in self.titleButtonsArray) {
        button.selected = NO;
    }
    button.selected = YES;
    [self.contentScrollView setContentOffset:CGPointMake((button.tag - 100)*screenWidth, 0) animated:YES];
}

- (void)lookUpNoteWithNoteModel:(NoteModel *)model{
    if ([model.type isEqualToString:@"0"]) {
        WriteTextNoteViewController *vc = [[WriteTextNoteViewController alloc] init];
        vc.noteModel = model;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"1"]) {
        WritePicNoteViewController *vc = [[WritePicNoteViewController alloc] init];
        vc.noteModel = model;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"2"]) {
        WriteRecordNoteViewController *vc = [[WriteRecordNoteViewController alloc] init];
        vc.noteModel = model;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }
    if ([model.type isEqualToString:@"3"]) {
        LookPaintingViewController *vc = [[LookPaintingViewController alloc] init];
        vc.noteModel = model;
        [[self viewController] presentViewController:vc animated:YES completion:nil];
    }
}

- (void)tapHeadViewAction{
    EditPersonalInfoViewController *vc = [[EditPersonalInfoViewController alloc] initWithNibName:@"EditPersonalInfoViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

@end
