//
//  LookPaintingView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "ToolsBottomView.h"

@interface LookPaintingView : UIView

@property (nonatomic) NoteModel *noteModel;

@property (nonatomic) HeadView *headView;
@property (nonatomic) UIImageView *contentImageView;
@property (nonatomic) ToolsBottomView *bottomView;

@end
