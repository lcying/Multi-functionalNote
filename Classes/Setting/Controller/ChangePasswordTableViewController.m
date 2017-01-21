//
//  ChangePasswordTableViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ChangePasswordTableViewController.h"

@interface ChangePasswordTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ChangePasswordTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.usernameLabel.text = [NSString stringWithFormat:@"用户名：%@",[BmobUser currentUser].username];
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //确定修改
        BmobUser *user = [BmobUser currentUser];
        if ([Utils checkPassword:self.passwordTextField.text]) {
            NSString *newPassword = self.passwordTextField.text;
            NSString *encryptPassword = [Utils md5String:newPassword];
            [user setObject:encryptPassword forKey:@"pass"];
            [user setPassword:encryptPassword];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Utils toastview:@"修改成功！"];
                    [BmobUser loginWithUsernameInBackground:user.username password:[user objectForKey:@"pass"]];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
        }else{
            [Utils toastview:@"请输入6-12位数字字母组合密码"];
        }
    }
}

@end
