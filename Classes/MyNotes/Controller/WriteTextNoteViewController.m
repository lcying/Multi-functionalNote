//
//  WriteTextNoteViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "WriteTextNoteViewController.h"
#import "WriteTextNoteView.h"
#import "FontChangeView.h"

@interface WriteTextNoteViewController ()<UITextViewDelegate>

@property (nonatomic) WriteTextNoteView *writeView;

@property (nonatomic) UIButton *textStyleButton;
@property (nonatomic) FontChangeView *fontChangeView;

@property (nonatomic) FailedView *stateView;

@end

@implementation WriteTextNoteViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.writeView = [[WriteTextNoteView alloc] init];
    [self.view addSubview:self.writeView];
    [self.writeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    self.writeView.contentTextView.delegate = self;
    
    __block __weak WriteTextNoteViewController *weakself = self;
    
    if (self.noteModel) {
        self.writeView.noteModel = self.noteModel;
        self.writeView.headView.titleLabel.text = @"编辑笔记";
        [self.writeView.bottomView setToolsBottomCallBack:^(NSInteger i) {
            switch (i) {
                case 1:
                {//字数统计
                    NSString *message = [NSString stringWithFormat:@"%ld个字",weakself.writeView.contentTextView.attributedText.length];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"字数统计" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [ac addAction:action1];
                    [weakself presentViewController:ac animated:YES completion:nil];
                }
                    break;
                case 11:
                {//分享
                    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite)]];
                    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                        // 根据获取的platformType确定所选平台进行下一步操作
                        
                        [Utils shareTextToPlatformType:platformType andText:weakself.writeView.titleTextField.text];
                    }];
                }
                    break;
            }
        }];
    }
    //上传
    [self.writeView.headView setHeadCallBack:^(id obj) {
        [weakself.view endEditing:YES];
        if ([weakself.writeView.titleTextField.text isEqualToString:@""]) {
            [Utils toastview:@"请输入标题"];
            return;
        }
        
        weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在上传..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];
        
        if (weakself.noteModel) {
            //更新
            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:weakself.noteModel.objectId];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            
            NSAttributedString *attributedString = weakself.writeView.contentTextView.attributedText;
            NSString *htmlString = [Utils getHTMLWithAttributedString:attributedString];
            
            [object setObject:htmlString forKey:@"content"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [weakself.stateView removeFromSuperview];
                if (isSuccessful) {
                    [Utils toastview:@"上传成功！"];
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
            
        }else{
            //上传
            BmobObject *object = [BmobObject objectWithClassName:@"Note"];
            [object setObject:[BmobUser currentUser] forKey:@"User"];
            [object setObject:weakself.writeView.titleTextField.text forKey:@"title"];
            [object setObject:@"NO" forKey:@"isOpen"];
            [object setObject:@"NO" forKey:@"readOpen"];
            
            if (weakself.categoryObject) {
                [object setObject:weakself.categoryObject forKey:@"Category"];
            }
            
            NSAttributedString *attributedString = weakself.writeView.contentTextView.attributedText;
            NSString *htmlString = [Utils getHTMLWithAttributedString:attributedString];
            
            [object setObject:htmlString forKey:@"content"];
            [object setObject:@"0" forKey:@"type"];
            [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [weakself.stateView removeFromSuperview];
                if (isSuccessful) {
                    [Utils toastview:@"上传成功！"];
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }        
    }];
    
    //textStyle
    self.textStyleButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 43, 134, 40, 40)];
    self.textStyleButton.backgroundColor = [UIColor darkGrayColor];
    self.textStyleButton.layer.cornerRadius = 20;
    self.textStyleButton.layer.masksToBounds = YES;
    [self.view addSubview:self.textStyleButton];
    [self.textStyleButton setTitle:@"A" forState:UIControlStateNormal];
    [self.textStyleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.textStyleButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.textStyleButton addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.fontChangeView = [[NSBundle mainBundle] loadNibNamed:@"FontChangeView" owner:self options:nil].firstObject;
    self.fontChangeView.frame = CGRectMake(screenWidth, 134, 160, 320);
    [self.view addSubview:self.fontChangeView];
    self.fontChangeView.backgroundColor = [Utils colorRGB:@"#ededed"];
    
    [self.fontChangeView setFontCallBack:^(id obj) {
        [weakself sureChangedAction];
    }];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFontChangeView)];
    [self.view addGestureRecognizer:rightSwipe];
}

#pragma mark - Method ---------------------------

- (void)sureChangedAction{
    
    NSString *begin = [NSString stringWithFormat:@"%@",self.writeView.contentTextView.selectedTextRange.start];
    begin = [begin componentsSeparatedByString:@"("][1];
    begin = [begin componentsSeparatedByString:@")"][0];
    begin = [begin stringByReplacingOccurrencesOfString:@"B" withString:@""];
    begin = [begin stringByReplacingOccurrencesOfString:@"F" withString:@""];

    NSString *end = [NSString stringWithFormat:@"%@",self.writeView.contentTextView.selectedTextRange.end];
    end = [end componentsSeparatedByString:@"("][1];
    end = [end componentsSeparatedByString:@")"][0];
    end = [end stringByReplacingOccurrencesOfString:@"B" withString:@""];
    end = [end stringByReplacingOccurrencesOfString:@"F" withString:@""];

    NSInteger beginInt = [begin integerValue];
    NSInteger endInt = [end integerValue];

    CGFloat font = [self.fontChangeView.fontTextField.text floatValue];
    
    NSString *text = [self.writeView.contentTextView.text substringWithRange:NSMakeRange(beginInt, endInt - beginInt)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    // 设置字体大小 range是设置范围，下同
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
    // 设置字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:self.fontChangeView.redSlider.value/255.0 green:self.fontChangeView.greenSlider.value/255.0 blue:self.fontChangeView.blueSlider.value/255.0 alpha:1.0] range:NSMakeRange(0, text.length)];
    
    NSMutableAttributedString *originText = [self.writeView.contentTextView.attributedText mutableCopy];
    [originText deleteCharactersInRange:NSMakeRange(beginInt, endInt - beginInt)];
    [originText insertAttributedString:str atIndex:beginInt];
    
    self.writeView.contentTextView.attributedText = originText;
}

- (void)buttonClickedAction:(UIButton *)button{
    //显示fontChangeView
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = CGRectMake(screenWidth - 160, 134, 160, 320);
        self.fontChangeView.frame = frame;
        CGRect frameButton = CGRectMake(screenWidth - 43 - 160, 134, 40, 40);
        self.textStyleButton.frame = frameButton;
    }];
}

- (void)dismissFontChangeView{
    //隐藏fontChangeView
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = CGRectMake(screenWidth, 134, 160, 320);
        self.fontChangeView.frame = frame;
        CGRect frameButton = CGRectMake(screenWidth - 43, 134, 40, 40);
        self.textStyleButton.frame = frameButton;
    }];
}

#pragma mark - UITextView Delegate -------------------------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text != nil && ![text isEqualToString:@""]){
        CGFloat font = [self.fontChangeView.fontTextField.text floatValue];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
        // 设置字体大小 range是设置范围，下同
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, text.length)];
        // 设置字体颜色
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:self.fontChangeView.redSlider.value/255.0 green:self.fontChangeView.greenSlider.value/255.0 blue:self.fontChangeView.blueSlider.value/255.0 alpha:1.0] range:NSMakeRange(0, text.length)];
        
        NSMutableAttributedString *originText = [textView.attributedText mutableCopy];
        
        [originText insertAttributedString:str atIndex:range.location];
        
        textView.attributedText = originText;
    }else{
        if (range.location == 0 && range.length == 0) {
            return NO;
        }
        NSMutableAttributedString *originText = [textView.attributedText mutableCopy];
        [originText deleteCharactersInRange:NSMakeRange(range.location, 1)];
        textView.attributedText = originText;
    }
    
    return NO;
}

@end
