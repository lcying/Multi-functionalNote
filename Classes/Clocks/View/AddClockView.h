//
//  AddClockView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClockView : UIView <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic) void(^AddCallBack) (NSInteger row);

@property (nonatomic) UITextView *contentTextView;
@property (nonatomic) UITableView *timeTableView;
@property (nonatomic) UILabel *placeholderLabel;

@end
