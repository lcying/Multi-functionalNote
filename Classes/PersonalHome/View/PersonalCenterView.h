//
//  PersonalCenterView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/6.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalCenterView : UIView <UITableViewDelegate , UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic) UIView *headView;
@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *usernameLabel;
@property (nonatomic) UILabel *wordLabel;
@property (nonatomic) UIImageView *rightImageView;

@property (nonatomic) NSMutableArray<UIButton *> *titleButtonsArray;
@property (nonatomic) UIView *lineView;

@property (nonatomic) UIScrollView *contentScrollView;
@property (nonatomic) NSMutableArray<UITableView *> *contentTableViewsArray;

//数据数组
@property (nonatomic) NSMutableArray *openNotesArray;
@property (nonatomic) NSMutableArray *secretNoteArray;
@property (nonatomic) NSMutableArray *myAttentionsArray;
@property (nonatomic) NSMutableArray *myCollectionsArray;
@property (nonatomic) NSMutableArray *myCollectionsIDsArray;//保存收藏id数组
@property (nonatomic) NSMutableArray *myCommentsArray;

@end
