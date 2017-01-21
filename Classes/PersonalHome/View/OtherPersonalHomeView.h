//
//  OtherPersonalHomeView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviHeadView.h"

@interface OtherPersonalHomeView : UIView

@property (nonatomic) BmobUser *currentUser;

@property (nonatomic) UITableView *contentTableView;

@property (nonatomic) UIView *tableHeadView;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) UILabel *introduceLabel;
@property (nonatomic) UIButton *attentionButton;
@property (nonatomic) UIButton *zanButton;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UILabel *countLabel;

@property (nonatomic) UIImageView *headImageView;

@end
