//
//  CommentView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"
#import "CommentModel.h"

@interface CommentView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *allCommentsArray;
@property (nonatomic) UITableView *commentTableView;
@property (nonatomic) HeadView *headView;
@property (nonatomic) BmobObject *commentObject;
@property (nonatomic) BmobUser *user;
@property (nonatomic) UILabel *countLabel;

@end
