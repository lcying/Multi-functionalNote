//
//  LookPaintingViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "LookPaintingViewController.h"
#import "LookPaintingView.h"
#import "WritePaintingViewController.h"

@interface LookPaintingViewController ()

@property (nonatomic) LookPaintingView *lookView;

@end

@implementation LookPaintingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lookView = [[LookPaintingView alloc] init];
    [self.view addSubview:self.lookView];
    [self.lookView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.lookView.noteModel = self.noteModel;
    
    __block __weak LookPaintingViewController *weakself = self;

    [self.lookView.headView setHeadCallBack:^(id obj) {
        //条转到编辑模式
        WritePaintingViewController *vc = [[WritePaintingViewController alloc] init];
        
    }];
    self.lookView.headView.titleLabel.text = @"查看笔记";
    
    [self.lookView.bottomView setToolsBottomCallBack:^(NSInteger tag) {
        switch (tag) {
            case 11:
            {//分享
                [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                    // 根据获取的platformType确定所选平台进行下一步操作
                    
                    [Utils shareTextToPlatformType:platformType andText:@"随手涂鸦"];
                }];
            }
                break;
        }
    }];
    
}

@end
