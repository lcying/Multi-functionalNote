//
//  WriteRecordNoteViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WriteRecordNoteViewController.h"
#import "WriteRecordView.h"

@interface WriteRecordNoteViewController ()

@property (nonatomic) WriteRecordView *writeView;
@property (nonatomic) FailedView *stateView;

@end

@implementation WriteRecordNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.writeView = [[WriteRecordView alloc] init];
    [self.view addSubview:self.writeView];
    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak WriteRecordNoteViewController *weakself = self;

    if (self.noteModel) {
        self.writeView.headView.rightButton.hidden = YES;
        self.writeView.noteModel = self.noteModel;
        self.writeView.headView.titleLabel.text = @"录音笔记";
        [self.writeView.bottomView setToolsBottomCallBack:^(NSInteger i) {
            switch (i) {
                case 11:
                {//分享
                    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        // 根据获取的platformType确定所选平台进行下一步操作
                        
                        [Utils shareTextToPlatformType:platformType andText:weakself.writeView.titleTextField.text];
                    }];
                }
                    break;
            }
        }];
    }
    
    [self.writeView.headView setHeadCallBack:^(id obj) {
        
        if ([weakself.writeView.titleTextField.text isEqualToString:@""]) {
            [Utils toastview:@"请输入标题"];
            return;
        }
        
        weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在上传..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];
        if (weakself.noteModel) {
            //更新
            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:weakself.noteModel.objectId];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:@"2" forKey:@"type"];
            [object setObject:weakself.writeView.timeLabel.text forKey:@"seconds"];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            BmobFile *voiceFile = [[BmobFile alloc] initWithFileName:@"voice.amr" withFileData:weakself.writeView.voiceData];
            [voiceFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [weakself.stateView removeFromSuperview];
                    //建立联系并且保存
                    [object setObject:voiceFile.url forKey:@"voicePath"];
                    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        
                        if (isSuccessful) {
                            [weakself dismissViewControllerAnimated:YES completion:nil];
                        }else{
                            [Utils toastViewWithError:error];
                        }
                    }];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }else{
            //上传
            BmobObject *object = [BmobObject objectWithClassName:@"Note"];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:@"2" forKey:@"type"];
            
            if (weakself.categoryObject) {
                [object setObject:weakself.categoryObject forKey:@"Category"];
            }
            
            [object setObject:weakself.writeView.timeLabel.text forKey:@"seconds"];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            [object setObject:@"NO" forKey:@"isOpen"];
            [object setObject:@"NO" forKey:@"readOpen"];

            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (weakself.writeView.voiceData) {
                    BmobFile *voiceFile = [[BmobFile alloc] initWithFileName:@"voice.amr" withFileData:weakself.writeView.voiceData];
                    [voiceFile saveInBackground:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [weakself.stateView removeFromSuperview];
                            //建立联系并且保存
                            [object setObject:voiceFile.url forKey:@"voicePath"];
                            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                
                                if (isSuccessful) {
                                    [weakself dismissViewControllerAnimated:YES completion:nil];
                                }else{
                                    [Utils toastViewWithError:error];
                                }
                            }];
                        }else{
                            [Utils toastViewWithError:error];
                        }
                    }];
                }
            }];
        }
    }];
}

@end
