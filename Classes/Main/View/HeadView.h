//
//  HeadView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

@property (nonatomic) void(^HeadCallBack) (id obj);

@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UILabel *titleLabel;

@end
