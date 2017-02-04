    //
//  EaseMobManager.m
//  环信1
//
//  Created by 刘岑颖 on 16/9/8.
//  Copyright © 2016年 刘岑颖. All rights reserved.
//

#import "EaseMobManager.h"

static EaseMobManager *_manager;

@implementation EaseMobManager

+ (EaseMobManager *)shareManager{
    //同步代码块，是线程安全的单例写法，多个线程同时访问时，当已经有一个线程访问，则不会进入这个代码块，而是等待里面的线程出去再执行。括号中的self：如果没有创建对象则代表类，创建对象则代表对象
    @synchronized (self) {
        if (!_manager) {
            _manager = [[EaseMobManager alloc] init];
            [[EaseMob sharedInstance].chatManager addDelegate:_manager delegateQueue:nil];
        }
        return _manager;
    }
}

- (NSMutableArray *)requests {
    if(_requests == nil) {
        _requests = [[NSMutableArray alloc] init];
    }
    return _requests;
}


- (void)registerWithName:(NSString *)name andPassword:(NSString *)password{
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:name password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
//            NSLog(@"~~~~~~~~~~注册成功");
            //注册成功登录一下
            [self loginWithName:name andPassword:password];
        }
    } onQueue:nil];
}

- (void)loginWithName:(NSString *)name andPassword:(NSString *)password{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:name password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            //自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"登录成功" object:nil];
        }else{
            //如果登录失败  注册一下
//            NSLog(@"______+++++______%@",error);
            [self registerWithName:name andPassword:password];
        }
    } onQueue:nil];
}

- (void)logout{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
//            NSLog(@"~~~~~~~~~退出成功");
        }
    } onQueue:nil];
}

- (EMMessage *)sendMessageWithText:(NSString *)text andUsername:(NSString *)username{
    
    EMChatText *txtChat = [[EMChatText alloc] initWithText:text];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    return message;
}

- (void)didSendMessage:(EMMessage *)message error:(EMError *)error{
}

/*!
 @method
 @brief 收到消息时的回调
 @param message      消息对象
 @discussion 当EMConversation对象的enableReceiveMessage属性为YES时，会触发此回调
 针对有附件的消息，此时附件还未被下载。
 附件下载过程中的进度回调请参考didFetchingMessageAttachments:progress:，
 下载完所有附件后，回调didMessageAttachmentsStatusChanged:error:会被触发
 */
- (void)didReceiveMessage:(EMMessage *)message{
    
    NSString *alertBody = nil;
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            alertBody = [NSString stringWithFormat:@"%@:%@",message.from,txt];
        }
            break;
        case eMessageBodyType_Image:
        {
            alertBody = [NSString stringWithFormat:@"%@:图片消息",message.from];
        }
            break;
        case eMessageBodyType_Voice:
        {
            alertBody = [NSString stringWithFormat:@"%@:语音消息",message.from];
            
        }
            break;
    }
    
    //判断程序是否在后台执行
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        //在后台执行
        //后台收到消息时发送本地通知
        UILocalNotification *noti = [[UILocalNotification alloc] init];
        noti.alertBody = alertBody;//提示内容
        //设置显示时间  立即显示
        noti.fireDate = [NSDate new];//直接获取当前时间
        
        //设置传递的参数
        noti.userInfo = @{@"username":message.from};
        
        //把通知添加到日程
        [[UIApplication sharedApplication] scheduleLocalNotification:noti];
        
        //设置显示的数量
        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"接收消息" object:message];
}

- (EMMessage *)sendMessageWithImage:(UIImage *)image andUsername:(NSString *)username{
    EMChatImage *imgChat = [[EMChatImage alloc] initWithUIImage:image displayName:@"abc.jpg"];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithChatObject:imgChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    return message;
}

- (EMMessage *)sendMessageWithVoiceData:(NSData *)data andTime:(float)time andUsername:(NSString *)username{
    EMChatVoice *voice = [[EMChatVoice alloc] initWithData:data displayName:@"a.amr"];
    voice.duration = time;
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:username bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    return message;
}

#pragma mark - IEMChatProgressDelegate
/*!
 @method
 @brief 设置进度
 @discussion 用户需实现此接口用以支持进度显示
 @param progress 值域为0到1.0的浮点数
 @param message  某一条消息的progress
 @param messageBody  某一条消息某个body的progress
 */
- (void)setProgress:(float)progress
         forMessage:(EMMessage *)message
     forMessageBody:(id<IEMMessageBody>)messageBody{
    
}


@end
