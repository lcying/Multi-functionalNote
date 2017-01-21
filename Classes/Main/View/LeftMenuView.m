//
//  LeftMenuView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LeftMenuView.h"
#import "NormalTableViewCell.h"

@interface LeftMenuView () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) NSArray *imageNamesArr;
@property (nonatomic) NSArray *titlesArr;

@end

@implementation LeftMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageNamesArr = @[@"mynote",@"share",@"myclock",@"personalCenter",@"collection",@"satisfied"];
        self.titlesArr = @[@"我的笔记",@"大神分享",@"事件提醒",@"个人中心",@"我的收藏",@"用户调查"];
        [self backImageView];
        [self blackView];
        [self headImageView];
        [self nickLabel];
        [self settingButton];
        [self nightButton];
        [self menuTableView];
    }
    return self;
}

- (UIImageView *)backImageView{
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] init];
        [self addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _backImageView.image = [UIImage imageNamed:@"leftBack1"];
    }
    return _backImageView;
}

- (UIView *)blackView{
    if (_blackView == nil) {
        _blackView = [[UIView alloc] init];
        [self addSubview:_blackView];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.2;
        [_blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _blackView;
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(50);
            make.width.height.mas_equalTo(60);
            make.top.mas_equalTo(60);
        }];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView sd_setImageWithURL:[[BmobUser currentUser] objectForKey:@"headPath"] placeholderImage:[UIImage imageNamed:@"headIcon"]];
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeadImageAction:)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UILabel *)nickLabel{
    if (_nickLabel == nil) {
        _nickLabel = [[UILabel alloc] init];
        [self addSubview:_nickLabel];
        [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headImageView.mas_bottom).mas_equalTo(10);
            make.centerX.mas_equalTo(self.headImageView.mas_centerX).mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(160);
        }];
        BmobUser *user = [BmobUser currentUser];
        _nickLabel.text = user.username;
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.textColor = [UIColor whiteColor];
        _nickLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nickLabel;
}

- (UIButton *)settingButton{
    if (_settingButton == nil) {
        _settingButton = [[UIButton alloc] init];
        [self addSubview:_settingButton];
        [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(30);
        }];
        _settingButton.tag = 10;
        [_settingButton setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        _settingButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 39);
        [_settingButton setTitle:@"设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _settingButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _settingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        [_settingButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

- (UIButton *)nightButton{
    if (_nightButton == nil) {
        _nightButton = [[UIButton alloc] init];
        [self addSubview:_nightButton];
        [_nightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(87);
            make.bottom.mas_equalTo(-15);
            make.width.mas_equalTo(65);
            make.height.mas_equalTo(30);
        }];
        _nightButton.tag = 11;
        [_nightButton setImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
        _nightButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 39);
        [_nightButton setTitle:@"夜间" forState:UIControlStateNormal];
        [_nightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _nightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 0);
        [_nightButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nightButton;
}

- (UITableView *)menuTableView{
    if (_menuTableView == nil) {
        _menuTableView = [[UITableView alloc] init];
        [self addSubview:_menuTableView];
        [_menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.nickLabel.mas_bottom).mas_equalTo(30);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(264);
        }];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.bounces = NO;
        _menuTableView.backgroundColor = [UIColor clearColor];
    }
    return _menuTableView;
}

#pragma mark - UITableView Delegate --------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageNamesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalTableViewCell *cell = [[NormalTableViewCell alloc] init];
    cell.leftImageView.image = [UIImage imageNamed:self.imageNamesArr[indexPath.row]];
    cell.rightLabel.text = self.titlesArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _LeftCallBack(indexPath.row);
}

#pragma mark - UIImagePickerController Delegate--------------------

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
    
    UIViewController *viewController = [self viewController];
    
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imagePath = [info[UIImagePickerControllerReferenceURL] description];

    NSData *imageData = nil;
    if ([imagePath hasSuffix:@"PNG"]) {
        imageData = UIImagePNGRepresentation(image);
    }else{//jpg
        imageData = UIImageJPEGRepresentation(image, .5);
    }
    
    BmobUser *user = [BmobUser currentUser];
    
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
                        self.headImageView.image = [image cutCircleImage];
                    }
                }];
            }
        }];
    }
}

#pragma mark - Method ----------------------------
//只做提示功能
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        [Utils toastview:@"图片保存失败！"];
    }
}

- (void)buttonClickedAction:(UIButton *)button{
    switch (button.tag) {
        case 10:
        {//设置
            _LeftCallBack(button.tag);
        }
            break;
        case 11:
        {//夜间
            if (self.dk_manager.themeVersion == DKThemeVersionNight) {
                [self.nightButton setImage:[UIImage imageNamed:@"night"] forState:UIControlStateNormal];
                [self.nightButton setTitle:@"夜间" forState:UIControlStateNormal];
                self.dk_manager.themeVersion = DKThemeVersionNormal;
                [self.dk_manager dawnComing];
            }else{
                [self.nightButton setImage:[UIImage imageNamed:@"sun"] forState:UIControlStateNormal];
                [self.nightButton setTitle:@"日间" forState:UIControlStateNormal];
                self.dk_manager.themeVersion = DKThemeVersionNight;
                [self.dk_manager nightFalling];
            }
        }
            break;
    }
}

- (void)changeHeadImageAction:(UITapGestureRecognizer *)tap{
    UIViewController *viewController = [self viewController];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"更换头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.allowsEditing = YES;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [viewController presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    [viewController presentViewController:ac animated:YES completion:nil];
}

@end
