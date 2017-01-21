//
//  TextNoteView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadBottomView.h"
#import "ReadHeadView.h"
#import "CommentCell.h"

@interface ReadTextNoteView : UIView

@property (nonatomic) ReadBottomView *readBottomView;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) UITableView *commentsTableView;

@property (nonatomic) UIView *tableHeadView;//底下的控件加到tableHeadView中
@property (nonatomic) ReadHeadView *readHeadView;
@property (nonatomic) UILabel *contentLabel;
@property (nonatomic) UILabel *updatedLabel;
@property (nonatomic) UILabel *commentCountLabel;

@end
