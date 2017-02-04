//
//  SendView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/22.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordButton.h"

@interface SendView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TZImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic) BmobUser *toUser;

@property (nonatomic) UIView *keyboardView;
@property (nonatomic) UIButton *voiceButton;//语音键盘
@property (nonatomic) UIButton *pictureButton;//选择图片键盘
@property (nonatomic) UIButton *textButton;//文本键盘
@property (nonatomic) UITextView *sendTextView;//文本框
@property (nonatomic) UIButton *sendButton;//发送

@property (nonatomic) UITableView *contentTableView;//内容

@property (nonatomic) UIView *recordView;

@property (nonatomic) NSMutableArray<EMMessage *> *allMessages;

@end
