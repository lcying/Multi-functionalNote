//
//  SBNewsDetailViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/2/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "SBNewsDetailViewController.h"
#import "SBNewsDetailView.h"

@interface SBNewsDetailViewController ()

@property (nonatomic) SBNewsDetailView *detailView;

@end

@implementation SBNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随便笔记";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.detailView = [[SBNewsDetailView alloc] init];
    [self.view addSubview:self.detailView];
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.detailView.titleLabel.text = [self.object objectForKey:@"Title"];
    self.detailView.contentTextView.text = [NSString stringWithFormat:@"    %@",[self.object objectForKey:@"Content"]];
}

@end
