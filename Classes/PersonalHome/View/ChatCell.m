//
//  ChatCell.m
//  WeChat1
//
//  Created by 刘岑颖 on 16/9/12.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ChatCell.h"
#import "UIViewExt.h"
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"

#define LYMargin 8

@interface ChatCell ()

@property (nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ChatCell

//创建的代码只能写在这个方法中
- (void)awakeFromNib {
    [super awakeFromNib];
    self.headIV.layer.cornerRadius = self.headIV.width/2;
    self.headIV.layer.masksToBounds = YES;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 9, 250, 0)];
    self.textView.backgroundColor = [UIColor clearColor];
    [self.backIV addSubview:self.textView];
    
    self.messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 100, 100)];
    [self.backIV addSubview:self.messageImageView];
    
    self.voiceView = [[NSBundle mainBundle] loadNibNamed:@"TRVoiceView" owner:self options:nil][0];
    self.voiceView.userInteractionEnabled = YES;
    [self.backIV addSubview:self.voiceView];
    self.backIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *playVoiceAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVoiceAction)];
    [self.voiceView addGestureRecognizer:playVoiceAction];
}

- (void)playVoiceAction{
    //播放声音
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = self.message.messageBodies.firstObject;
    
    EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
    
    if (![self.message.to isEqualToString:[self.toUser objectForKey:@"username"]]) {//自己发送的内容
        NSData *data = [NSData dataWithContentsOfFile:body.localPath];
        data = DecodeAMRToWAVE(data);
        
        [self.voiceView beginAnimation];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        [self.audioPlayer play];
        
    }else{//对方发送的
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:body.remotePath]];
            
            data = DecodeAMRToWAVE(data);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
                [self.audioPlayer play];
                [self.voiceView beginAnimation];
            });
        });
    }
}

- (void)setMessage:(EMMessage *)message{
    _message = message;
    
    self.timeLB.text = [Utils parseTimeWithTimeStap:message.timestamp];
    if ([message.from isEqualToString:self.toUser.mobilePhoneNumber]) {
        //对方发的
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[self.toUser objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        self.headIV.left = LYMargin;
        
    }else{
        //自己发的
        BmobUser *user = [BmobUser currentUser];
        
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
        self.headIV.left = screenWidth-self.headIV.width-LYMargin;        
    }
    
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {            
            self.messageImageView.hidden = self.voiceView.hidden = YES;
            self.textView.hidden = NO;
            
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //设置最大宽度不超过250
            self.textView.text = txt;
            self.textView.font = [UIFont systemFontOfSize:14];
            
            CGSize textSize = [Utils sizeWithFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(250, 0) andStr:txt];
            
            self.textView.size = CGSizeMake(textSize.width + 10, textSize.height + 8);
            
//            NSLog(@"textview frame = %@",NSStringFromCGRect(self.textView.frame));
            
            self.backIV.size = CGSizeMake(self.textView.width+20, self.textView.height+18);
        }
            break;
        case eMessageBodyType_Image:
        {
            self.messageImageView.hidden = NO;
            
            self.textView.hidden = self.voiceView.hidden = YES;
            
            // 得到一个图片消息body
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            
            if ([message.to isEqualToString:self.toUser.username]) {//自己发送的内容
                self.messageImageView.image = [UIImage imageWithContentsOfFile:body.localPath];
            }else{
                
                [self.messageImageView sd_setImageWithURL:[NSURL URLWithString:body.remotePath] placeholderImage:[UIImage imageNamed:@"404"]];
            }
            //让气泡跟着变大
            self.backIV.size = CGSizeMake(self.messageImageView.width + 20, self.messageImageView.height + 18);
        }
            break;
        case eMessageBodyType_Voice:
        {
            self.voiceView.hidden = NO;
            self.textView.hidden = self.messageImageView.hidden = YES;
            
            EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
            
            self.voiceView.timeLabel.text = [NSString stringWithFormat:@"%ld",body.duration];
            
            self.voiceView.origin  = CGPointMake(15, 12);

             self.backIV.size = CGSizeMake(60 + 30, 25 + 24);
            if ([message.to isEqualToString:self.toUser.username]) {//自己发送的内容
                [self.voiceView changeLocation:YES];
                
                self.backIV.left = screenWidth-self.headIV.width-LYMargin-self.backIV.width;
            }else{
                [self.voiceView changeLocation:NO];
                self.backIV.left = self.headIV.width+LYMargin;
            }
        }
            break;
    }
    
    
    if ([message.from isEqualToString:self.toUser.mobilePhoneNumber]) {
        UIImage *image = [UIImage imageNamed:@"chat_recive_press_pic"];
        //设置图片的拉伸效果
        self.backIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(19, 23, 31, 36) resizingMode:UIImageResizingModeStretch];
        //显示到左边
        self.backIV.left = self.headIV.width+LYMargin;
    }else{
        UIImage *image = [UIImage imageNamed:@"chat_send_nor_pic"];
        //设置图片的拉伸效果
        self.backIV.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(33, 25, 18, 20) resizingMode:UIImageResizingModeStretch];
        //显示到右边
        self.backIV.left = screenWidth-self.headIV.width-LYMargin-self.backIV.width;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
