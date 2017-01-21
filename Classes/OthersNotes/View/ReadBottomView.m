//
//  ReadBottomView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/29.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "ReadBottomView.h"
#import "SendCommentsViewController.h"

@implementation ReadBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = @[@"收藏",@"点赞",@"评论",@"分享"];
        self.imageNameArray = @[@"toolCollection",@"toolZan",@"toolComment",@"toolShare"];
        self.allButtonsArray = [NSMutableArray array];
        
        for (int i = 0; i < self.imageNameArray.count; i ++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/4.0 * i, 0, screenWidth/4.0, 50)];
            [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.imageNameArray[i]] forState:UIControlStateNormal];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.titleEdgeInsets = UIEdgeInsetsMake(30, -29, 0, 0);
            
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, screenWidth/8.0 - 12.5, 25, screenWidth/8.0 - 12.5)];//设置图片这个属性改变图片在button上的位置
            
            [self addSubview:button];
            button.tag = 10 + i;
            [button addTarget:self action:@selector(buttonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.allButtonsArray addObject:button];
        }
        
    }
    return self;
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    
    NSArray *countArray = @[@(noteModel.collectionCount),@(noteModel.zanCount),@(noteModel.commentCount),@(noteModel.shareCount)];
    for (int i = 0; i < countArray.count ;i ++) {
        UIButton *button = self.allButtonsArray[i];
        [button setTitle:[NSString stringWithFormat:@"%@%@",self.titleArray[i],countArray[i]] forState:UIControlStateNormal];
    }
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
    [query whereKey:@"User" equalTo:[BmobUser currentUser]];
    [query whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [query whereKeyDoesNotExist:@"Comment"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count >= 1) {
            UIButton *button = self.allButtonsArray[1];
            NSString *countString = [NSString stringWithFormat:@"取消赞%d",self.noteModel.zanCount];
            [button setTitle:countString forState:UIControlStateNormal];
        }
    }];
    
    BmobQuery *queryCollection = [BmobQuery queryWithClassName:@"Collection"];
    [queryCollection whereKey:@"User" equalTo:[BmobUser currentUser]];
    [queryCollection whereKey:@"Note" equalTo:self.noteModel.bmobObject];
    [queryCollection findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array.count >= 1) {
            UIButton *button = self.allButtonsArray[0];
            NSString *countString = [NSString stringWithFormat:@"取消收藏%d",self.noteModel.collectionCount];
            [button setTitle:countString forState:UIControlStateNormal];
        }
    }];
    
}

- (void)buttonClickedAction:(UIButton *)button{
    switch (button.tag) {
        case 10:
        {//收藏
            if ([button.currentTitle containsString:@"取消收藏"]) {
                //取消收藏
                BmobQuery *query = [BmobQuery queryWithClassName:@"Collection"];
                [query whereKey:@"User" equalTo:[BmobUser currentUser]];
                [query whereKey:@"Note" equalTo:self.noteModel.bmobObject];
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
                                    
                                    BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.bmobObject.objectId];
                                    
                                    [currentNote decrementKey:@"collectionCount"byNumber:@1];
                                    
                                    [currentNote updateInBackground];
                                    
                                    
                                    NSString *collectionCountOld = [button.currentTitle componentsSeparatedByString:@"藏"].lastObject;
                                    int collectionOld = [collectionCountOld intValue];
                                    NSString *countString = [NSString stringWithFormat:@"收藏%d",collectionOld - 1];
                                    
                                    [button setTitle:countString forState:UIControlStateNormal];
                                }
                            }];
                        }
                    }
                }];
                
                
            }else{
                //收藏
                BmobObject *object = [BmobObject objectWithClassName:@"Collection"];
                [object setObject:[BmobUser currentUser] forKey:@"User"];
                [object setObject:self.noteModel.bmobObject forKey:@"Note"];
                [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        
                        BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.bmobObject.objectId];
                        
                        [currentNote incrementKey:@"collectionCount" byNumber:@1];
                        
                        [currentNote updateInBackground];
                        
                        NSString *collectionCountOld = [button.currentTitle componentsSeparatedByString:@"藏"].lastObject;
                        int collectionOld = [collectionCountOld intValue];
                        NSString *countString = [NSString stringWithFormat:@"取消收藏%d",collectionOld + 1];
                        [button setTitle:countString forState:UIControlStateNormal];
                    }
                }];
            }
        }
            break;
        case 11:
        {//点赞
            if ([button.currentTitle containsString:@"点赞"]) {
                
                BmobObject *object = [BmobObject objectWithClassName:@"Zan"];
                [object setObject:[BmobUser currentUser] forKey:@"User"];
                [object setObject:self.noteModel.User forKey:@"ToUser"];
                [object setObject:self.noteModel.bmobObject forKey:@"Note"];
                [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        
                        BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.bmobObject.objectId];
                        
                        [currentNote incrementKey:@"zanCount" byNumber:@1];
                        
                        [currentNote updateInBackground];
                        
                        NSString *zanCountOld = [button.currentTitle componentsSeparatedByString:@"赞"].lastObject;
                        int zanOld = [zanCountOld intValue];
                        NSString *countString = [NSString stringWithFormat:@"取消赞%d",zanOld + 1];
                        [button setTitle:countString forState:UIControlStateNormal];
                    }
                }];
                
            }else{
                BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
                [query whereKey:@"User" equalTo:[BmobUser currentUser]];
                [query whereKey:@"Note" equalTo:self.noteModel.bmobObject];
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
                                    
                                    BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.bmobObject.objectId];
                                    
                                    [currentNote decrementKey:@"zanCount"byNumber:@1];
                                    
                                    [currentNote updateInBackground];
                                    
                                    
                                    NSString *zanCountOld = [button.currentTitle componentsSeparatedByString:@"赞"].lastObject;
                                    int zanOld = [zanCountOld intValue];
                                    NSString *countString = [NSString stringWithFormat:@"点赞%d",zanOld - 1];

                                    [button setTitle:countString forState:UIControlStateNormal];
                                }
                            }];
                        }
                    }
                }];
                
            }
        }
            break;
        case 12:
        {//评论
            SendCommentsViewController *vc = [[SendCommentsViewController alloc] init];
            vc.commentObject = self.noteModel.bmobObject;
            vc.user = self.noteModel.User;
            [[self viewController] presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 13:
        {//分享
            _ReadBottomCallBack(@"分享");
        }
            break;
    }
}

@end
