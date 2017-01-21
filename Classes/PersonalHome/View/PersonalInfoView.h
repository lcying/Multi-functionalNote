//
//  PersonalInfoView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCell.h"

@interface PersonalInfoView : UIView<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UITableView *infoTableView;

@property (nonatomic) UIView *tableHeadView;
@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UITextField *usernameTextField;
@property (nonatomic) UIButton *editUsernameButton;
@property (nonatomic) NSMutableArray *headButtonsArray;//我的赞 我收获的赞  我的评论  我收获的评论

@end
