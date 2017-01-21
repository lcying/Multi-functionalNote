//
//  OtherNotesView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherNotesView : UIView <SDCycleScrollViewDelegate>

@property (nonatomic) SDCycleScrollView *imageScrollView;//轮播图
@property (nonatomic) UITableView *noteTableView;

@end
