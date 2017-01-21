//
//  WriteTextNoteView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WriteTextNoteView.h"

@implementation WriteTextNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self headView];
        [self titleTextField];
        [self contentTextView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, screenWidth, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    
    [self bottomView];
    self.bottomView.currentNoteModel = self.noteModel;
    [_contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-46);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_equalTo(1);
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_equalTo(0);
    }];
    
    self.titleTextField.text = noteModel.title;
    self.contentTextView.attributedText = [Utils getAttributedStringWithHTML:noteModel.content];
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
    }
    return _headView;
}

- (UITextField *)titleTextField{
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.backgroundColor = [UIColor whiteColor];
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.placeholder = @"无标题笔记";
        _titleTextField.font = [UIFont systemFontOfSize:16];
        _titleTextField.textColor = [UIColor blackColor];
        _titleTextField.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleTextField];
        [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return _titleTextField;
}

- (UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-46);
            make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_equalTo(1);
        }];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.textColor = [UIColor darkGrayColor];
    }
    return _contentTextView;
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
