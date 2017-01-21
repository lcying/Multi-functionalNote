//
//  OnlyFileView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/14.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeadView.h"

@interface OnlyFileView : UIView

@property (nonatomic) FileHeadView *headView;
@property (nonatomic) UITableView *fileTableView;
@property (nonatomic) UIButton *changeButton;

@end
