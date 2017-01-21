//
//  ReadHeadView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadHeadView : UIView

@property (nonatomic) NoteModel *noteModel;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) UILabel *createdLabel;
@property (nonatomic) UILabel *wordCountLabel;
@property (nonatomic) UIButton *focusButton;
@property (nonatomic) UILabel *readCountLabel;

@end
