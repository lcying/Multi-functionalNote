//
//  SBNewsViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/2/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "SBNewsViewController.h"
#import "SBNewsView.h"
#import "ConversationCell.h"
#import "SBNewsDetailViewController.h"

@interface SBNewsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) SBNewsView *messageListView;
@property (nonatomic) NSMutableArray<BmobObject *> *allNewsArray;

@end

@implementation SBNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    
    self.messageListView = [[SBNewsView alloc] init];
    [self.view addSubview:self.messageListView];
    [self.messageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.allNewsArray = [NSMutableArray array];
    [self loadAllSBNewsAction];
    
    self.messageListView.listTableView.delegate = self;
    self.messageListView.listTableView.dataSource = self;
    [self.messageListView.listTableView registerNib:[UINib nibWithNibName:@"ConversationCell" bundle:nil] forCellReuseIdentifier:@"ConversationCell"];
}

- (void)loadAllSBNewsAction{
    BmobQuery *query = [BmobQuery queryWithClassName:@"SBNoteNews"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            if (array.count > 0) {
                self.allNewsArray = [NSMutableArray array];
                for (BmobObject *object in array) {
                    [self.allNewsArray addObject:object];
                }
                [self.messageListView.listTableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableView Delegate -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allNewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobObject *object = self.allNewsArray[indexPath.row];
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConversationCell"];
    }
    cell.headImageView.image = [UIImage imageNamed:@"SBLogo"];
    cell.usernameLabel.text = [object objectForKey:@"Title"];
    cell.latestConLabel.text = [object objectForKey:@"Content"];
    cell.countLabel.hidden = YES;
    cell.timeLabel.text = [[object objectForKey:@"updatedAt"] componentsSeparatedByString:@" "].firstObject;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath];
    SBNewsDetailViewController *vc = [[SBNewsDetailViewController alloc] init];
    vc.object = self.allNewsArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
