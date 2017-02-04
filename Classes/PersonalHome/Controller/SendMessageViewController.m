//
//  SendMessageViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/22.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "SendMessageViewController.h"
#import "SendView.h"
#import <IQKeyboardManager.h>

@interface SendMessageViewController ()<EMChatManagerDelegate>

@property (nonatomic) SendView *sendView;

@end

@implementation SendMessageViewController

- (void)setToUser:(BmobUser *)toUser{
    _toUser = toUser;
    self.title = [self.toUser objectForKey:@"username"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sendView = [[SendView alloc] init];
    [self.view addSubview:self.sendView];
    [self.sendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.sendView.toUser = self.toUser;
}

@end
