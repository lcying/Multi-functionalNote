//
//  WriteRecordView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WriteRecordView.h"

@implementation WriteRecordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self headView];
        [self titleTextField];
        [self recordView];
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    if (noteModel) {
        [self.recordView removeFromSuperview];
        [self bottomView];
        self.titleTextField.text = noteModel.title;
        
        UIButton *playButton = [[UIButton alloc] init];
        [self addSubview:playButton];
        [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(100);
        }];
        [playButton setTitle:@"点击播放录音" forState:UIControlStateNormal];
        [playButton setBackgroundColor:[UIColor colorWithRed:135/255.0 green:217/255.0 blue:142/255.0 alpha:1]];
        [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        playButton.titleLabel.font = [UIFont systemFontOfSize:36];
        [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    }
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
        _headView.titleLabel.text = @"新建录音笔记";
    }
    return _headView;
}

- (UITextField *)titleTextField{
    if (_titleTextField == nil) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.backgroundColor = [UIColor clearColor];
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.placeholder = @"无标题笔记";
        _titleTextField.font = [UIFont systemFontOfSize:16];
        _titleTextField.textColor = [UIColor blackColor];
        [self addSubview:_titleTextField];
        [_titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return _titleTextField;
}

- (UIView *)recordView {
    if(_recordView == nil) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, screenWidth, screenHeight - 64)];
        [self addSubview:_recordView];
        _recordView.backgroundColor = [UIColor clearColor];
        RecordButton *recordBtn = [[RecordButton alloc] initWithFrame:CGRectMake(screenWidth/2 - 50, 50, 100, 100)];
        [_recordView addSubview:recordBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinishAction:) name:@"RecordDidFinishNotification" object:nil];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(recordBtn.frame), screenWidth, 30)];
        [_recordView addSubview:self.timeLabel];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _recordView;
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

#pragma mark - Method -----------------------------------

- (void)recordFinishAction:(NSNotification *)sender{
    self.voiceData = sender.object[@"data"];
    self.timeLabel.text = [NSString stringWithFormat:@"%.2f秒",[sender.object[@"time"] floatValue]];
}

- (void)playAction:(UIButton *)button{
    //在这里我们上传的是amr格式的，需要下载下来解析成wmv格式才能播放。VIMediaCatch不能播放amr格式
    [Utils playVoiceWithPath:self.noteModel.voicePath];
}

@end
