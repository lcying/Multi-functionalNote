//
//  SendCommentsView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadView.h"

@interface SendCommentsView : UIView<UITextViewDelegate>

@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) HeadView *headView;
@property (nonatomic) UILabel *placeholderLabel;

@end
