//
//  OnlyFileViewController.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/14.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@interface OnlyFileViewController : UIViewController

@property (nonatomic) FileModel *fileModel;
@property (nonatomic) NoteModel *currentNoteModel;

@end
