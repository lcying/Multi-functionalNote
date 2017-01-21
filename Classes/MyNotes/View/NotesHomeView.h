//
//  NotesHomeView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableHeaderView.h"

@interface NotesHomeView : UIView

@property (nonatomic) MainTableHeaderView *headerView;
@property (nonatomic) UITableView *latestNoteTableView;
@property (nonatomic) UITableView *allNoteTableView;
@property (nonatomic) UIScrollView *contentScrollView;

@end
