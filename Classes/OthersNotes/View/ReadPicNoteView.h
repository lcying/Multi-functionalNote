//
//  ReadPicNoteView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadBottomView.h"
#import "ReadHeadView.h"
#import "CommentCell.h"
#import "ImagePathsView.h"

@interface ReadPicNoteView : UIView

@property (nonatomic) ReadBottomView *readBottomView;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) UITableView *commentsTableView;

@property (nonatomic) UIView *tableHeadView;//底下的控件加到tableHeadView中
@property (nonatomic) ReadHeadView *readHeadView;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UILabel *updatedLabel;//更新时间
@property (nonatomic) UILabel *commentCountLabel;//共0条
@property (nonatomic) ImagePathsView *imagePathsView;

@end
