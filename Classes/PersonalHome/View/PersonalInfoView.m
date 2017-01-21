//
//  PersonalInfoView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "PersonalInfoView.h"
#import "MyAttentionViewController.h"
#import "MyCollectionViewController.h"
#import "MyPersonalNoteViewController.h"

@interface PersonalInfoView ()

@property (nonatomic) NSArray *leftTitlesArray;
@property (nonatomic) NSArray *headViewTitlesArray;

@end

@implementation PersonalInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftTitlesArray = @[@"我的关注",@"关注我的",@"我的收藏",@"个人笔记",@"公开笔记"];
        self.headViewTitlesArray = @[@"我的赞0",@"我收获的赞0",@"我的评论0",@"我收获的评论0"];
        self.headButtonsArray = [NSMutableArray array];
        [self infoTableView];
        [self tableHeadView];
        [self headImageView];
        [self usernameTextField];
        
        
        for (int i = 0; i < 4; i ++) {
            int row = i / 2;
            int column = i % 2;
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(column * screenWidth /2.0, 140 + row * 40, screenWidth/2.0, 40)];
            [_tableHeadView addSubview:button];
            [button setTitle:self.headViewTitlesArray[i] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.headButtonsArray addObject:button];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            button.titleLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],[UIColor lightGrayColor]);
            [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        }
        
    }
    return self;
}

#pragma mark - LazyLoading ----------------------
- (UITableView *)infoTableView{
    if (_infoTableView == nil) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_infoTableView];
        [_infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _infoTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
        [_infoTableView registerNib:[UINib nibWithNibName:@"PersonCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonCell"];
        _infoTableView.tableFooterView = [UIView new];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
    }
    return _infoTableView;
}

- (UIView *)tableHeadView{
    if (_tableHeadView == nil) {
        _tableHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 230)];
        self.infoTableView.tableHeaderView = _tableHeadView;
    }
    return _tableHeadView;
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self.tableHeadView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(60);
            make.top.mas_equalTo(30);
        }];
        _headImageView.layer.cornerRadius = 30;
        _headImageView.layer.masksToBounds = YES;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[[BmobUser currentUser] objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImageAction)];
        [_headImageView addGestureRecognizer:tap];
    }
    return _headImageView;
}

- (UITextField *)usernameTextField{
    if (_usernameTextField == nil) {
        _usernameTextField = [[UITextField alloc] init];
        [self.tableHeadView addSubview:_usernameTextField];
        [_usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.top.mas_equalTo(self.headImageView.mas_bottom).mas_equalTo(10);
        }];
        _usernameTextField.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor lightGrayColor]);
        _usernameTextField.font = [UIFont systemFontOfSize:16];
        _usernameTextField.text = [BmobUser currentUser].username;
        _usernameTextField.textAlignment = NSTextAlignmentCenter;
        self.editUsernameButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [self.editUsernameButton addTarget:self action:@selector(editUsernameAction) forControlEvents:UIControlEventTouchUpInside];
        [self.editUsernameButton setImage:[UIImage imageNamed:@"name"] forState:UIControlStateNormal];
        _usernameTextField.rightView = self.editUsernameButton;
        _usernameTextField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _usernameTextField;
}

#pragma mark - UITableView Delegate ----------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonCell"];
    }
    cell.titleLabel.text = self.leftTitlesArray[indexPath.row];
    cell.rightDetailLabel.text = @"0";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MyAttentionViewController *vc = [[MyAttentionViewController alloc] init];
            vc.currentTitleString = @"我的关注";
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            MyAttentionViewController *vc = [[MyAttentionViewController alloc] init];
            vc.currentTitleString = @"关注我的";
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            MyCollectionViewController *vc = [[MyCollectionViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            MyPersonalNoteViewController *vc = [[MyPersonalNoteViewController alloc] init];
            vc.titleString = @"个人笔记";
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            MyPersonalNoteViewController *vc = [[MyPersonalNoteViewController alloc] init];
            vc.titleString = @"公开笔记";
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

#pragma mark - UIImagePickerController Delegate --------------------

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


#pragma mark - Method ---------------------
- (void)editUsernameAction{
    [self.usernameTextField becomeFirstResponder];
}

//照片保存到系统相册时只做提示功能
- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error) {
        [Utils toastview:@"图片保存失败！"];
    }
}

- (void)chooseImageAction{
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
