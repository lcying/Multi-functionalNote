//
//  ConversationCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/23.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ConversationCell.h"

@implementation ConversationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.countLabel.layer.cornerRadius = 10;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

- (void)setToUser:(BmobUser *)toUser{
    _toUser = toUser;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[toUser objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.usernameLabel.text = [toUser objectForKey:@"username"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
