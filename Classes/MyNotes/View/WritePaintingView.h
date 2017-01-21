//
//  WritePaintingView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

@interface WritePaintingView : UIView

@property (nonatomic) HeadView *headView;

@property (nonatomic) UIButton *addArcButton;
@property (nonatomic) UIButton *addLineButton;
@property (nonatomic) UIButton *addRectButton;
@property (nonatomic) UIButton *showPaintingBoardButton;

@end
