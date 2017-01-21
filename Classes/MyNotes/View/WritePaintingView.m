//
//  WritePaintingView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "WritePaintingView.h"

@implementation WritePaintingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self headView];
        [self addArcButton];
        [self addRectButton];
        [self addLineButton];
        [self showPaintingBoardButton];
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
        _headView.titleLabel.text = @"新建笔记";
    }
    return _headView;
}

- (UIButton *)addArcButton{
    if (_addArcButton == nil) {
        _addArcButton = [[UIButton alloc] init];
        [self addSubview:_addArcButton];
        [_addArcButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        _addArcButton.tag = 2;
        [_addArcButton setTitle:@"椭圆" forState:UIControlStateNormal];
        [_addArcButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _addArcButton;
}

- (UIButton *)addRectButton{
    if (_addRectButton == nil) {
        _addRectButton = [[UIButton alloc] init];
        [self addSubview:_addRectButton];
        [_addRectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addArcButton.mas_right).mas_equalTo(8);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        _addRectButton.tag = 3;
        [_addRectButton setTitle:@"矩形" forState:UIControlStateNormal];
        [_addRectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _addRectButton;
}

- (UIButton *)addLineButton{
    if (_addLineButton == nil) {
        _addLineButton = [[UIButton alloc] init];
        [self addSubview:_addLineButton];
        [_addLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.addRectButton.mas_right).mas_equalTo(8);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(40);
        }];
        _addLineButton.tag = 1;
        [_addLineButton setTitle:@"直线" forState:UIControlStateNormal];
        [_addLineButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _addLineButton;
}

- (UIButton *)showPaintingBoardButton{
    if (_showPaintingBoardButton == nil) {
        _showPaintingBoardButton = [[UIButton alloc] init];
        [self addSubview:_showPaintingBoardButton];
        [_showPaintingBoardButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.headView.mas_bottom).mas_equalTo(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
        }];
        _showPaintingBoardButton.tag = 0;
        [_showPaintingBoardButton setTitle:@"画板设置" forState:UIControlStateNormal];
        [_showPaintingBoardButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return _showPaintingBoardButton;
}

@end
