//
//  OtherNotesView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "OtherNotesView.h"

#define sc 254/375.0  //轮播图 高／宽

@implementation OtherNotesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self noteTableView];
    }
    return self;
}

- (SDCycleScrollView *)imageScrollView{
    if (_imageScrollView == nil) {
        _imageScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screenWidth, screenWidth*sc) imageNamesGroup:@[@"scrollView0",@"scrollView1",@"scrollView2"]];
        _imageScrollView.delegate = self;
        _imageScrollView.contentMode = UIViewContentModeScaleAspectFit;
        _imageScrollView.backgroundColor = [UIColor clearColor];
        _imageScrollView.autoScrollTimeInterval = 2.0;
        _imageScrollView.currentPageDotColor = [UIColor orangeColor];
    }
    return _imageScrollView;
}

- (UITableView *)noteTableView{
    if (_noteTableView == nil) {
        _noteTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_noteTableView];
        [_noteTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        _noteTableView.tableHeaderView = self.imageScrollView;
        _noteTableView.tableFooterView = [UIView new];
        _noteTableView.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    }
    return _noteTableView;
}

#pragma mark - SDCycleScrollView Delegate ----------------------
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

@end
