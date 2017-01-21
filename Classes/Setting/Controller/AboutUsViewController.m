//
//  AboutUsViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@end

@implementation AboutUsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (IBAction)callPhoneAction:(UIButton *)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"18758105737"];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于随便笔记";
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.aboutLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],[UIColor lightGrayColor]);
}

@end
