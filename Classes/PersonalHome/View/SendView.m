//
//  SendView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/22.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "SendView.h"
#import "ChatCell.h"

@implementation SendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.allMessages = [NSMutableArray array];

        [self keyboardView];
        [self pictureButton];
        [self textButton];
        [self voiceButton];
        [self sendButton];
        [self sendTextView];
        [self contentTableView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessageAction:) name:@"接收消息" object:nil];
    }
    return self;
}

#pragma mark - Method ---------------------------

- (void)setToUser:(BmobUser *)toUser{
    _toUser = toUser;
    [self loadAllMessageReceived];
}

- (void)receivedMessageAction:(NSNotification *)noti{
    [self loadAllMessageReceived];
}

#pragma mark - LazyLoading -----------------------------------

- (UIView *)keyboardView{
    if (_keyboardView == nil) {
        _keyboardView = [[UIView alloc] init];
        [self addSubview:_keyboardView];
        [_keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
    }
    return _keyboardView;
}

- (UIButton *)pictureButton{
    if (_pictureButton == nil) {
        _pictureButton = [[UIButton alloc] init];
        [self.keyboardView addSubview:_pictureButton];
        [_pictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(8);
            make.height.width.mas_equalTo(30);
        }];
        [_pictureButton setImage:[UIImage imageNamed:@"sendPic"] forState:UIControlStateNormal];
        
        [_pictureButton addTarget:self action:@selector(chooseImageAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _pictureButton;
}

- (UIButton *)textButton{
    if (_textButton == nil) {
        _textButton = [[UIButton alloc] init];
        [self.keyboardView addSubview:_textButton];
        [_textButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(self.pictureButton.mas_right).mas_equalTo(8);
            make.height.width.mas_equalTo(30);
        }];
        [_textButton setImage:[UIImage imageNamed:@"sendText"] forState:UIControlStateNormal];
        
        [_textButton addTarget:self action:@selector(backTextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textButton;
}

- (UIButton *)voiceButton{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] init];
        [self.keyboardView addSubview:_voiceButton];
        [_voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(self.textButton.mas_right).mas_equalTo(8);
            make.height.width.mas_equalTo(30);
        }];
        [_voiceButton setImage:[UIImage imageNamed:@"sendRecord"] forState:UIControlStateNormal];
        [_voiceButton addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [self.keyboardView addSubview:_sendButton];
        [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(38);
        }];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendTextMessageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

- (UITextView *)sendTextView{
    if (_sendTextView == nil) {
        _sendTextView = [[UITextView alloc] init];
        [self.keyboardView addSubview:_sendTextView];
        [_sendTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.voiceButton.mas_right).mas_equalTo(8);
            make.right.mas_equalTo(self.sendButton.mas_left).mas_equalTo(-8);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        _sendTextView.layer.cornerRadius = 3;
        _sendTextView.layer.masksToBounds = YES;
        _sendTextView.layer.borderColor = [Utils colorRGB:@"#999999"].CGColor;
        _sendTextView.layer.borderWidth = 1.0;
        _sendTextView.font = [UIFont systemFontOfSize:15];
    }
    return _sendTextView;
}

- (UITableView *)contentTableView{
    if (_contentTableView == nil) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_contentTableView];
        [_contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.keyboardView.mas_top).mas_equalTo(0);
        }];
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerNib:[UINib nibWithNibName:@"ChatCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
    }
    return _contentTableView;
}

- (UIView *)recordView{
    if(_recordView == nil) {
        _recordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 216)];
        
        RecordButton *recordBtn = [[RecordButton alloc] initWithFrame:CGRectMake(screenWidth/2 - 50, 50, 100, 100)];
        [_recordView addSubview:recordBtn];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinishAction:) name:@"RecordDidFinishNotification" object:nil];
    }
    return _recordView;
}

#pragma mark - TZImagePickerController Delegate ----------------

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
    //点击选择图片完成后直接发送
    for (UIImage *image in photos) {
        EMMessage *message =  [[EaseMobManager shareManager]sendMessageWithImage:image andUsername:[self.toUser objectForKey:@"mobilePhoneNumber"]];
        [self.allMessages addObject:message];
        [self.contentTableView reloadData];
        [self scrollToTableViewLastTop];
    }
}

#pragma mark - UITableView Delegate -----------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    EMMessage *message = self.allMessages[indexPath.row];
    cell.toUser = self.toUser;
    cell.message = message;
    if (indexPath.row>0) {
        EMMessage *preMessage = self.allMessages[indexPath.row-1];
        
        if ((message.timestamp-preMessage.timestamp)<1000*60) {//一分钟内
            cell.timeLB.hidden = YES;
            
            cell.myContentView.transform = CGAffineTransformMakeTranslation(0, -15);
        }else{
            cell.timeLB.hidden = NO;
            cell.myContentView.transform = CGAffineTransformIdentity;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.allMessages[indexPath.row];
    float h = 0;
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            //计算文本高度
            CGSize textSize = [Utils sizeWithFont:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(250, 0) andStr:txt];
            
            h = 42 + textSize.height;
        }
            break;
        case eMessageBodyType_Image:
        {
            h = 100 + 25;
        }
            break;
        case eMessageBodyType_Voice:
        {
            return 80;
        }
            break;
    }
    //判断是否需要显示时间label
    if (indexPath.row>0) {
        EMMessage *preMessage = self.allMessages[indexPath.row-1];
        if ((message.timestamp-preMessage.timestamp)>1000*60) {//不隐藏时间label
            h+=20;
        }
    }else{
        h += 20;
    }
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EMMessage *message = self.allMessages[indexPath.row];
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch ((int)msgBody.messageBodyType) {
        
        case eMessageBodyType_Image:
        {
            ChatCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [PhotoBroswerVC show:[self viewController] type:PhotoBroswerVCTypeZoom index:0 photoModelBlock:^NSArray *{
                //创建多大容量数组
                NSMutableArray *modelsM = [NSMutableArray array];
                PhotoModel *pbModel=[[PhotoModel alloc] init];
                pbModel.mid = 11;
                //设置查看大图的时候的图片
                pbModel.image = cell.messageImageView.image;
                pbModel.sourceImageView = cell.messageImageView;//点击返回时图片做动画用
                [modelsM addObject:pbModel];
                return modelsM;
            }];
        }
            break;
    }
    
}

#pragma mark - Method -----------------------------------
//请求消息
- (void)loadAllMessageReceived{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:[self.toUser objectForKey:@"mobilePhoneNumber"] conversationType:eConversationTypeChat];
    if ([conversation loadAllMessages] != nil) {
        self.allMessages = [NSMutableArray array];
        self.allMessages = [[conversation loadAllMessages] mutableCopy];
        [self.contentTableView reloadData];
        [self scrollToTableViewLastTop];
    }
}
//滚到最后一行
- (void)scrollToTableViewLastTop{
    if (self.allMessages.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allMessages.count - 1 inSection:0];
        //设置tableView滚动到最后一行
        [self.contentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)backTextAction{
    //返回文本键盘
    self.sendTextView.inputView = nil;
    [self.sendTextView reloadInputViews];
}

- (void)recordAction{
    [self.sendTextView becomeFirstResponder];
    [self recordView];
    self.sendTextView.inputView = self.recordView;
    [self.sendTextView reloadInputViews];
}

- (void)chooseImageAction{
    //点击键盘工具栏上选择图片按钮如果没有选中图片
    TZImagePickerController *pickerCon = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    [[self viewController] presentViewController:pickerCon animated:YES completion:nil];
}

- (void)recordFinishAction:(NSNotification *)sender{
    NSData *recordData = sender.object[@"data"];
    //直接发送语音消息
    EMMessage *message = [[EaseMobManager shareManager] sendMessageWithVoiceData:recordData andTime:[sender.object[@"time"] floatValue] andUsername:[self.toUser objectForKey:@"mobilePhoneNumber"]];
    [self.allMessages addObject:message];
    [self.contentTableView reloadData];
    [self scrollToTableViewLastTop];
    
    //发送完切换回文本键盘
    self.sendTextView.inputView = nil;
    [self.sendTextView reloadInputViews];
}

- (void)sendTextMessageAction{
    if (![self.sendTextView.text isEqualToString:@""]) {
        EMMessage *textMessage = [[EaseMobManager shareManager] sendMessageWithText:[self.sendTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] andUsername:[self.toUser objectForKey:@"mobilePhoneNumber"]];
        [self.allMessages addObject:textMessage];
        [self.contentTableView reloadData];
        [self scrollToTableViewLastTop];
        self.sendTextView.text = @"";
    }
}

@end
