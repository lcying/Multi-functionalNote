//
//  WritePicNoteViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WritePicNoteViewController.h"
#import "WritePicNoteView.h"
#import "ChooseImageView.h"

@interface WritePicNoteViewController ()

@property (nonatomic) WritePicNoteView *writeView;
@property (nonatomic) FailedView *stateView;

@end

@implementation WritePicNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.writeView = [[WritePicNoteView alloc] init];
    [self.view addSubview:self.writeView];
    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    __block __weak WritePicNoteViewController *weakself = self;
    
    if (self.noteModel) {
        self.writeView.noteModel = self.noteModel;
        self.writeView.headView.titleLabel.text = @"编辑笔记";
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
        [weakself.view endEditing:YES];
        if ([weakself.writeView.titleTextField.text isEqualToString:@""]) {
            [Utils toastview:@"请输入标题"];
            return;
        }
        
        weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在上传..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];
        
        if (weakself.noteModel) {
            //更新
            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:weakself.noteModel.objectId];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            
            [object setObject:weakself forKey:@"content"];

            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [weakself.stateView removeFromSuperview];
                if (isSuccessful) {
                    
                    NSMutableArray *imageDatas = [NSMutableArray array];
                    for (ChooseImageView *iv in weakself.writeView.chooseImageViewsArray) {
                        if (iv.showImageIV.hidden == NO) {
                            NSData *imageData = UIImageJPEGRepresentation(iv.showImageIV.image, 0.5);
                            [imageDatas addObject:@{@"filename":@"image.jpg",@"data":imageData}];
                        }
                    }
                    
                    if (imageDatas.count > 0) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                        [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
                        hud.label.text =@"正在上传图片...";
                        
                        [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
                            hud.progress = progress;
                            hud.label.text = [NSString stringWithFormat:@"%d-%ld",index+1,imageDatas.count];
                        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [hud hideAnimated:YES];
                                NSMutableArray *imageUrls = [NSMutableArray array];
                                for (BmobFile *file in array) {
                                    [imageUrls addObject:file.url];
                                }
                                [object setObject:imageUrls forKey:@"imagePaths"];
                                
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        [weakself dismissViewControllerAnimated:YES completion:nil];
                                    }else{
                                        [Utils toastViewWithError:error];
                                    }
                                }];
                                
                            }
                        }];
                    }
                    
                    
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
            
        }else{
            //上传
            
            BmobObject *object = [BmobObject objectWithClassName:@"Note"];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            [object setObject:weakself.writeView.contentTextView.text forKey:@"content"];
            [object setObject:@"1" forKey:@"type"];
            if (weakself.categoryObject) {
                [object setObject:weakself.categoryObject forKey:@"Category"];
            }
            [object setObject:@"NO" forKey:@"isOpen"];
            [object setObject:@"NO" forKey:@"readOpen"];

            
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [weakself.stateView removeFromSuperview];
                if (isSuccessful) {
                    
                    
                    NSMutableArray *imageDatas = [NSMutableArray array];
                    for (ChooseImageView *iv in weakself.writeView.chooseImageViewsArray) {
                        if (iv.showImageIV.hidden == NO) {
                            NSData *imageData = UIImageJPEGRepresentation(iv.showImageIV.image, 0.5);
                            [imageDatas addObject:@{@"filename":@"image.jpg",@"data":imageData}];
                        }
                    }
                    
                    if (imageDatas.count > 0) {
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                        [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];
                        hud.label.text =@"正在上传图片...";
                        
                        [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
                            hud.progress = progress;
                            hud.label.text = [NSString stringWithFormat:@"%d-%ld",index+1,imageDatas.count];
                        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                [hud hideAnimated:YES];
                                NSMutableArray *imageUrls = [NSMutableArray array];
                                for (BmobFile *file in array) {
                                    [imageUrls addObject:file.url];
                                }
                                [object setObject:imageUrls forKey:@"imagePaths"];
                                
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        [weakself dismissViewControllerAnimated:YES completion:nil];
                                    }else{
                                        [Utils toastViewWithError:error];
                                    }
                                }];
                                
                            }
                        }];
                    }
                    
                    
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }
        
        
    }];
}

@end
