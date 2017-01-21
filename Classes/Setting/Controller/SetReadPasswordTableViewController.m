//
//  SetReadPasswordTableViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SetReadPasswordTableViewController.h"

@interface SetReadPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *readPassOne;
@property (weak, nonatomic) IBOutlet UITextField *readPassTwo;

@end

@implementation SetReadPasswordTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置阅读密码";
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //确定
        BmobUser *user = [BmobUser currentUser];
        if ([Utils checkReadPassword:self.readPassOne.text] && [self.readPassOne.text isEqualToString:self.readPassTwo.text]) {
            [user setObject:self.readPassOne.text forKey:@"readPassword"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Utils toastview:@"创建成功！"];
                    [BmobUser loginWithUsernameInBackground:user.username password:[user objectForKey:@"pass"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }else{
            if (![Utils checkReadPassword:self.readPassOne.text]) {
                [Utils toastview:@"请输入6位数字密码"];
            }else if(![self.readPassOne.text isEqualToString:self.readPassTwo.text]){
                [Utils toastview:@"两次密码输入不一致"];
            }
        }
    }
}

@end
