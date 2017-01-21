//
//  ChangePhoneTableViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ChangePhoneTableViewController.h"

@interface ChangePhoneTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *oldPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *captchaTF;
@property (weak, nonatomic) IBOutlet UIButton *captchaButton;

@end

@implementation ChangePhoneTableViewController

- (IBAction)getCaptchaAction:(UIButton *)sender {
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.oldPhoneNumber.text = [NSString stringWithFormat:@"当前用户手机号：%@",[[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]];
    
    self.title = @"修改手机号";
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.captchaButton.layer.cornerRadius = 5;
    self.captchaButton.layer.masksToBounds = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //确定修改
        
    }
}

@end
