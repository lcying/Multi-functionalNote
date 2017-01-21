//
//  ClocksViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/22.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ClocksViewController.h"
#import "AddClockViewController.h"
#import "ClockModel.h"
#import "ClocksView.h"

@interface ClocksViewController ()

@property (nonatomic) ClocksView *clocksView;

@end

@implementation ClocksViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //得到database中的闹钟显示出来
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyDatabase.db"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        self.clocksView.allClocksArray = [NSMutableArray array];
        FMResultSet *result = [database executeQuery:@"select * from Clocks"];
        while ([result next]) {
            NSString *content = [result stringForColumn:@"content"];
            NSLog(@"content = %@",content);
            NSString *time = [result stringForColumn:@"time"];
            int repeat = [result intForColumn:@"repeat"];
            ClockModel *model = [[ClockModel alloc] init];
            model.content = content;
            model.time = time;
            model.repeat = repeat;
            [self.clocksView.allClocksArray addObject:model];
        }
        [self.clocksView.clockTableView reloadData];
    }    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事件提醒";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addClock"] style:UIBarButtonItemStyleDone target:self action:@selector(addClockAction)];
    
    self.clocksView = [[ClocksView alloc] init];
    [self.view addSubview:self.clocksView];
    [self.clocksView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)addClockAction{
    AddClockViewController *vc = [[AddClockViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
