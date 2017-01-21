//
//  LeftMenuView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) void(^LeftCallBack) (NSInteger tag);

@property (nonatomic) UIImageView *backImageView;
@property (nonatomic) UIView *blackView;
@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *nickLabel;
@property (nonatomic) UITableView *menuTableView;
@property (nonatomic) UIButton *settingButton;
@property (nonatomic) UIButton *nightButton;

@end
