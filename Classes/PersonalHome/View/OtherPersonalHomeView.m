//
//  OtherPersonalHomeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "OtherPersonalHomeView.h"

@implementation OtherPersonalHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self contentTableView];
        [self headImageView];
        [self tableHeadView];
        [self usernameLabel];
        [self attentionButton];
        [self zanButton];
        [self countLabel];
    }
    return self;
}

- (void)setCurrentUser:(BmobUser *)currentUser{
    _currentUser = currentUser;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[self.currentUser objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.usernameLabel.text = [currentUser objectForKey:@"username"];
    if ([[currentUser objectForKey:@"introduce"] isEqualToString:@""] || [currentUser objectForKey:@"introduce"] == nil) {
        self.textLabel.text = @"暂无简介";
    }else{
        self.textLabel.text = [currentUser objectForKey:@"introduce"];
    }
    
    CGSize introduceSize = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 15, 0) andStr:[currentUser objectForKey:@"introduce"]];
    CGRect frame = CGRectMake(0, 0, screenWidth, 113 + introduceSize.height + 35);
    self.tableHeadView.frame = frame;
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [[UIApplication sharedApplication].keyWindow addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(34);
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(60);
        }];
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        _contentTableView.tableFooterView = [UIView new];
    }
    return _contentTableView;
}

- (UIView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 142)];
        self.contentTableView.tableHeaderView = _tableHeadView;
        _tableHeadView.backgroundColor = [Utils colorRGB:@"#f9f9f9"];
        
        UIView *lineView = [[UIView alloc] init];
        [_tableHeadView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor = [Utils colorRGB:@"#cdcdcd"];
    }
    return _tableHeadView;
}

- (UILabel *)usernameLabel{
    if (_usernameLabel == nil) {
        _usernameLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_usernameLabel];
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(38);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(20);
        }];
        _usernameLabel.text = @"用户名";
        _usernameLabel.textColor = [Utils colorRGB:@"#666666"];
        _usernameLabel.font = [UIFont systemFontOfSize:17];
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _usernameLabel;
}

- (UILabel *)textLabel{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        _textLabel.text = @"简介";
        _textLabel.textColor = [Utils colorRGB:@"#999999"];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIButton *)attentionButton{
    if (_attentionButton == nil) {
        _attentionButton = [[UIButton alloc] init];
        [self.tableHeadView addSubview:_attentionButton];
        [_attentionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(-50);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.textLabel.mas_bottom).mas_equalTo(8);
        }];
        [_attentionButton setBackgroundColor:[Utils colorRGB:@"#4eee94"]];
        _attentionButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_attentionButton setTitle:@"关注" forState:UIControlStateNormal];
        [_attentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attentionButton.tag = 100;
        [_attentionButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attentionButton;
}

- (UIButton *)zanButton{
    if (_zanButton == nil) {
        _zanButton = [[UIButton alloc] init];
        [self.tableHeadView addSubview:_zanButton];
        [_zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(50);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.textLabel.mas_bottom).mas_equalTo(8);
        }];
        [_zanButton setBackgroundColor:[UIColor whiteColor]];
        _zanButton.layer.borderColor = [Utils colorRGB:@"#4eee94"].CGColor;
        _zanButton.layer.borderWidth = 1;
        _zanButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_zanButton setTitle:@"点赞" forState:UIControlStateNormal];
        [_zanButton setTitleColor:[Utils colorRGB:@"#4eee94"] forState:UIControlStateNormal];
        _zanButton.tag = 200;
        [_zanButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zanButton;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        _countLabel = [[UILabel alloc] init];
        [self.tableHeadView addSubview:_countLabel];
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(15);
            make.top.mas_equalTo(self.zanButton.mas_bottom).mas_equalTo(8);
        }];
        _countLabel.text = @"共0条";
        _countLabel.textColor = [UIColor lightGrayColor];
        _countLabel.font = [UIFont systemFontOfSize:10];
        _countLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countLabel;
}

#pragma mark - Method -------------------------------

- (void)buttonClickedAction:(UIButton *)button{
    if (button.tag == 100) {
        //关注
        if ([button.currentTitle isEqualToString:@"关注"]) {
            BmobObject *object = [BmobObject objectWithClassName:@"Attention"];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:self.currentUser forKey:@"ToUser"];
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    
                    //UserCount
                    
                    [self changeUserCountTableWith:YES andText:@"attentionCount"];

                    
                    
                    [Utils toastview:@"关注成功！"];
                    [button setTitle:@"已关注" forState:UIControlStateNormal];
                    [button setBackgroundColor:[UIColor lightGrayColor]];
                }
            }];
        }else{
            BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
            [query whereKey:@"User" equalTo:[BmobUser currentUser]];
            [query whereKey:@"ToUser" equalTo:self.currentUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count > 0) {
                    BmobObject *obj = array.firstObject;
                    [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [button setTitle:@"关注" forState:UIControlStateNormal];
                            [button setBackgroundColor:[Utils colorRGB:@"#4eee94"]];
                            
                            
                            [self changeUserCountTableWith:NO andText:@"attentionCount"];

                            
                        }
                    }];
                }
            }];
        }
    }else{
        //赞
        if ([button.currentTitle isEqualToString:@"点赞"]) {
            BmobObject *object = [BmobObject objectWithClassName:@"Zan"];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:self.currentUser forKey:@"ToUser"];
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    
                    [self changeUserCountTableWith:YES andText:@"zanCount"];

                    
                    
                    [button setTitle:@"已赞" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    button.layer.borderColor = [UIColor lightGrayColor].CGColor;
                }
            }];
        }else{
            BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
            [query whereKey:@"User" equalTo:[BmobUser currentUser]];
            [query whereKey:@"ToUser" equalTo:self.currentUser];
            [query whereKeyDoesNotExist:@"Note"];
            [query whereKeyDoesNotExist:@"Comment"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count > 0) {
                    BmobObject *obj = array.firstObject;
                    [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            
                            [self changeUserCountTableWith:NO andText:@"zanCount"];
                            
                            [button setTitle:@"点赞" forState:UIControlStateNormal];
                            [button setTitleColor:[Utils colorRGB:@"#4eee94"] forState:UIControlStateNormal];
                            button.layer.borderColor = [Utils colorRGB:@"#4eee94"].CGColor;
                        }
                    }];
                }
            }];
        }
    }
}

- (void)changeUserCountTableWith:(BOOL)isIncrease andText:(NSString *)key{
    BmobQuery *userCount = [BmobQuery queryWithClassName:@"UserCount"];
    [userCount whereKey:@"User" equalTo:self.currentUser];
    [userCount findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            BmobObject *userObj = array.firstObject;
            BmobObject *userCountObj = [BmobObject objectWithoutDataWithClassName:@"UserCount" objectId:userObj.objectId];
            
            if(isIncrease == YES){
                [userCountObj incrementKey:key byNumber:@1];
            }else{
                [userCountObj decrementKey:key byNumber:@1];
            }
            
            [userCountObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            }];
        }
    }];
}

@end
