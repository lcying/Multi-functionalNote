//
//  NaviHeadView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviHeadView : UIView

@property (nonatomic) void(^NaviHeadCallBack) (NSInteger tag);

@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UILabel *titleLabel;

@end
