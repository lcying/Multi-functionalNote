//
//  RecordView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/10.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadBottomView.h"
#import "ReadHeadView.h"

@interface RecordView : UIView

@property (nonatomic) ReadBottomView *readBottomView;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) UITableView *commentsTableView;

@property (nonatomic) UIView *tableHeadView;//底下的控件加到tableHeadView中
@property (nonatomic) ReadHeadView *readHeadView;
@property (nonatomic) UIButton *contentButton;
@property (nonatomic) UILabel *updatedLabel;
@property (nonatomic) UILabel *commentCountLabel;

@end
