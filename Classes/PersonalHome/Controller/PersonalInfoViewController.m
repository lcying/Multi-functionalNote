//
//  PersonalInfoViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoView.h"
#import "PersonCell.h"
#import "MyCollectionViewController.h"

#import "PersonalCenterViewController.h"

@interface PersonalInfoViewController ()

@property (nonatomic) PersonalInfoView *infoView;
@property (nonatomic) int allGetZans;
@property (nonatomic) int allGetComments;

@end

@implementation PersonalInfoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    self.allGetZans = 0;
    self.allGetComments = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    self.infoView = [[PersonalInfoView alloc] init];
    [self.view addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    [self findAllZans];
    [self findAllComments];
    [self findAllGetZans];
    [self findAllCollections];
    [self findAllSecretNotes];
    [self findAllOpenNotes];
    [self findAllAttentions];
    [self findAllMyAttentions];
}

#pragma mark - Method -------------------------------
//保存用户名
- (void)saveAction{
    
    PersonalCenterViewController *vc = [[PersonalCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    BmobUser *user = [BmobUser currentUser];
//    [user setObject:self.infoView.usernameTextField.text forKey:@"username"];
//    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (error) {
//            [Utils toastViewWithError:error];
//        }else{
//            [Utils toastview:@"保存成功!"];
//        }
//    }];
}
//我的赞
- (void)findAllZans{
    BmobQuery *zanQuery = [BmobQuery queryWithClassName:@"Zan"];
    [zanQuery whereKey:@"User" equalTo:[BmobUser currentUser]];
    [zanQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        UIButton *button = self.infoView.headButtonsArray[0];
        [button setTitle:[NSString stringWithFormat:@"我的赞%d",number] forState:UIControlStateNormal];
    }];
}
//我的评论
- (void)findAllComments{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Comment"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        UIButton *button = self.infoView.headButtonsArray[2];
        [button setTitle:[NSString stringWithFormat:@"我的评论%d",number] forState:UIControlStateNormal];
    }];
}
//我收获的赞  评论
- (void)findAllGetZans{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            for (BmobObject *obj in array) {
                int z = [[obj objectForKey:@"zanCount"] intValue];
                self.allGetZans = self.allGetZans + z;
                int c = [[obj objectForKey:@"commentCount"] intValue];
                self.allGetComments = self.allGetComments + c;
            }
            UIButton *button = self.infoView.headButtonsArray[1];
            [button setTitle:[NSString stringWithFormat:@"我收获的赞%d",self.allGetZans] forState:UIControlStateNormal];
            UIButton *buttonC = self.infoView.headButtonsArray[3];
            [buttonC setTitle:[NSString stringWithFormat:@"我收获的评论%d",self.allGetComments] forState:UIControlStateNormal];
        }
    }];
}
//我的收藏
- (void)findAllCollections{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Collection"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        PersonCell *cell = [self.infoView.infoTableView cellForRowAtIndexPath:indexPath];
        cell.rightDetailLabel.text = [NSString stringWithFormat:@"%d",number];
    }];
}
//私密笔记
- (void)findAllSecretNotes{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"isOpen" equalTo:@"NO"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        PersonCell *cell = [self.infoView.infoTableView cellForRowAtIndexPath:indexPath];
        cell.rightDetailLabel.text = [NSString stringWithFormat:@"%d",number];
    }];
}
//公开笔记
- (void)findAllOpenNotes{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"isOpen" equalTo:@"YES"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        PersonCell *cell = [self.infoView.infoTableView cellForRowAtIndexPath:indexPath];
        cell.rightDetailLabel.text = [NSString stringWithFormat:@"%d",number];
    }];
}
//我的关注
- (void)findAllAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        PersonCell *cell = [self.infoView.infoTableView cellForRowAtIndexPath:indexPath];
        cell.rightDetailLabel.text = [NSString stringWithFormat:@"%d",number];
    }];
}
//关注我的
- (void)findAllMyAttentions{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
    [query whereKey:@"ToUser" equalTo:[BmobUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        PersonCell *cell = [self.infoView.infoTableView cellForRowAtIndexPath:indexPath];
        cell.rightDetailLabel.text = [NSString stringWithFormat:@"%d",number];
    }];
}

@end
