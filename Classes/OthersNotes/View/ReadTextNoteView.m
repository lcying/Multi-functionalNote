//
//  TextNoteView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ReadTextNoteView.h"
#import "OtherPersonalHomeViewController.h"

@implementation ReadTextNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self readBottomView];
        [self commentsTableView];
        [self tableHeadView];
        
        [self readHeadView];
        [self contentLabel];
        [self updatedLabel];
        [self commentCountLabel];
        
        UITapGestureRecognizer *tapHeadImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.readHeadView.headImageView addGestureRecognizer:tapHeadImageView];
        self.readHeadView.headImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapUsernameLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self.readHeadView.usernameLabel addGestureRecognizer:tapUsernameLabel];
        self.readHeadView.usernameLabel.userInteractionEnabled = YES;
    }
    return self;
}

- (void)tapAction{
    OtherPersonalHomeViewController *vc = [[OtherPersonalHomeViewController alloc] init];
    vc.currentUser = self.noteModel.User;
    vc.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    
    self.readBottomView.noteModel = noteModel;
    
    self.readHeadView.noteModel = noteModel;
    self.readHeadView.titleLabel.text = noteModel.title;
    [self.readHeadView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[noteModel.User objectForKey:@"headPath"]]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.readHeadView.usernameLabel.text = noteModel.User.username;
    self.readHeadView.createdLabel.text = [NSString stringWithFormat:@"创建于%@",[Utils parseTimeWithTime:noteModel.createdAt]];
    
    //title计算高度
    CGSize titleSize = [Utils sizeWithFont:[UIFont systemFontOfSize:25] andMaxSize:CGSizeMake(screenWidth - 16, 0) andStr:noteModel.title];
    [self.readHeadView.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(titleSize.height + 1);
        make.top.mas_equalTo(15);
    }];
    
    //时间计算宽度
    CGSize timeSize = [Utils sizeWithFont:[UIFont systemFontOfSize:12] andMaxSize:CGSizeMake(0, 20) andStr:self.readHeadView.createdLabel.text];
    [self.readHeadView.createdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.width.mas_equalTo(timeSize.width + 1);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.readHeadView.headImageView.mas_bottom).mas_equalTo(8);
    }];
    
    //重新设置readHeadView高度
    [self.readHeadView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(titleSize.height + 90);
        make.width.mas_equalTo(screenWidth);
    }];
    
    NSAttributedString *contentString = [Utils getAttributedStringWithHTML:noteModel.content];
    self.contentLabel.attributedText = contentString;

    CGSize textBlockMinSize = {screenWidth - 16, CGFLOAT_MAX};
    
    CGSize retSize = [Utils getAttributedStringSizeWithMinSize:textBlockMinSize andAttributedString:contentString];
    
    
    [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(self.readHeadView.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(retSize.height + 1);
    }];
    
    
    //字数
    self.readHeadView.wordCountLabel.text = [NSString stringWithFormat:@"字数%ld",self.contentLabel.text.length - 1];

    CGSize wordCountSize = [Utils sizeWithFont:[UIFont systemFontOfSize:12] andMaxSize:CGSizeMake(0, 20) andStr:self.readHeadView.wordCountLabel.text];
    [self.readHeadView.wordCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.readHeadView.createdLabel.mas_right).mas_equalTo(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(wordCountSize.width + 1);
        make.top.mas_equalTo(self.readHeadView.usernameLabel.mas_bottom).mas_equalTo(8);
    }];

    self.readHeadView.readCountLabel.text = [NSString stringWithFormat:@"阅读数量%d",noteModel.readCount];

    //更新时间
    self.updatedLabel.text = [NSString stringWithFormat:@"最近更新于%@",[Utils parseTimeWithTime:noteModel.updatedAt]];

    //tableviewheadview高度
    CGRect frame = CGRectMake(0, 0, screenWidth, titleSize.height + retSize.height + 126 + 28);
    self.tableHeadView.frame = frame;
    self.commentsTableView.tableHeaderView = self.tableHeadView;
}

#pragma mark - LazyLoading --------------------------------

- (ReadBottomView *)readBottomView{
    if (_readBottomView == nil) {
        _readBottomView = [[ReadBottomView alloc] init];
        [self addSubview:_readBottomView];
        [_readBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return _readBottomView;
}

- (UITableView *)commentsTableView{
    if (_commentsTableView == nil) {
        _commentsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_commentsTableView];
        [_commentsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.readBottomView.mas_top).mas_equalTo(1);
        }];
        [_commentsTableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCell"];
        _commentsTableView.tableFooterView = [UIView new];
    }
    return _commentsTableView;
}

- (UIView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        self.commentsTableView.tableHeaderView = _tableHeadView;
    }
    return _tableHeadView;
}

- (ReadHeadView *)readHeadView{
    if (_readHeadView == nil) {
        _readHeadView = [[ReadHeadView alloc] init];
        [self.tableHeadView addSubview:_readHeadView];
        [_readHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(112);
            make.width.mas_equalTo(screenWidth);
        }];
    }
    return _readHeadView;
}

- (UILabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.readHeadView.mas_bottom).mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (UILabel *)updatedLabel{
    if (_updatedLabel == nil) {
        _updatedLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_updatedLabel];
        [_updatedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        _updatedLabel.textColor = [UIColor darkGrayColor];
        _updatedLabel.font = [UIFont systemFontOfSize:12];
    }
    return _updatedLabel;
}

- (UILabel *)commentCountLabel{
    if (_commentCountLabel == nil) {
        _commentCountLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_commentCountLabel];
        [_commentCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.updatedLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        _commentCountLabel.textColor = [UIColor darkGrayColor];
        _commentCountLabel.font = [UIFont systemFontOfSize:12];
        _commentCountLabel.textAlignment = NSTextAlignmentCenter;
        _commentCountLabel.text = @"共0条";
    }
    return _commentCountLabel;
}

@end
