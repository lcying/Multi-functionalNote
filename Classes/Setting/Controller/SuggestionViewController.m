//
//  SuggestionViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SuggestionViewController.h"
#import "SuggestionView.h"

@interface SuggestionViewController ()

@property (nonatomic) SuggestionView *suggestView;
@property (nonatomic) FailedView *stateView;

@end

@implementation SuggestionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.suggestView = [[SuggestionView alloc] init];
    [self.view addSubview:self.suggestView];
    [self.suggestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak SuggestionViewController *weakself = self;

    [self.suggestView setSubmitCallBack:^(id obj) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在提交..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
            [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];
        });
        
        BmobObject *object = [BmobObject objectWithClassName:@"Suggestion"];
        [object setObject:weakself.suggestView.contentView.text forKey:@"suggestion"];
        [object setObject:[BmobUser currentUser] forKey:@"User"];
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [weakself.stateView removeFromSuperview];
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                [weakself.navigationController popViewControllerAnimated:YES];
                [Utils toastview:@"我们已收到您的意见，会尽快处理！"];
            }
        }];
    }];
}

@end
