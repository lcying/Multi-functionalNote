//
//  ZanMeCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZanModel.h"
#import "CommentModel.h"

@interface ZanMeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *createdLabel;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic) ZanModel *zanModel;

@property (nonatomic) CommentModel *commentModel;

@end
