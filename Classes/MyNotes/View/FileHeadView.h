//
//  FileHeadView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileHeadView : UIView

@property (nonatomic) void(^FileHeadCallBack) (id obj);

@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UILabel *titleLabel;

@end
