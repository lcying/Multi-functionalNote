//
//  FailedView.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "FailedView.h"

@interface FailedView ()

@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *detailStr;
@property (nonatomic) NSString *imageName;
@property (nonatomic) NSString *color;

@end

@implementation FailedView
- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDetail:(NSString *)detail andImageName:(NSString *)imageName andTextColorHex:(NSString *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleStr = title;
        self.detailStr = detail;
        self.imageName = imageName;
        self.color = color;
        
        UIView *v = [[UIView alloc] init];
        [self addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0.4;
        
        [self stateView];
    }
    return self;
}

- (UIView *)stateView{
    _stateView = [[UIView alloc] init];
    [self addSubview:_stateView];
    [_stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(90);
    }];
    _stateView.backgroundColor = [UIColor whiteColor];
    _stateView.layer.cornerRadius = 10;
    _stateView.layer.masksToBounds = YES;
    
    if ([self.detailStr isEqualToString:@""] || self.detailStr == nil) {
        
        CGSize textSize = [Utils sizeWithFont:[UIFont systemFontOfSize:16] andMaxSize:CGSizeMake(0, 18) andStr:self.titleStr];
        
        CGFloat leftDictance = (270.0 - 24.0 - textSize.width)/2.0;
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [_stateView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftDictance);
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(24);
        }];
        imageV.image = [UIImage imageNamed:self.imageName];
        imageV.contentMode = UIViewContentModeScaleToFill;
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = self.titleStr;
        
        [_stateView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageV.mas_right).mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(textSize.width+1);
            make.height.mas_equalTo(18);
        }];
        lb.font = [UIFont systemFontOfSize:16];
        lb.textColor = [Utils colorRGB:self.color];

    }else{
        
        UIImageView *imageV = [[UIImageView alloc] init];
        [_stateView addSubview:imageV];
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(85);
            make.top.mas_equalTo(20);
            make.width.height.mas_equalTo(24);
        }];
        imageV.image = [UIImage imageNamed:self.imageName];
        imageV.contentMode = UIViewContentModeScaleToFill;
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = self.titleStr;
        [_stateView addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageV.mas_right).mas_equalTo(5);
            make.top.mas_equalTo(23);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(18);
        }];
        lb.font = [UIFont systemFontOfSize:16];
        lb.textColor = [Utils colorRGB:self.color];
    
        
        UILabel *lb2 = [[UILabel alloc] init];
        lb2.text = self.detailStr;
        [_stateView addSubview:lb2];
        CGSize detailSize = [Utils sizeWithFont:[UIFont systemFontOfSize:12] andMaxSize:CGSizeMake(0, 14) andStr:self.detailStr];
        if (detailSize.width > 260.0) {
            [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-5);
                make.width.mas_equalTo(260);
                make.height.mas_equalTo(40);
            }];
        }else{
            [lb2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-23);
                make.height.mas_equalTo(14);
            }];
        }
        lb2.font = [UIFont systemFontOfSize:12];
        lb2.textColor = [Utils colorRGB:@"#333333"];
        lb2.numberOfLines = 0;
        lb2.textAlignment = NSTextAlignmentCenter;
    }
    
    return _stateView;
}

@end
