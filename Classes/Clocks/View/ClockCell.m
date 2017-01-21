//
//  ClockCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ClockCell.h"

#define repeatYES @"重复"
#define repeatNO @"不重复"

@implementation ClockCell

- (void)setModel:(ClockModel *)model{
    _model = model;
    
    self.timeLabel.text = model.time;
    
    if (model.content) {
        self.contentLabel.text = model.content;
    }
    
    if (model.repeat == 0) {
        self.isRepeatLabel.text = @"重复";
    }else{
        self.isRepeatLabel.text = @"不重复";
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
