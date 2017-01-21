//
//  EditPersonalInfoViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "EditPersonalInfoViewController.h"

@interface EditPersonalInfoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *personalIntroductionTextView;
@property (nonatomic) int attentionCount;
@property (nonatomic) int zanCount;
@property (nonatomic) NSString *imagePath;
@end

@implementation EditPersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"编辑信息";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    self.attentionCount = 0;
    self.zanCount = 0;
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.layer.masksToBounds = YES;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.usernameTextField.text = [[BmobUser currentUser] objectForKey:@"username"];
    if ([[BmobUser currentUser] objectForKey:@"introduce"]) {
        self.personalIntroductionTextView.text = [NSString stringWithFormat:@"个人简介：%@",[[BmobUser currentUser] objectForKey:@"introduce"]];
    }
    
    [self requestAttentionCount];
    [self requestZanCount];
    
    UITapGestureRecognizer *tapHeadImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageViewAction)];
    [self.headImageView addGestureRecognizer:tapHeadImageView];
}

//统计关注我的人数
- (void)requestAttentionCount{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.attentionCount = number;
        self.countLabel.text = [NSString stringWithFormat:@"%d人关注・%d人点赞",number,self.zanCount];
    }];
}

//统计赞我的人数
- (void)requestZanCount{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query whereKeyDoesNotExist:@"Note"];
    [query whereKeyDoesNotExist:@"Comment"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.zanCount = number;
        self.countLabel.text = [NSString stringWithFormat:@"%d人关注・%d人点赞",self.attentionCount,number];
    }];
}

- (void)tapHeadImageViewAction{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.allowsEditing = YES;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)saveAction{
 
    BmobUser *user = [BmobUser currentUser];
    [user setObject:self.usernameTextField.text forKey:@"username"];
    NSString *introduce = [self.personalIntroductionTextView.text componentsSeparatedByString:@"个人简介："].lastObject;
    [user setObject:introduce forKey:@"introduce"];
    
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSData *imageData = nil;
            if ([self.imagePath hasSuffix:@"PNG"]) {
                imageData = UIImagePNGRepresentation(self.headImageView.image);
            }else{//jpg
                imageData = UIImageJPEGRepresentation(self.headImageView.image, .5);
            }
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
            hud.label.text = NSLocalizedString(@"正在上传，请稍侯...", @"");
            
            if (imageData) {
                [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"head.jpg",@"data":imageData}] progressBlock:^(int index, float progress) {
                    hud.progress = progress;
                } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        BmobFile *file = [array firstObject];
                        NSString *headPath = file.url;
                        [user setObject:headPath forKey:@"headPath"];
                        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            [hud hideAnimated:YES];
                            if (error) {
                                [Utils toastViewWithError:error];
                            }else{
                                [Utils toastview:@"保存成功！"];
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

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //得到编辑后的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isAutoSave = [ud boolForKey:@"autoSavePhoto"];
    if (isAutoSave) {
        if (isAutoSave == YES) {
            //保存图片到自建相册
            [Utils phAuthorizationCheckWithImage:image];
            
            //当image从相机中获取的时候存入相册中 自动保存到系统相册
            /*
             if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
             UIImageWriteToSavedPhotosAlbum(image,self,@selector(image:didFinishSavingWithError:contextInfo:),NULL);
             }
             */
        }
    }
    
    self.headImageView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imagePath = [info[UIImagePickerControllerReferenceURL] description];
}


@end
