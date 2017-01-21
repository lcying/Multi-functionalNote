//
//  CommentCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@property (nonatomic) int zanNumber;

@end

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isZan = NO;
    self.commentButton.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
}

- (void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;
    NSString *string = [self.commentModel.User objectForKey:@"headPath"];
    NSURL *url = [NSURL URLWithString:string];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"headIcon"]];
    self.nickLabel.text = [self.commentModel.User objectForKey:@"username"];
    self.contentLabel.text = commentModel.comment;
    
    if ([self.contentLabel.text componentsSeparatedByString:@" "].count > 1) {
        NSString *stringName = [self.contentLabel.text componentsSeparatedByString:@" "].firstObject;
        NSRange range = [self.contentLabel.text rangeOfString:stringName];
        self.contentLabel.attributedText = [Utils setTextColor:self.contentLabel.text FontNumber:[UIFont systemFontOfSize:14] AndRange:range AndColor:[UIColor blueColor]];
    }
    
    self.timeLabel.text = [Utils parseTimeWithTime:commentModel.createdAt];
    if (commentModel.isZaned == YES) {
        [self.commentButton setImage:[UIImage imageNamed:@"toolZanRed"] forState:UIControlStateNormal];
        self.isZan = YES;
    }else{
        [self.commentButton setImage:[UIImage imageNamed:@"toolZan"] forState:UIControlStateNormal];
        self.isZan = NO;
    }
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Zan"];
    [bquery whereKey:@"User" equalTo:[BmobUser currentUser]];
    [bquery whereKey:@"Comment" equalTo:self.commentModel.bmobObject];
    [bquery countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
        NSString *time = self.timeLabel.text;
        self.zanNumber = number;
        self.timeLabel.text = [NSString stringWithFormat:@"发布于%@ . 已获得%d个赞",time,number];
    }];
    
}

- (IBAction)commentAction:(UIButton *)sender {
    //点赞
    if (self.isZan == NO) {
        
        BmobObject *object = [BmobObject objectWithClassName:@"Zan"];
        [object setObject:[BmobUser currentUser] forKey:@"User"];
        [object setObject:self.commentModel.ToUser forKey:@"ToUser"];
        [object setObject:self.commentModel.bmobObject forKey:@"Comment"];
        [object setObject:self.commentModel.Note forKey:@"Note"];
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                
                BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Comment" objectId:self.commentModel.objectId];
                
                [currentNote incrementKey:@"zanCount" byNumber:@1];
                
                [currentNote updateInBackground];
                
                self.zanNumber ++;
                NSArray *stringArray = [self.timeLabel.text componentsSeparatedByString:@"已获得"];
                self.timeLabel.text = [NSString stringWithFormat:@"%@已获得%d个赞",stringArray.firstObject,self.zanNumber];
                
                [sender setImage:[UIImage imageNamed:@"toolZanRed"] forState:UIControlStateNormal];
                self.isZan = YES;
            }
        }];
        
    }else{
        //先查询到，再删除
        BmobQuery *query = [BmobQuery queryWithClassName:@"Zan"];
        [query whereKey:@"User" equalTo:[BmobUser currentUser]];
        [query whereKey:@"Comment" equalTo:self.commentModel.bmobObject];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                BmobObject *removeObj = array.firstObject;
                BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Zan" objectId:removeObj.objectId];
                [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (error) {
                        [Utils toastViewWithError:error];
                    }else{
                        
                        BmobObject *currentNote = [BmobObject objectWithoutDataWithClassName:@"Comment" objectId:self.commentModel.objectId];
                        
                        [currentNote decrementKey:@"zanCount" byNumber:@1];
                        
                        [currentNote updateInBackground];
                        
                        self.zanNumber --;
                        NSArray *stringArray = [self.timeLabel.text componentsSeparatedByString:@"已获得"];
                        self.timeLabel.text = [NSString stringWithFormat:@"%@已获得%d个赞",stringArray.firstObject,self.zanNumber];
                        
                        [sender setImage:[UIImage imageNamed:@"toolZan"] forState:UIControlStateNormal];
                        self.isZan = NO;
                    }
                }];
            }
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
