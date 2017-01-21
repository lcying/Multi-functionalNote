//
//  MyCommentCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/6.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentCell : UITableViewCell

@property (nonatomic) UILabel *commentTitleLabel;
@property (nonatomic) UILabel *commentLabel;
@property (nonatomic) UILabel *createdAtLabel;

@property (nonatomic) BmobObject *commentObject;

@end
