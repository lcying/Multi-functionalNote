//
//  ImagePathsView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ImagePathsView.h"
#define imageWidth (screenWidth - 4*8)/3

@implementation ImagePathsView

-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIImageView *iv = (UIImageView *)tap.view;
    
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:iv.tag photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.imagePaths.count];
        
        for (NSUInteger i = 0; i< self.imagePaths.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            NSString *path = self.imagePaths[i];
            
            pbModel.image_HD_U = path;
            
            UIImageView *imageV =(UIImageView *) self.subviews[i];
            pbModel.sourceImageView = imageV;//点击返回时图片做动画用
            [modelsM addObject:pbModel];
        }
        return modelsM;
    }];
}

- (void)setImagePaths:(NSArray *)imagePaths{
    _imagePaths = imagePaths;
    
    self.backgroundColor = [UIColor clearColor];
    if (imagePaths.count == 1) {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 16, screenWidth - 16)];
        [iv sd_setImageWithURL:[NSURL URLWithString:imagePaths[0]] placeholderImage:[UIImage imageNamed:@"404"]];
        iv.userInteractionEnabled = YES;
        iv.tag = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];;
        [iv addGestureRecognizer:tap];
        
        [self addSubview:iv];
    }else{
        for (int i = 0; i < imagePaths.count; i ++) {
            
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((i%3) * (imageWidth+8), (imageWidth+8) * (i / 3), imageWidth, imageWidth)];
            [iv sd_setImageWithURL:[NSURL URLWithString:imagePaths[i]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
            iv.userInteractionEnabled = YES;
            iv.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            [iv addGestureRecognizer:tap];
            
            [self addSubview:iv];
        }
    }
    
}

@end
