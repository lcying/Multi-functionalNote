//
//  LookPaintingView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "LookPaintingView.h"

@implementation LookPaintingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self headView];
        [self bottomView];
        [self contentImageView];
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:noteModel.imagePaths.firstObject] placeholderImage:[UIImage imageNamed:@"404"]];
    self.bottomView.currentNoteModel = self.noteModel;
}

- (HeadView *)headView{
    if (_headView == nil) {
        _headView = [[HeadView alloc] init];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
        _headView.titleLabel.text = @"新建笔记";
        [_headView.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    return _headView;
}

- (UIImageView *)contentImageView{
    if (_contentImageView == nil) {
        _contentImageView = [[UIImageView alloc] init];
        [self addSubview:_contentImageView];
        [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(self.bottomView.mas_top).mas_equalTo(0);
        }];
    }
    return _contentImageView;
}

- (ToolsBottomView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[ToolsBottomView alloc] init];
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(0);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 50, screenWidth, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
    }
    return _bottomView;
}

@end
