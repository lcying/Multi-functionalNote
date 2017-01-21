//
//  ReadHeadView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ReadHeadView.h"

@implementation ReadHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel];
        [self headImageView];
        [self focusButton];
        [self createdLabel];
        [self wordCountLabel];
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    if ([[noteModel.User objectForKey:@"mobilePhoneNumber"] isEqualToString:[BmobUser currentUser].mobilePhoneNumber]) {
        self.focusButton.hidden = YES;
    }
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(25);
            make.top.mas_equalTo(15);
        }];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:25];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(8);
            make.width.height.mas_equalTo(30);
        }];
        _headImageView.layer.cornerRadius = 15;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UIButton *)focusButton{
    if (_focusButton == nil) {
        _focusButton= [[UIButton alloc] init];
        [self addSubview:_focusButton];
        [_focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(-8);
        }];
        [_focusButton setBackgroundColor:[Utils colorRGB:@"#4eee94"]];
        [_focusButton setTitle:@"＋" forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_focusButton addTarget:self action:@selector(focusAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focusButton;
}

- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [self addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(self.focusButton.mas_left).mas_equalTo(-8);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(8);
        }];
        _usernameLabel.textColor = [UIColor blackColor];
        _usernameLabel.font = [UIFont systemFontOfSize:15];
        _usernameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _usernameLabel;
}

- (UILabel *)createdLabel{
    if (_createdLabel == nil) {
        _createdLabel = [[UILabel alloc] init];
        [self addSubview:_createdLabel];
        [_createdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.headImageView.mas_bottom).mas_equalTo(8);
        }];
        _createdLabel.textAlignment = NSTextAlignmentLeft;
        _createdLabel.font = [UIFont systemFontOfSize:12];
        _createdLabel.textColor = [UIColor darkGrayColor];
    }
    return _createdLabel;
}

- (UILabel *)wordCountLabel{
    if (_wordCountLabel == nil) {
        _wordCountLabel = [[UILabel alloc] init];
        [self addSubview:_wordCountLabel];
        [_wordCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.createdLabel.mas_right).mas_equalTo(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(44);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(8);
        }];
        _wordCountLabel.textAlignment = NSTextAlignmentLeft;
        _wordCountLabel.font = [UIFont systemFontOfSize:12];
        _wordCountLabel.textColor = [UIColor darkGrayColor];
    }
    return _wordCountLabel;
}

- (UILabel *)readCountLabel{
    if (_readCountLabel == nil) {
        _readCountLabel = [[UILabel alloc] init];
        [self addSubview:_readCountLabel];
        [_readCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.wordCountLabel.mas_right).mas_equalTo(5);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(8);
        }];
        _readCountLabel.textAlignment = NSTextAlignmentLeft;
        _readCountLabel.font = [UIFont systemFontOfSize:12];
        _readCountLabel.textColor = [UIColor darkGrayColor];
    }
    return _readCountLabel;
}

- (void)focusAction:(UIButton *)button{
    if ([button.currentTitle isEqualToString:@"已关注"]) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消关注？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
            [query whereKey:@"User" equalTo:[BmobUser currentUser]];
            [query whereKey:@"ToUser" equalTo:self.noteModel.User];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count > 0) {
                    for (BmobObject *obj in array) {
                        [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [button setTitle:@"＋" forState:UIControlStateNormal];
                                [button setBackgroundColor:[Utils colorRGB:@"#4eee94"]];

                            }else{
                                [Utils toastViewWithError:error];
                            }
                        }];
                    }
                    
                    /*--userCount表中-1--*/
                    
                    BmobQuery *userCount = [BmobQuery queryWithClassName:@"UserCount"];
                    [userCount whereKey:@"User" equalTo:self.noteModel.User];
                    [userCount findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (array) {
                            BmobObject *userObj = array.firstObject;
                            BmobObject *userCountObj = [BmobObject objectWithoutDataWithClassName:@"UserCount" objectId:userObj.objectId];
                            [userCountObj decrementKey:@"attentionCount" byNumber:@1];
                            [userCountObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (error) {
                                    
                                }
                            }];
                        }
                    }];

                    
                }
            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [[self viewController] presentViewController:ac animated:YES completion:nil];
    }else{
        BmobObject *obj = [BmobObject objectWithClassName:@"Attention"];
        [obj setObject:[BmobUser currentUser] forKey:@"User"];
        [obj setObject:self.noteModel.User forKey:@"ToUser"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                NSString *mes = [NSString stringWithFormat:@"您已成功关注%@",[self.noteModel.User objectForKey:@"username"]];
                [Utils toastview:mes];
                [button setTitle:@"已关注" forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor lightGrayColor]];
                
                /*--userCount表中＋1--*/
                
                BmobQuery *userCount = [BmobQuery queryWithClassName:@"UserCount"];
                [userCount whereKey:@"User" equalTo:self.noteModel.User];
                [userCount findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (array) {
                        
                        BmobObject *userObj = array.firstObject;
                        BmobObject *userCountObj = [BmobObject objectWithoutDataWithClassName:@"UserCount" objectId:userObj.objectId];
                        [userCountObj incrementKey:@"attentionCount" byNumber:@1];
                        [userCountObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (error) {
                                
                            }
                        }];
                    }
                }];
                
            }
        }];
    }
}

@end
