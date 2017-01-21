//
//  UserSatisfactionViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "UserSatisfactionViewController.h"
#import "UserSatisfactionView.h"

@interface UserSatisfactionViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UserSatisfactionView *userView;
@property (nonatomic) NSArray *titleArray;
@property (nonatomic) NSInteger currentLevel;

@end

@implementation UserSatisfactionViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"满意度调查";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    
    self.titleArray = @[@"非常好",@"很好",@"还好",@"一般",@"还行",@"不好",@"任性，就是不喜欢"];
    
    self.userView = [[UserSatisfactionView alloc] init];
    [self.view addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    self.userView.userTableView.delegate = self;
    self.userView.userTableView.dataSource = self;
    
    self.userView.userTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#ECECF2"],[UIColor darkGrayColor],[UIColor lightGrayColor]);

}

#pragma mark - Method -----------------------------------------

- (void)saveAction{
    BmobObject *object = [BmobObject objectWithClassName:@"Satisfaction"];
    [object setObject:[BmobUser currentUser] forKey:@"User"];
    [object setObject:[NSString stringWithFormat:@"%ld",self.currentLevel] forKey:@"level"];
    [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [Utils toastview:@"评价成功！"];
        }else{
            [Utils toastViewWithError:error];
        }
    }];
}

#pragma mark - UITableView Delegate ---------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    cell.textLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor lightGrayColor]);
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.currentLevel = indexPath.row;
}

@end
