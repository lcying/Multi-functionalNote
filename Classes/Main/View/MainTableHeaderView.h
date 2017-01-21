//
//  MainTableHeaderView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableHeaderView : UIView

@property (nonatomic) void(^HomeHeadCallBack) (NSInteger tag);
@property (nonatomic) void(^RefreshCallBack) (id obj);

@property (nonatomic) UIImageView *backImageView;
@property (nonatomic) UIButton *allButton;//全部
@property (nonatomic) UIButton *latestButton;//最新
@property (nonatomic) UIButton *leftButton;
@property (nonatomic) UIButton *rightButton;
@property (nonatomic) UIView *lineView;

@end
