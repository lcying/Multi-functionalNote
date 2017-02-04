//
//  NewsCenterViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/10.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "NewsCenterViewController.h"
#import "NewsCenterView.h"
#import "LeftImageRightTitleCell.h"
#import "AttentMeViewController.h"
#import "ZanMeViewController.h"
#import "CommentMeViewController.h"
#import "MessageListViewController.h"
#import "SBNewsViewController.h"

@interface NewsCenterViewController () <BmobEventDelegate>

@property (nonatomic) NewsCenterView *centerView;
@property (nonatomic) BmobEvent *bmobEvent;

@end

@implementation NewsCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.centerView = [[NewsCenterView alloc] init];
    [self.view addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    __block __weak NewsCenterViewController *weakself = self;

    [self.centerView setNewsCallBack:^(NSInteger row) {
        
        
        switch (row) {
            case 0:
            {//私信
                MessageListViewController *vc = [[MessageListViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1:
            {//关注
                AttentMeViewController *vc = [[AttentMeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {//赞
                ZanMeViewController *vc = [[ZanMeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {//评论
                CommentMeViewController *vc = [[CommentMeViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 4:
            {//随便笔记
                SBNewsViewController *vc = [[SBNewsViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [weakself.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
        
    }];
    
    //监听表数据的改变
    //关注表
    self.bmobEvent = [BmobEvent defaultBmobEvent];
    self.bmobEvent.delegate = self;
    [self.bmobEvent start];
    
}

- (void)resetAction{
    [self.bmobEvent stop];
    [self.bmobEvent start];
}

#pragma mark - BmobEvent Delegate ---------------------------

///**
// *  连接上服务器
// *
// *  @param event BmobEvent对象
// */
//-(void)bmobEventDidConnect:(BmobEvent *)event{
////    [self.bmobEvent listenTableChange:BmobActionTypeUpdateTable tableName:@"Comment"];
//}
//
///**
// *  连接不了服务器
// *
// *  @param event BmobEvent对象
// *  @param error 错误信息
// */
//-(void)bmobEventDidDisConnect:(BmobEvent *)event error:(NSError *)error{
//    [self performSelector:@selector(resetAction) withObject:nil afterDelay:0.7f];
//}
//
///**
// *  可以订阅或者取消订阅
// *
// *  @param event BmobEvent对象
// */
//-(void)bmobEventCanStartListen:(BmobEvent*)event{
//    
//}
//
///**
// *  BmobEvent发生错误时
// *
// *  @param event BmobEvent对象
// *  @param error 错误信息
// */
//-(void)bmobEvent:(BmobEvent*)event error:(NSError *)error{
//    [Utils toastViewWithError:error];
//}
//
///**
// *  订阅事件时，接收信息
// *
// *  @param event   BmobEvent对象
// *  @param message 消息内容
// */
//-(void)bmobEvent:(BmobEvent *)event didReceiveMessage:(NSString *)message{
//    NSDictionary *messageDic = [Utils parseJSONStringToNSDictionary:message];
//    
//}

@end
