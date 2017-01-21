//
//  ToolsView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/21.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "NotesView.h"

@implementation NotesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSArray *imageNamesArr = @[@"pen",@"image",@"record",@"painting"];
        NSArray *titlesArr = @[@"文字笔记",@"图文笔记",@"录音笔记",@"随手一画"];
        CGFloat width = screenWidth/4.0 - 30;
        for (int i = 0; i < imageNamesArr.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15 + (width + 30) * i, 4, width, width)];
            [button setImage:[UIImage imageNamed:imageNamesArr[i]] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [self addSubview:button];
            button.tag = 10 + i;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/4.0*i, width + 9, screenWidth/4.0, 15)];
            lb.text = titlesArr[i];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.textColor = [UIColor darkGrayColor];
            [self addSubview:lb];
            lb.font = [UIFont systemFontOfSize:13];
        }
        
    }
    return self;
}

- (void)buttonClickedAction:(UIButton *)button{
    _NotesCallBack(button.tag);
}

@end
