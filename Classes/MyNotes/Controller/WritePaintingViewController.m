//
//  WritePaintingViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "WritePaintingViewController.h"
#import "WritePaintingView.h"

#import "ZYQAssetPickerController.h"
#import "HBDrawView.h"
#import "UIView+WHB.h"

@interface WritePaintingViewController ()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HBDrawViewDelegate>

@property (nonatomic) WritePaintingView *paintingView;
@property (nonatomic) HBDrawView *drawView;
@property (nonatomic) FailedView *stateView;

@end

@implementation WritePaintingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.paintingView = [[WritePaintingView alloc] init];
    [self.view addSubview:self.paintingView];
    [self.paintingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self drawView];
    [self.drawView showSettingBoard];
    
//    if (self.noteModel) {
//        [self.drawView.boardImage sd_setImageWithURL:[NSURL URLWithString:self.noteModel.imagePaths.firstObject] placeholderImage:[UIImage imageNamed:@"404"]];
//    }
    
    __block __weak WritePaintingViewController *weakself = self;
    
    [self.paintingView.headView setHeadCallBack:^(id obj) {
        //上传
        
        weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在上传..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth, screenHeight - 104), NO, 0.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [weakself.drawView.layer renderInContext:context];
        
        UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        //上传
        
        BmobObject *object = [BmobObject objectWithClassName:@"Note"];
        [object setObject:[BmobUser currentUser] forKey:@"User"];
        [object setObject:@"3" forKey:@"type"];
        [object setObject:@"NO" forKey:@"isOpen"];
        [object setObject:@"NO" forKey:@"readOpen"];
        [object setObject:@"随手涂鸦" forKey:@"title"];
        
        
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [weakself.stateView removeFromSuperview];
            if (isSuccessful) {
                
                
                NSMutableArray *imageDatas = [NSMutableArray array];
                NSData *imageData = UIImageJPEGRepresentation(getImage, 0.5);
                [imageDatas addObject:@{@"filename":@"image.jpg",@"data":imageData}];
                
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
        
        
        
    }];
    
    [self.paintingView.addArcButton addTarget:self action:@selector(drawSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.paintingView.addRectButton addTarget:self action:@selector(drawSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.paintingView.addLineButton addTarget:self action:@selector(drawSetting:) forControlEvents:UIControlEventTouchUpInside];
    [self.paintingView.showPaintingBoardButton addTarget:self action:@selector(drawSetting:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)drawSetting:(UIButton *)button{
    [self.drawView setDrawBoardShapeType:button.tag];
    [self.drawView showSettingBoard];
}

- (HBDrawView *)drawView{
    if (!_drawView) {
        _drawView = [[HBDrawView alloc] initWithFrame:CGRectMake(0, 104, screenWidth, screenHeight - 104)];
        _drawView.delegate = self;
        [self.view addSubview:_drawView];
    }
    return _drawView;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.drawView setDrawBoardImage:image];
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^{
        [weakSelf.drawView showSettingBoard];
    }];
}
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *marray = [NSMutableArray array];
    
    for(int i=0;i<assets.count;i++){
        
        ALAsset *asset = assets[i];
        
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        [marray addObject:image];
        
    }
    
    [self.drawView setDrawBoardImage:[marray firstObject]];
}
#pragma mark - HBDrawViewDelegate
- (void)drawView:(HBDrawView *)drawView action:(actionOpen)action
{
    switch (action) {
        case actionOpenAlbum:
        {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
            picker.maximumNumberOfSelection = 1;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            
            break;
        case actionOpenCamera:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *pickVc = [[UIImagePickerController alloc] init];
                
                pickVc.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickVc.delegate = self;
                [self presentViewController:pickVc animated:YES completion:nil];
                
            }else{
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alter show];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
