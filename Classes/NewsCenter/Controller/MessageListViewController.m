//
//  MessageListViewController.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/23.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListView.h"
#import "ConversationCell.h"
#import "SendMessageViewController.h"

@interface MessageListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) MessageListView *messageListView;
@property (nonatomic) NSMutableArray *allConversationsArray;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息列表";
    
    self.messageListView = [[MessageListView alloc] init];
    [self.view addSubview:self.messageListView];
    [self.messageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    self.allConversationsArray = [NSMutableArray array];
    
    self.messageListView.listTableView.delegate = self;
    self.messageListView.listTableView.dataSource = self;
    [self.messageListView.listTableView registerNib:[UINib nibWithNibName:@"ConversationCell" bundle:nil] forCellReuseIdentifier:@"ConversationCell"];
    
    [self loadAllConvesations];
}

- (void)loadAllConvesations{
    //暂时不保存到内存中
    self.allConversationsArray = [NSMutableArray array];
    self.allConversationsArray = [[[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:NO] mutableCopy];
    [self.messageListView.listTableView reloadData];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allConversationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMConversation *con = self.allConversationsArray[indexPath.row];
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConversationCell"];
    }
    
    //判断未读
    if ([con unreadMessagesCount] == 0) {
        cell.countLabel.hidden = YES;
    }else{
        cell.countLabel.hidden = NO;
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",con.unreadMessagesCount];
        //标记当前对话的所有消息为已读
        [con markAllMessagesAsRead:YES];
    }
    
    //在Bmob中查询私信用户
    BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
    [query whereKey:@"mobilePhoneNumber" equalTo:con.chatter];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            [Utils toastViewWithError:error];
        }else{
            if (array.count > 0) {
                BmobUser *user = (BmobUser *)array.firstObject;
                cell.toUser = user;
            }
        }
    }];
    
    //显示最新对话内容以及时间
    EMMessage *mess = con.latestMessage;
    
    cell.timeLabel.text = [Utils parseTimeWithTimeStap:mess.timestamp];
    
    //得到消息的具体内容
    id<IEMMessageBody> msgBody = mess.messageBodies.firstObject;
    
    switch ((int)msgBody.messageBodyType) {
        case eMessageBodyType_Text:{
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            cell.latestConLabel.text = txt;
        }
            break;
        case eMessageBodyType_Image:{
            cell.latestConLabel.text = @"图片";
        }
            break;
        case eMessageBodyType_Voice:
        {
            cell.latestConLabel.text = @"音频";
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConversationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.countLabel.hidden = YES;
    SendMessageViewController *vc = [[SendMessageViewController alloc] init];
    vc.toUser = cell.toUser;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除对话
        EMConversation *con = self.allConversationsArray[indexPath.row];
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:con.chatter deleteMessages:YES append2Chat:YES];
        [self.allConversationsArray removeObject:con];
        [tableView reloadData];
    }
}

@end
