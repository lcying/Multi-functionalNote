//
//  SuggestionView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionView : UIView

@property (nonatomic) void(^SubmitCallBack) (id obj);
@property (nonatomic) UITextView *contentView;
@property (nonatomic) UIButton *submitButton;

@end
