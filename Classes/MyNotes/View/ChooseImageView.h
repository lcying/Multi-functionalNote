//
//  ChooseImageView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseImageView : UIView<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIButton *chooseImageButton;
@property (nonatomic) UIImageView *showImageIV;
@property (nonatomic) UIButton *removeButton;

@end
