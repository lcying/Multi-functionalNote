//
//  AddClockView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "AddClockView.h"

@interface AddClockView ()

@property (nonatomic) NSArray *titlesArray;

@end

@implementation AddClockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titlesArray = @[@"在指定时间提醒我",@"提醒时间",@"重复"];
        [self contentTextView];
        [self timeTableView];
        [self placeholderLabel];
    }
    return self;
}

- (UITextView *)contentTextView{
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        [self addSubview:_contentTextView];
        [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(150);
        }];
        _contentTextView.font = [UIFont systemFontOfSize:15];
        _contentTextView.textColor = [UIColor darkGrayColor];
        _contentTextView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}

- (UITableView *)timeTableView{
    if (_timeTableView == nil) {
        _timeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_timeTableView];
        [_timeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_equalTo(10);
        }];
        _timeTableView.delegate = self;
        _timeTableView.dataSource = self;
        _timeTableView.tableFooterView = [UIView new];
        _timeTableView.bounces = NO;
        _timeTableView.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"], [UIColor darkGrayColor],[UIColor lightGrayColor]);
    }
    return _timeTableView;
}

- (UILabel *)placeholderLabel{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] init];
        [self addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:15];
        _placeholderLabel.text = @"请输入提醒事件";
    }
    return _placeholderLabel;
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor], [UIColor darkGrayColor] ,[UIColor lightGrayColor]);
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"不重复";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _AddCallBack(indexPath.row);
}

#pragma mark - UITextView Delegate --------------------

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
}

@end
