//
//  PaintingNoteView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/9.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadHeadView.h"
#import "ReadBottomView.h"

@interface PaintingNoteView : UIView

@property (nonatomic) ReadBottomView *readBottomView;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) UITableView *commentsTableView;

@property (nonatomic) UIView *tableHeadView;//底下的控件加到tableHeadView中
@property (nonatomic) ReadHeadView *readHeadView;
@property (nonatomic) UIImageView *contentImageView;
@property (nonatomic) UILabel *updatedLabel;
@property (nonatomic) UILabel *commentCountLabel;

@end
