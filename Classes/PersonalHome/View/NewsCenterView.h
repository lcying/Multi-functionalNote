//
//  NewsCenterView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/10.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCenterView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) void(^NewsCallBack) (NSInteger row);
@property (nonatomic) UITableView *newsTableView;

@end
