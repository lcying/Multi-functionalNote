//
//  ChatCell.h
//  WeChat1
//
//  Created by 刘岑颖 on 16/9/12.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TRVoiceView.h"

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIImageView *backIV;
@property (weak, nonatomic) IBOutlet UIView *myContentView;

@property (nonatomic) UITextView *textView;
@property (nonatomic) UIImageView *messageImageView;
@property (nonatomic) TRVoiceView *voiceView;

@property (nonatomic, strong)EMMessage *message;
@property (nonatomic, strong)BmobUser *toUser;

@end
