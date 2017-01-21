//
//  ReadBottomView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadBottomView : UIView

@property (nonatomic) void(^ReadBottomCallBack) (id obj);

@property (nonatomic) NoteModel *noteModel;

@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSArray *imageNameArray;
@property (nonatomic) NSMutableArray *allButtonsArray;

@end
