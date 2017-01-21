//
//  SecurityTableViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "SecurityTableViewController.h"
#import "ChangePasswordTableViewController.h"
#import "SetReadPasswordTableViewController.h"
#import "ChangePhoneTableViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SecurityTableViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *fingerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *readPassSwitch;

@end

@implementation SecurityTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隐私与安全";
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL fingerPrintIsOn = [ud boolForKey:@"fingerPrint"];
    if (fingerPrintIsOn) {
        [self.fingerSwitch setOn:fingerPrintIsOn animated:YES];
    }else{
        [self.fingerSwitch setOn:NO animated:YES];
    }
    
    BOOL openReadPassword = [ud boolForKey:@"openReadPassword"];
    if (openReadPassword) {
        [self.readPassSwitch setOn:YES animated:YES];
    }else{
        [self.readPassSwitch setOn:NO animated:YES];
    }
}

#pragma mark - Method ------------------------------------------------
- (IBAction)openFingerAction:(UISwitch *)sender {
    if (sender.isOn == YES) {
        //打开
        
        //系统支持，最低iOS 8.0
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
            LAContext * context = [[LAContext alloc] init];
            NSError * error;
            
            //如果支持指纹解锁
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]){
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"指纹解锁将会在打开时使用" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self saveIn:YES withKey:@"fingerPrint"];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self saveIn:NO withKey:@"fingerPrint"];
                }];
                [ac addAction:action1];
                [ac addAction:action2];
                [self presentViewController:ac animated:YES completion:nil];
            }else{
                [self saveIn:NO withKey:@"fingerPrint"];
                [Utils toastview:@"请在设置－Touch ID与密码中录入指纹"];
            }
        }else{
            [self saveIn:NO withKey:@"fingerPrint"];
            [Utils toastview:@"系统版本不得低于iOS8.0"];
        }
        
    }else{
        //修改密码
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"验证原密码" message:@"为了保障你的账号安全，关闭指纹解锁前请填写原密码。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //验证原密码
            
            //原密码
            NSString *password = ac.textFields.firstObject.text;
            //加密后的密码
            NSString *encryptPassword = [Utils md5String:password];
            
            BmobQuery *query = [BmobUser query];
            [query whereKey:@"mobilePhoneNumber" equalTo:[[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    BmobObject *object = array.firstObject;
                    NSString *passwordGet = [NSString stringWithFormat:@"%@",[object objectForKey:@"pass"]];
                    if ([passwordGet isEqualToString:encryptPassword]) {
                        [self saveIn:NO withKey:@"fingerPrint"];
                    }else{
                        [Utils toastview:@"密码错误"];
                        [self saveIn:YES withKey:@"fingerPrint"];
                    }
                }
            }];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.secureTextEntry = YES;
            textField.placeholder = @"请输入原密码";
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (IBAction)openReadPassAction:(UISwitch *)sender {
    if (sender.isOn == NO) {
        //将要关闭
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *readPass = ac.textFields.firstObject.text;
            if ([readPass isEqualToString:[[BmobUser currentUser] objectForKey:@"readPassword"]]) {
                [self saveIn:NO withKey:@"openReadPassword"];
            }else{
                [Utils toastview:@"密码错误"];
                [self saveIn:YES withKey:@"openReadPassword"];
            }
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入阅读密码";
        }];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        //将要打开
        UIAlertController *ac1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"阅读密码将会在阅读时候要求输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action11 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveIn:YES withKey:@"openReadPassword"];
        }];
        UIAlertAction *action21 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self saveIn:NO  withKey:@"openReadPassword"];
        }];
        [ac1 addAction:action11];
        [ac1 addAction:action21];
        [self presentViewController:ac1 animated:YES completion:nil];
    }
}

- (void)saveIn:(BOOL)isOn withKey:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:isOn forKey:key];
    [ud synchronize];
    if ([key isEqualToString:@"fingerPrint"]) {
        [self.fingerSwitch setOn:isOn animated:YES];
    }else{
        [self.readPassSwitch setOn:isOn animated:YES];
    }
}

#pragma mark - UITableView Delegate ------------------------------------

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"setting" bundle:[NSBundle mainBundle]];

        if (indexPath.row == 0) {
            //修改密码
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"验证原密码" message:@"为了保障你的账号安全，修改密码前请填写原密码。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //验证原密码
                
                //原密码
                NSString *password = ac.textFields.firstObject.text;
                //加密后的密码
                NSString *encryptPassword = [Utils md5String:password];
                
                BmobQuery *query = [BmobUser query];
                [query whereKey:@"mobilePhoneNumber" equalTo:[[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        BmobObject *object = array.firstObject;
                        NSString *passwordGet = [NSString stringWithFormat:@"%@",[object objectForKey:@"pass"]];
                        if ([passwordGet isEqualToString:encryptPassword]) {
                            ChangePasswordTableViewController *vc = (ChangePasswordTableViewController *)[sb instantiateViewControllerWithIdentifier:@"ChangePasswordTableViewController"];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            [Utils toastview:@"密码错误"];
                        }
                    }
                }];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.secureTextEntry = YES;
                textField.placeholder = @"请输入原密码";
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        if (indexPath.row == 2) {
            //设置阅读密码
            if ([[BmobUser currentUser] objectForKey:@"readPassword"] == nil || [[[BmobUser currentUser] objectForKey:@"readPassword"] isEqualToString:@""]) {
                SetReadPasswordTableViewController *vc = (SetReadPasswordTableViewController *)[sb instantiateViewControllerWithIdentifier:@"SetReadPasswordTableViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *readPass = ac.textFields.firstObject.text;
                    if ([readPass isEqualToString:[[BmobUser currentUser] objectForKey:@"readPassword"]]) {
                        SetReadPasswordTableViewController *vc = (SetReadPasswordTableViewController *)[sb instantiateViewControllerWithIdentifier:@"SetReadPasswordTableViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        [Utils toastview:@"密码错误"];
                    }
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [ac addAction:action1];
                [ac addAction:action2];
                [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                   textField.placeholder = @"请输入之前的阅读密码";
                }];
                [self presentViewController:ac animated:YES completion:nil];
            }
        }
        if (indexPath.row == 3) {
            
            
            
            //修改密码
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"验证原密码" message:@"为了保障你的账号安全，修改手机号前请填写原密码。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //验证原密码
                
                //原密码
                NSString *password = ac.textFields.firstObject.text;
                //加密后的密码
                NSString *encryptPassword = [Utils md5String:password];
                
                BmobQuery *query = [BmobUser query];
                [query whereKey:@"mobilePhoneNumber" equalTo:[[BmobUser currentUser] objectForKey:@"mobilePhoneNumber"]];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        BmobObject *object = array.firstObject;
                        NSString *passwordGet = [NSString stringWithFormat:@"%@",[object objectForKey:@"pass"]];
                        if ([passwordGet isEqualToString:encryptPassword]) {
                            ChangePhoneTableViewController *vc = (ChangePhoneTableViewController *)[sb instantiateViewControllerWithIdentifier:@"ChangePhoneTableViewController"];
                            [self.navigationController pushViewController:vc animated:YES];
                        }else{
                            [Utils toastview:@"密码错误"];
                        }
                    }
                }];
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.secureTextEntry = YES;
                textField.placeholder = @"请输入原密码";
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [self presentViewController:ac animated:YES completion:nil];
            
        }
    }
}

@end
