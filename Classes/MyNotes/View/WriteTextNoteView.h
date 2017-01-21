//
//  WriteTextNoteView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "ToolsBottomView.h"
#import "NoteModel.h"

@interface WriteTextNoteView : UIView

@property (nonatomic) HeadView *headView;
@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UITextView *contentTextView;
@property (nonatomic) ToolsBottomView *bottomView;
@property (nonatomic) NoteModel *noteModel;

@end
