//
//  ClockCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockModel.h"

@interface ClockCell : UITableViewCell

@property (nonatomic) ClockModel *model;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *isRepeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
