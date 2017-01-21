//
//  SendCommentsViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SendCommentsViewController.h"
#import "SendCommentsView.h"

@interface SendCommentsViewController ()

@property (nonatomic) SendCommentsView *sendCommentsView;
@property (nonatomic) FailedView *stateView;

@end

@implementation SendCommentsViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendCommentsView = [[SendCommentsView alloc] init];
    [self.view addSubview:self.sendCommentsView];
    [self.sendCommentsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    __block __weak SendCommentsViewController *weakself = self;

    [self.sendCommentsView.headView setHeadCallBack:^(id obj) {
        
        weakself.stateView = [[FailedView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andTitle:@"正在上传..." andDetail:nil andImageName:@"icon_smile" andTextColorHex:@"#eb000c"];
        [[UIApplication sharedApplication].keyWindow addSubview:weakself.stateView];

        //发布评论
        BmobObject *object = [BmobObject objectWithClassName:@"Comment"];
        [object setObject:[BmobUser currentUser] forKey:@"User"];
        [object setObject:weakself.user forKey:@"ToUser"];
        [object setObject:weakself.commentObject forKey:@"Note"];
        [object setObject:weakself.sendCommentsView.commentTextView.text forKey:@"comment"];
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [weakself.stateView removeFromSuperview];
            if (isSuccessful) {
                
                BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:weakself.commentObject.objectId];
                
                [currentNote incrementKey:@"commentCount" byNumber:@1];
                
                [currentNote updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        
                    }
                }];
                
                [Utils toastview:@"上传成功"];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            }else{
                [Utils toastViewWithError:error];
            }
        }];
    }];
}

@end
