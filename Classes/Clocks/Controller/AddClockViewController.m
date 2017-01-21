//
//  AddClockViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "AddClockViewController.h"
#import "AddClockView.h"
#import "CJCalendarViewController.h"
#import "AppDelegate.h"

@interface AddClockViewController () <CalendarViewControllerDelegate>

@property (nonatomic) AddClockView *addView;

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) UIView *backView;

@property (nonatomic) NSString *dateString;
@property (nonatomic) int isRepeat;

@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加提醒";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.addView = [[AddClockView alloc] init];
    [self.view addSubview:self.addView];
    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 64)];
    [self.view addSubview:self.backView];
    self.backView.alpha = 0.4;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.hidden = YES;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)];
    [self.backView addGestureRecognizer:dismissTap];
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, 250)];
    [self.view addSubview:self.datePicker];
    self.datePicker.backgroundColor = [UIColor whiteColor];
    self.datePicker.datePickerMode = UIDatePickerModeTime;
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    __block __weak AddClockViewController *weakself = self;

    [self.addView setAddCallBack:^(NSInteger row) {
        [weakself.view endEditing:YES];
        if (row == 0) {
            //选择日期
            CJCalendarViewController *calendarController = [[CJCalendarViewController alloc] init];
            calendarController.view.frame = weakself.view.frame;
            calendarController.delegate = weakself;
            
            [weakself presentViewController:calendarController animated:YES completion:nil];
        }
        if (row == 1) {
            weakself.backView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                CGRect frame = CGRectMake(0, screenHeight - 250 - 64, screenWidth, 250);
                weakself.datePicker.frame = frame;
            }];
        }
        if (row == 2) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"是否重复" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITableViewCell *cell = [weakself.addView.timeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell.detailTextLabel.text = @"重复";
                weakself.isRepeat = 1;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不重复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITableViewCell *cell = [weakself.addView.timeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
                cell.detailTextLabel.text = @"不重复";
                weakself.isRepeat = 0;
            }];
            [ac addAction:action1];
            [ac addAction:action2];
            [weakself presentViewController:ac animated:YES completion:nil];
        }
    }];
}

#pragma mark - Method -----------------------------------

- (void)dismissAction{
    self.backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, screenHeight - 64, screenWidth, 250);
        self.datePicker.frame = frame;
    }];
    
    NSDate *date=[self.datePicker date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"HH:mm:ss";
    NSString *timeStr=[formatter stringFromDate:date];
    
    UITableViewCell *cell = [self.addView.timeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailTextLabel.text = timeStr;
}

- (void)finishAction{
    //完成按钮  闹钟数据存储在本地
    
    //判断内容是否都输完了
    if ([self.addView.contentTextView.text isEqualToString:@""]) {
        [Utils toastview:@"请输入提醒内容"];
        return;
    }
    
    UITableViewCell *cell1 = [self.addView.timeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([cell1.detailTextLabel.text isEqualToString:@""] || cell1.detailTextLabel.text == nil) {
        [Utils toastview:@"请选择提醒时间"];
        return;
    }
    
    //时间戳
    
    NSTimeInterval begins = [[NSDate date] timeIntervalSince1970];
    
    NSDate *endDate = [self.datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *endDateString = [formatter stringFromDate:endDate];
    
    //得到时间
    if (self.dateString == nil || [self.dateString isEqualToString:@""]) {
        self.dateString = [NSString stringWithFormat:@"%@",cell1.detailTextLabel.text];
    }else{
        self.dateString = [NSString stringWithFormat:@"%@ %@",self.dateString,cell1.detailTextLabel.text];
        endDateString = self.dateString;
    }
    
    endDate = [formatter dateFromString:endDateString];
    
    NSTimeInterval ends = [endDate timeIntervalSince1970];
    
    NSInteger between = ends - begins;
    
    //存储到本地
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyDatabase.db"];
    
    NSLog(@"path = %@",dbPath);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if ([database open]) {
        BOOL isSuccess = [database executeUpdate:@"create table if not exists Clocks (content varchar(300),time varchar(100) primary key,repeat int)"];
        
        if (isSuccess) {
            NSString *sqlInsert = [NSString stringWithFormat:@"insert into Clocks values ('%@','%@',%d)",self.addView.contentTextView.text,self.dateString,self.isRepeat];
            BOOL insertSuccess = [database executeUpdate:sqlInsert];
            if (insertSuccess) {
                [Utils toastview:@"添加成功!"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Utils toastview:@"添加失败，不可重复添加同一个事件的闹钟"];
            }
        }
    }
    //添加通知-------------------------------------------------
    [AppDelegate registerLocalNotification:between content:self.addView.contentTextView.text key:self.addView.contentTextView.text repeat:self.isRepeat];
    
    //添加通知-------------------------------------------------
}

#pragma mark - CalendarViewController Delegate --------------
-(void) CalendarViewController:(CJCalendarViewController *)controller didSelectActionYear:(NSString *)year month:(NSString *)month day:(NSString *)day{
    UITableViewCell *cell = [self.addView.timeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
    [controller dismissViewControllerAnimated:YES completion:nil];
    self.dateString = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

@end
