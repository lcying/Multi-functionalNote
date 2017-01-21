//
//  WritePicNoteView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WritePicNoteView.h"

@implementation WritePicNoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.chooseImageViewsArray = [NSMutableArray array];
        [self headView];
        [self titleTextField];
        [self imageScrollView];
        [self contentTextView];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 114, screenWidth, 1)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        
        UILabel *chooseImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
        chooseImageLabel.text = @"  请选择图片（点击图片可放大）";
        chooseImageLabel.font = [UIFont systemFontOfSize:14];
        chooseImageLabel.textColor = [UIColor darkGrayColor];
        chooseImageLabel.textAlignment = NSTextAlignmentLeft;
        NSRange range = [chooseImageLabel.text rangeOfString:@"（点击图片可放大）"];
        chooseImageLabel.attributedText = [Utils setTextColor:chooseImageLabel.text FontNumber:[UIFont systemFontOfSize:12] AndRange:range AndColor:[Utils colorRGB:@"#cccccc"]];
        [self.imageScrollView addSubview:chooseImageLabel];
        
        ChooseImageView *chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(0, 30, 100, 125)];
        [self.chooseImageViewsArray addObject:chooseImageView];
        [self.imageScrollView addSubview:chooseImageView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseImageAction:) name:@"ChooseImageAction" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeImageAction:) name:@"RemoveImageAction" object:nil];
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    
    [self bottomView];
    self.bottomView.currentNoteModel = self.noteModel;
    [self.imageScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).mas_equalTo(0);
        make.height.mas_equalTo(160);
    }];
    
    self.titleTextField.text = noteModel.title;
    self.contentTextView.text = noteModel.content;
    self.bottomView.currentNoteModel = self.noteModel;
    for (int i = 0; i < noteModel.imagePaths.count; i ++) {
        if (i == 0) {
            [self.chooseImageViewsArray.firstObject.showImageIV sd_setImageWithURL:[NSURL URLWithString:noteModel.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"404"]];
            self.chooseImageViewsArray.firstObject.showImageIV.hidden = NO;
            self.chooseImageViewsArray.firstObject.removeButton.hidden = NO;
            self.chooseImageViewsArray.firstObject.chooseImageButton.userInteractionEnabled = NO;
        }else{
            ChooseImageView *chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(i * 100, 30, 100, 125)];
            [chooseImageView.showImageIV sd_setImageWithURL:[NSURL URLWithString:noteModel.imagePaths[i]] placeholderImage:[UIImage imageNamed:@"404"]];
            chooseImageView.showImageIV.hidden = NO;
            chooseImageView.removeButton.hidden = NO;
            chooseImageView.chooseImageButton.userInteractionEnabled = NO;
            [self.chooseImageViewsArray addObject:chooseImageView];
            [self.imageScrollView addSubview:chooseImageView];
        }
        if (i == self.noteModel.imagePaths.count - 1) {
            ChooseImageView *civ = [[ChooseImageView alloc] initWithFrame:CGRectMake((i+1) * 100, 30, 100, 125)];
            [self.chooseImageViewsArray addObject:civ];
            [self.imageScrollView addSubview:civ];
            self.imageScrollView.contentSize = CGSizeMake(125*(noteModel.imagePaths.count + 1), 0);
        }
    }
    self.imageScrollView.contentSize = CGSizeMake(noteModel.imagePaths.count * 100, 0);
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

- (UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        [self addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_equalTo(1);
            make.bottom.mas_equalTo(self.imageScrollView.mas_top).mas_equalTo(0);
        }];
        _contentTextView.font = [UIFont systemFontOfSize:14];
        _contentTextView.textColor = [UIColor darkGrayColor];
        _contentTextView.backgroundColor = [UIColor clearColor];
    }
    return _contentTextView;
}

- (UIScrollView *)imageScrollView{
    if (_imageScrollView == nil) {
        _imageScrollView = [[UIScrollView alloc] init];
        [self addSubview:_imageScrollView];
        [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(160);
        }];
        _imageScrollView.userInteractionEnabled = YES;
        _imageScrollView.contentSize = CGSizeMake(screenWidth, 100);
        _imageScrollView.backgroundColor = [UIColor clearColor];
    }
    return _imageScrollView;
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

#pragma mark - Method ------------------------------------
- (void)chooseImageAction:(NSNotification *)noti{
    if (self.chooseImageViewsArray.count >= 9) {
        return;
    }
    ChooseImageView *chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(self.chooseImageViewsArray.count * 100, 30, 100, 125)];
    [self.chooseImageViewsArray addObject:chooseImageView];
    [self.imageScrollView addSubview:chooseImageView];
    self.imageScrollView.contentSize = CGSizeMake(self.chooseImageViewsArray.count * 100, 0);
}

- (void)removeImageAction:(NSNotification *)noti{
    ChooseImageView *currentChooseIV = (ChooseImageView *)noti.object;
    [self.chooseImageViewsArray removeObject:currentChooseIV];
    [currentChooseIV removeFromSuperview];
    
    if (self.chooseImageViewsArray.count == 8 && self.chooseImageViewsArray.lastObject.showImageIV.hidden == NO) {
        ChooseImageView *chooseImageView = [[ChooseImageView alloc] initWithFrame:CGRectMake(self.chooseImageViewsArray.count * 100, 30, 100, 125)];
        [self.chooseImageViewsArray addObject:chooseImageView];
        [self.imageScrollView addSubview:chooseImageView];
    }
    
    for (int i = 0; i < self.chooseImageViewsArray.count ; i ++) {
        ChooseImageView *chooseIV = self.chooseImageViewsArray[i];
        CGRect frame = CGRectMake(100 * i, 30, 100, 125);
        chooseIV.frame = frame;
    }
    self.imageScrollView.contentSize = CGSizeMake(self.chooseImageViewsArray.count * 100, 0);
}

@end
