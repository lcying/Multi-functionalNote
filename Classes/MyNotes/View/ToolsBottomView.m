//
//  ToolsBottomView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ToolsBottomView.h"
#import "CommentsViewController.h"
#import "MoreCell.h"

@implementation ToolsBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buttonTitleArray = @[@"收藏",@"分享",@"点赞",@"评论",@"更多"];
        self.buttonImageNameArray = @[@"toolCollection",@"toolShare",@"toolZan",@"toolComment",@"toolMore"];
        self.moreArray = @[@"阅读模式",@"字数统计",@"是否公开",@"删除笔记"];
        self.allButtonsArray = [NSMutableArray array];
        
        for (int i = 0; i < self.buttonTitleArray.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/5.0 * i, 0, screenWidth/5.0, 50)];
            [button setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.buttonImageNameArray[i]] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.titleEdgeInsets = UIEdgeInsetsMake(30, -29, 0, 0);
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, screenWidth/10.0 - 12.5, 25, screenWidth/10.0 - 12.5)];//设置图片这个属性改变图片在button上的位置
            
            [self addSubview:button];
            button.tag = 10 + i;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.allButtonsArray addObject:button];
        }
    }
    return self;
}

- (MoreView *)moreView{
    if (_moreView == nil) {
        _moreView = [[MoreView alloc] initWithFrame:CGRectMake(4*screenWidth/5.0 + (screenWidth/10.0 - 30), screenHeight - 50 - 160 - 3, 60, 160)];
        [[self viewController].view addSubview:_moreView];
        _moreView.moreTableView.delegate = self;
        _moreView.moreTableView.dataSource = self;
    }
    return _moreView;
}

- (void)setCurrentNoteModel:(NoteModel *)currentNoteModel{
    _currentNoteModel = currentNoteModel;
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"Note" equalTo:self.currentNoteModel.bmobObject];
    [query whereKeyDoesNotExist:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count >= 1) {
            UIButton *button = self.allButtonsArray[2];
            [button setTitle:@"取消赞" forState:UIControlStateNormal];
        }
    }];
    
    BmobQuery *queryCollection = [BmobQuery queryWithClassName:@"Collection"];
    [queryCollection whereKey:@"User" equalTo:[BmobUser currentUser]];
    [queryCollection whereKey:@"Note" equalTo:self.currentNoteModel.bmobObject];
    [queryCollection findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count >= 1) {
            UIButton *button = self.allButtonsArray[0];
            [button setTitle:@"取消收藏" forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - UITableView Delegate -----------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreCell *cell = [[MoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    
    if ([self.currentNoteModel.isOpen isEqualToString:@"YES"] && indexPath.row == 2) {
        cell.moreLabel.text = @"已公开";
    }else{
        cell.moreLabel.text = self.moreArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoreCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _ToolsBottomCallBack(indexPath.row);
    switch (indexPath.row) {
        case 0:
        {//阅读模式
            if ([cell.moreLabel.text isEqualToString:@"阅读模式"]) {
                cell.moreLabel.text = @"正常模式";
                [self viewController].view.backgroundColor = [Utils colorRGB:@"#C7EDCC"];
            }else{
                cell.moreLabel.text = @"阅读模式";
                [self viewController].view.backgroundColor = [UIColor whiteColor];
            }
        }
            break;
        case 2:
        {//是否公开
            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.objectId];
            if ([cell.moreLabel.text isEqualToString:@"是否公开"]) {
                [object setObject:@"YES" forKey:@"isOpen"];
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        cell.moreLabel.text = @"已公开";
                    }
                }];
            }else{
                [object setObject:@"NO" forKey:@"isOpen"];
                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        cell.moreLabel.text = @"是否公开";
                    }
                }];
            }
        }
            break;
        case 3:
        {//删除笔记
            BmobObject *object = [BmobObject objectWithClassName:@"Note"];
            [object setObjectId:self.currentNoteModel.objectId];
            [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
               //删除成功，返回
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    [Utils toastview:@"删除成功！"];
                    [[self viewController] dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36;
}

#pragma mark - Method -------------------------------------------------
- (void)buttonClickedAction:(UIButton *)button{
    switch (button.tag) {
        case 10:
        {//收藏
            if ([button.currentTitle isEqualToString:@"收藏"]) {
                BmobObject *object = [BmobObject objectWithClassName:@"Collection"];
                [object setObject:[BmobUser currentUser] forKey:@"User"];
                [object setObject:self.currentNoteModel.bmobObject forKey:@"Note"];
                [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        
                        BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.bmobObject.objectId];
                        
                        [currentNote incrementKey:@"collectionCount" byNumber:@1];
                        
                        [currentNote updateInBackground];
                        
                        [button setTitle:@"取消收藏" forState:UIControlStateNormal];
                    }
                }];
                
            }else{
                BmobQuery *query = [BmobQuery queryWithClassName:@"Collection"];
                [query whereKey:@"User" equalTo:[BmobUser currentUser]];
                [query whereKey:@"Note" equalTo:self.currentNoteModel.bmobObject];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        if (array.count > 0) {
                            BmobObject *obj = array.firstObject;
                            [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                if (error) {
                                    [Utils toastViewWithError:error];
                                }else{
                                    
                                    BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.bmobObject.objectId];
                                    
                                    [currentNote decrementKey:@"collectionCount"byNumber:@1];
                                    
                                    [currentNote updateInBackground];
                                    
                                    [button setTitle:@"收藏" forState:UIControlStateNormal];
                                }
                            }];
                        }
                    }
                }];
                
            }
        }
            break;
        case 12:
        {//点赞
            if ([button.currentTitle isEqualToString:@"点赞"]) {
                
                BmobObject *object = [BmobObject objectWithClassName:@"Zan"];
                [object setObject:[BmobUser currentUser] forKey:@"User"];
                [object setObject:self.currentNoteModel.User forKey:@"ToUser"];
                [object setObject:self.currentNoteModel.bmobObject forKey:@"Note"];
                [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        
                        BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.bmobObject.objectId];
                        
                        [currentNote incrementKey:@"zanCount" byNumber:@1];
                        
                        [currentNote updateInBackground];
                        
                        [button setTitle:@"取消赞" forState:UIControlStateNormal];
                    }
                }];
                
            }else{
                BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
                [query whereKey:@"User" equalTo:[BmobUser currentUser]];
                [query whereKey:@"Note" equalTo:self.currentNoteModel.bmobObject];
                [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        if (array.count > 0) {
                            BmobObject *obj = array.firstObject;
                            [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                                if (error) {
                                    [Utils toastViewWithError:error];
                                }else{
                                    
                                    BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.currentNoteModel.bmobObject.objectId];
                                    
                                    [currentNote decrementKey:@"zanCount"byNumber:@1];
                                    
                                    [currentNote updateInBackground];
                                    
                                    [button setTitle:@"点赞" forState:UIControlStateNormal];
                                }
                            }];
                        }
                    }
                }];

            }
        }
            break;
        case 13:
        {//评论
            CommentsViewController *vc = [[CommentsViewController alloc] init];
            vc.noteModel = self.currentNoteModel;
            [[self viewController] presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 14:
        {//更多
            [self moreView];
            self.moreView.hidden = self.moreView.hidden == YES ? NO : YES;
        }
            break;
    }
    _ToolsBottomCallBack(button.tag);
}

@end
