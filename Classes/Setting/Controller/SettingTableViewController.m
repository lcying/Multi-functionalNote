//
//  SettingTableViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SecurityTableViewController.h"
#import "LoginHomeViewController.h"
#import "LoginHomeNaviViewController.h"
#import "AboutUsViewController.h"
#import "SuggestionViewController.h"

@interface SettingTableViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *photoSaveSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoSaveSwitch;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@end

@implementation SettingTableViewController
- (IBAction)autoSaveAction:(UISwitch *)sender {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:sender forKey:@"autoSavePhoto"];
    [ud synchronize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isAuto = [ud boolForKey:@"autoSavePhoto"];
    if (isAuto) {
        [self.autoSaveSwitch setOn:isAuto animated:YES];
    }
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
        self.clearLabel.text = [NSString stringWithFormat:@"%.2fMB",totalSize/1024.0/1024.0];
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UIStoryboard *storyB = [UIStoryboard storyboardWithName:@"setting" bundle:[NSBundle mainBundle]];
        SecurityTableViewController *vc = (SecurityTableViewController *)[storyB instantiateViewControllerWithIdentifier:@"SecurityTableViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //清除缓存
                [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                    //开线程执行
                    NSString *message = [NSString stringWithFormat:@"您确认清除%.2fMB缓存",totalSize/1024.0/1024.0];
                    
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        //清除内存缓存
                        [[SDImageCache sharedImageCache] clearMemory];
                        //清除磁盘缓存
                        [[SDImageCache sharedImageCache] clearDisk];
                        self.clearLabel.text = @"0.00MB";
                        
                    }];
                    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [ac addAction:action1];
                    [ac addAction:action2];
                    [self presentViewController:ac animated:YES completion:nil];
                    
                }];
            
        }
        if (indexPath.row == 2) {
            AboutUsViewController *vc = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {
            SuggestionViewController *vc = [[SuggestionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 2) {
        //退出
        [BmobUser logout];
        [[EaseMobManager shareManager] logout];
        LoginHomeViewController *vc = [[LoginHomeViewController alloc] init];
        [self presentViewController: [[LoginHomeNaviViewController alloc] initWithRootViewController:vc] animated:YES completion:nil];
    }
}

@end
