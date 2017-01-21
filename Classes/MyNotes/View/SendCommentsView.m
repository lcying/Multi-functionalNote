//
//  SendCommentsView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SendCommentsView.h"

@implementation SendCommentsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headView];
        self.commentTextView = [[UITextView alloc] init];
        [self addSubview:self.commentTextView];
        [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
        }];
        self.commentTextView.textColor = [UIColor darkGrayColor];
        self.commentTextView.font = [UIFont systemFontOfSize:16];
        self.commentTextView.delegate = self;
        
        UILabel *lb = [[UILabel alloc] init];
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(self.commentTextView.mas_top).mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(18);
        }];
        lb.text = @"请写下你的见解...";
        lb.textColor = [UIColor lightGrayColor];
        lb.font = [UIFont systemFontOfSize:16];
        self.placeholderLabel = lb;
    }
    return self;
}

- (HeadView *)headView{
    if (_headView == nil) {
        _headView = [[HeadView alloc] init];
        [self addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(64);
        }];
        _headView.titleLabel.text = @"发表评论";
        [_headView.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    }
    return _headView;
}

#pragma mark - UITextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        self.placeholderLabel.hidden = NO;
    }
}

@end
