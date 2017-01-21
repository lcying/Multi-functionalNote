//
//  ChooseImageView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ChooseImageView.h"

@implementation ChooseImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addContent];
    }
    return self;
}

- (void)addContent{
    //选择图片按钮
    UIButton *imageButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 8, 84, 109)];
    [self addSubview:imageButton];
    imageButton.layer.cornerRadius = 3;
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.borderColor = [Utils colorRGB:@"#cccccc"].CGColor;
    imageButton.layer.borderWidth = 1;
    [imageButton setTitle:@"+" forState:UIControlStateNormal];
    [imageButton setTitleColor:[Utils colorRGB:@"#cccccc"] forState:UIControlStateNormal];
    imageButton.titleLabel.font = [UIFont systemFontOfSize:60];
    [imageButton addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseImageButton = imageButton;
    
    //显示图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 84, 109)];
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self addSubview:imageView];
    imageView.hidden = YES;
    imageView.userInteractionEnabled = YES;
    self.showImageIV = imageView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
    
    //删除图片
    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(84, 0, 16, 16)];
    removeButton.backgroundColor = [UIColor redColor];
    removeButton.layer.cornerRadius = 8;
    removeButton.layer.masksToBounds = YES;
    [removeButton setTitle:@"X" forState:UIControlStateNormal];
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    removeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    removeButton.hidden = YES;
    [removeButton addTarget:self action:@selector(removeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:removeButton];
    self.removeButton = removeButton;
}

#pragma mark - UIImagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.showImageIV.image = image;
    self.showImageIV.hidden = NO;
    self.removeButton.hidden = NO;
    self.chooseImageButton.userInteractionEnabled = NO;
    UIViewController *viewController = [self viewController];
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseImageAction" object:nil userInfo:nil];
    
}

#pragma mark - Method
- (void)chooseImageAction:(UIButton *)button{
        
    __block __weak ChooseImageView *weakself = self;
    UIViewController *viewController = [self viewController];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = weakself;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [viewController presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = weakself;
        
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

- (void)removeAction:(UIButton *)button{
    self.showImageIV.hidden = YES;
    button.hidden = YES;
    self.chooseImageButton.userInteractionEnabled = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveImageAction" object:self userInfo:nil];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    UIImageView *imageV = (UIImageView *)tap.view;
    [PhotoBroswerVC show:[self viewController] type:PhotoBroswerVCTypeZoom index:0 photoModelBlock:^NSArray *{
        //创建多大容量数组
        NSMutableArray *modelsM = [NSMutableArray array];
        PhotoModel *pbModel=[[PhotoModel alloc] init];
        pbModel.mid = 11;
        //设置查看大图的时候的图片
        pbModel.image = imageV.image;
        pbModel.sourceImageView = imageV;//点击返回时图片做动画用
        [modelsM addObject:pbModel];
        return modelsM;
    }];
}

@end
