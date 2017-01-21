//
//  FileView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileHeadView.h"

@interface FileView : UIView

@property (nonatomic) FileHeadView *headView;
@property (nonatomic) UITableView *fileTableView;

@end
