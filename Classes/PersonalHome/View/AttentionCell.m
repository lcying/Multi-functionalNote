//
//  AttentionCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/3.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell

- (IBAction)attentionAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"已关注"]) {
        BmobQuery *query = [BmobQuery queryWithClassName:@"Attention"];
        [query whereKey:@"User" equalTo:[BmobUser currentUser]];
        [query whereKey:@"ToUser" equalTo:self.toUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                for (BmobObject *obj in array) {
                    [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [sender setTitle:@"＋" forState:UIControlStateNormal];
                            [sender setBackgroundColor:[Utils colorRGB:@"#4eee94"]];
                            
                            NSArray *stringArray = [self.countLabel.text componentsSeparatedByString:@"・共"];
                            int count = [[stringArray.lastObject componentsSeparatedByString:@"个人"].firstObject intValue];
                            self.countLabel.text = [NSString stringWithFormat:@"%@・共%d个人关注",stringArray.firstObject, count - 1];
                            
                            
                            /*--userCount表中-1--*/
                            
                            BmobQuery *userCount = [BmobQuery queryWithClassName:@"UserCount"];
                            [userCount whereKey:@"User" equalTo:self.toUser];
                            [userCount findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                                if (array) {
                                    BmobObject *userObj = array.firstObject;
                                    BmobObject *userCountObj = [BmobObject objectWithoutDataWithClassName:@"UserCount" objectId:userObj.objectId];
                                    [userCountObj decrementKey:@"attentionCount" byNumber:@1];
                                    [userCountObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                        if (error) {
                                            
                                        }
                                    }];
                                }
                            }];
                            
                            
                        }else{
                            [Utils toastViewWithError:error];
                        }
                    }];
                }
            }
        }];
    }else{
        BmobObject *obj = [BmobObject objectWithClassName:@"Attention"];
        [obj setObject:[BmobUser currentUser] forKey:@"User"];
        [obj setObject:self.toUser forKey:@"ToUser"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                [sender setTitle:@"已关注" forState:UIControlStateNormal];
                [sender setBackgroundColor:[UIColor lightGrayColor]];
                
                NSArray *stringArray = [self.countLabel.text componentsSeparatedByString:@"・共"];
                int count = [[stringArray.lastObject componentsSeparatedByString:@"个人"].firstObject intValue];
                self.countLabel.text = [NSString stringWithFormat:@"%@・共%d个人关注",stringArray.firstObject, count + 1];
                
                
                /*--userCount表中+1--*/
                
                BmobQuery *userCount = [BmobQuery queryWithClassName:@"UserCount"];
                [userCount whereKey:@"User" equalTo:self.toUser];
                [userCount findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (array) {
                        BmobObject *userObj = array.firstObject;
                        BmobObject *userCountObj = [BmobObject objectWithoutDataWithClassName:@"UserCount" objectId:userObj.objectId];
                        [userCountObj incrementKey:@"attentionCount" byNumber:@1];
                        [userCountObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (error) {
                                
                            }
                        }];
                    }
                }];
                
            }
        }];
    }
}

- (void)setToUser:(BmobUser *)toUser{
    _toUser = toUser;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[toUser objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.usernameLabel.text = [toUser objectForKey:@"username"];
    
    if ([self.stateString isEqualToString:@"关注我的"]) {
        //判断我是否关注过
        BmobQuery *aQuery = [BmobQuery queryWithClassName:@"Attention"];
        [aQuery whereKey:@"User" equalTo:[BmobUser currentUser]];
        [aQuery whereKey:@"ToUser" equalTo:toUser];
        [aQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (number > 0) {
                [self.attentionButton setTitle:@"已关注" forState:UIControlStateNormal];
                [self.attentionButton setBackgroundColor:[UIColor lightGrayColor]];
            }else{
                [self.attentionButton setTitle:@"＋" forState:UIControlStateNormal];
                [self.attentionButton setBackgroundColor:[Utils colorRGB:@"#4eee94"]];
            }
        }];
    }
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Note"];
    [query whereKey:@"User" equalTo:toUser];
    [query whereKey:@"isOpen" equalTo:@"YES"];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        self.countLabel.text = [NSString stringWithFormat:@"共%d篇文章",number];
        
        BmobQuery *queryA = [BmobQuery queryWithClassName:@"Attention"];
        [queryA whereKey:@"ToUser" equalTo:toUser];
        [queryA countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            self.countLabel.text = [NSString stringWithFormat:@"%@・共%d个人关注",self.countLabel.text,number];
        }];
        
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 25;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
