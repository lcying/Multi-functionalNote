//
//  ClocksView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ClocksView.h"
#import "ClockCell.h"
#import "AppDelegate.h"

@implementation ClocksView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.allClocksArray = [NSMutableArray array];
        [self clockTableView];
    }
    return self;
}

- (UITableView *)clockTableView{
    if (_clockTableView == nil) {
        _clockTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_clockTableView];
        [_clockTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _clockTableView.delegate = self;
        _clockTableView.dataSource = self;
        [_clockTableView registerNib:[UINib nibWithNibName:@"ClockCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ClockCell"];
        _clockTableView.tableFooterView = [UIView new];
    }
    return _clockTableView;
}

#pragma mark - UITableView Delegate ---------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allClocksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClockCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ClockCell"];
    }
    cell.model = self.allClocksArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除
        [AppDelegate cancelLocalNotificationWithKey:self.allClocksArray[indexPath.row].content];

        NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyDatabase.db"];
        
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        if ([database open]) {
            NSString *sqlDelete = [NSString stringWithFormat:@"delete from Clocks where time = '%@'",self.allClocksArray[indexPath.row].time];
            BOOL isSuccess = [database executeUpdate:sqlDelete];
            if (isSuccess) {
                [self.allClocksArray removeObject:self.allClocksArray[indexPath.row]];
                [self.clockTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
