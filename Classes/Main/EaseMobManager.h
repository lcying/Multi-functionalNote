//
//  EaseMobManager.h
//  环信1
//
//  Created by 刘岑颖 on 16/9/8.
//  Copyright © 2016年 刘岑颖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EaseMob.h"

@interface EaseMobManager : NSObject<EMChatManagerDelegate, IEMChatProgressDelegate>

@property (nonatomic) NSMutableArray *requests;

+ (EaseMobManager *)shareManager;

- (void)registerWithName:(NSString *)name andPassword:(NSString *)password;

- (void)loginWithName:(NSString *)name andPassword:(NSString *)password;

- (void)logout;

- (void)addFriendWithName:(NSString *)name;

- (void)removeFriendWithName:(EMBuddy *)buddy;

- (EMMessage *)sendMessageWithText:(NSString *)text andUsername:(NSString *)username;

- (EMMessage *)sendMessageWithImage:(UIImage *)image andUsername:(NSString *)username;

- (EMMessage *)sendMessageWithVoiceData:(NSData *)data andTime:(float)time andUsername:(NSString *)username;

@end
