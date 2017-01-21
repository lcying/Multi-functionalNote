//
//  ToolsBottomView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "MoreView.h"

@interface ToolsBottomView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) void(^ToolsBottomCallBack) (NSInteger i);

@property (nonatomic) NSArray *buttonImageNameArray;
@property (nonatomic) NSArray *buttonTitleArray;
@property (nonatomic) NoteModel *currentNoteModel;
@property (nonatomic) MoreView *moreView;

@property (nonatomic) NSArray *moreArray;
@property (nonatomic) NSMutableArray *allButtonsArray;

@end
