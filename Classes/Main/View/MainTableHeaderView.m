//
//  MainTableHeaderView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "MainTableHeaderView.h"

@implementation MainTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self backImageView];
        [self leftButton];
        [self rightButton];
        [self latestButton];
        [self allButton];
        [self lineView];
    }
    return self;
}

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImageW"]];
        [self addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-400);
        }];
    }
    return _backImageView;
}

- (UIButton *)leftButton{
    if (_leftButton == nil) {
        _leftButton = [[UIButton alloc] init];
        _leftButton.tag = 10;
        [self addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(70);
            make.bottom.mas_equalTo(0);
        }];
        [_leftButton setImage:[UIImage imageNamed:@"homeWhite"] forState:UIControlStateNormal];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(8.5, 20, 10.5, 25);
        [_leftButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton{
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        [self addSubview:_rightButton];
        _rightButton.tag = 11;
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(70);
            make.bottom.mas_equalTo(0);
        }];
        [_rightButton setImage:[UIImage imageNamed:@"addFile"] forState:UIControlStateNormal];
        _rightButton.imageEdgeInsets = UIEdgeInsetsMake(8.5, 20, 10.5, 25);
        [_rightButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIButton *)latestButton{
    if (_latestButton == nil) {
        _latestButton = [[UIButton alloc] init];
        _latestButton.tag = 12;
        [_latestButton setTitle:@"最新" forState:UIControlStateNormal];
        [_latestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _latestButton.selected = YES;
        _latestButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_latestButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _latestButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_latestButton];
        [_latestButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-22);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(38);
            make.bottom.mas_equalTo(0);
        }];
        [_latestButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _latestButton;
}

- (UIButton *)allButton{
    if (_allButton == nil) {
        _allButton = [[UIButton alloc] init];
        _allButton.tag = 13;
        [_allButton setTitle:@"全部" forState:UIControlStateNormal];
        [_allButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _allButton.selected = NO;
        _allButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_allButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self addSubview:_allButton];
        _allButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_allButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(22);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(38);
            make.bottom.mas_equalTo(0);
        }];
        [_allButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth/2.0 - 40, 57, 38, 1)];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
    }
    return _lineView;
}

#pragma mark - Method --------------------------------------
- (void)buttonClickedAction:(UIButton *)button{
    _HomeHeadCallBack(button.tag);
    switch (button.tag) {
        case 10:
        {//左
            [self openMenuAction];
        }
            break;
        case 11:
        {//右
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"新建文件夹" message:@"请输入文件夹名称" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *filename = ac.textFields.firstObject.text;
                if ([filename isEqualToString:@""]) {
                    [Utils toastview:@"请输入文件名"];
                    return ;
                }
                BmobObject *object = [BmobObject objectWithClassName:@"Category"];
                [object setObject:filename forKey:@"filename"];
                [object setObject:[BmobUser currentUser] forKey:@"User"];
                [object setObject:@"NO" forKey:@"readOpen"];

                [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [Utils toastview:@"创建成功！"];
                        
                        _RefreshCallBack(@"刷新");
                        
                    }else{
                        [Utils toastViewWithError:error];
                    }
                }];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [[self viewController] presentViewController:ac animated:YES completion:nil];
        }
            break;
    }
}

- (void)openMenuAction{
    XHDrawerController *vc = (XHDrawerController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc toggleDrawerSide:XHDrawerSideLeft animated:YES completion:nil];
}

@end
