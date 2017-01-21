//
//  FailedView.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/18.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FailedView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andDetail:(NSString *)detail andImageName:(NSString *)imageName andTextColorHex:(NSString *)color;
@property (nonatomic) UIView *stateView;

@end
