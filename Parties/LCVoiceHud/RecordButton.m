//
//  LYRecordButton.m
//  ITSNS
//
//  Created by Ivan on 16/1/13.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "RecordButton.h"
#import "amrFileCodec.h"
NSString *const RecordDidFinishNotification = @"RecordDidFinishNotification";
@implementation RecordButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initRecode];
       
    }
    return self;
}
-(void)awakeFromNib{
    [self initRecode];
}
-(void)initRecode{
    //用来处理录音的对象
    self.voice = [[LCVoice alloc] init] ;
    
    [self setImage:[UIImage imageNamed:@"mic_normal_358x358@2x.png"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"mic_talk_358x358@2x.png"] forState:UIControlStateHighlighted];
    
    
    //开始录音事件
    [self addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventTouchDown];
    //结束录音事件
    [self addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventTouchUpInside];
    //取消录音事件
    [self addTarget:self action:@selector(recordCancel) forControlEvents:UIControlEventTouchUpOutside];
}

-(void) recordStart
{
    [self.voice startRecordWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.wav", NSHomeDirectory()]];
}

-(void) recordEnd
{
    [self.voice stopRecordWithCompletionBlock:^{
        
        if (self.voice.recordTime > 0.0f) {
            
            NSData *data = [NSData dataWithContentsOfFile:self.voice.recordPath];
           
            //把wav格式转换成amr压缩格式
            NSData *newData = EncodeWAVEToAMR(data, 1, 16);
            
            //把录好的音频数据通过通知传递出去
            [[NSNotificationCenter defaultCenter]postNotificationName:RecordDidFinishNotification object:@{@"time":@(self.voice.recordTime),@"data":newData}];
            //这行必加 不然会崩溃
            [self.voice cancelled];
        }
        
    }];
}

-(void) recordCancel
{
    [self.voice cancelled];
    

    NSLog(@"取消录制");
    
}



@end
