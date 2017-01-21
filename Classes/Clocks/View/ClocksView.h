//
//  ClocksView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockModel.h"

@interface ClocksView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *clockTableView;
@property (nonatomic) NSMutableArray<ClockModel *> *allClocksArray;

@end
