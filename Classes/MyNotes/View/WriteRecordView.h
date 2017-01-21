//
//  WriteRecordView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"
#import "HeadView.h"
#import "NoteModel.h"
#import "ToolsBottomView.h"

@interface WriteRecordView : UIView

@property (nonatomic) UITextField *titleTextField;
@property (nonatomic) UIView *recordView;
@property (nonatomic) HeadView *headView;
@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) NSData *voiceData;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) ToolsBottomView *bottomView;

@end
