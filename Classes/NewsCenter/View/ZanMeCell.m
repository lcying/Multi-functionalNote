//
//  ZanMeCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ZanMeCell.h"

@implementation ZanMeCell

- (void)setZanModel:(ZanModel *)zanModel{
    _zanModel = zanModel;
    
    BmobQuery *UserQuery = [BmobQuery queryWithClassName:@"_User"];
    [UserQuery getObjectInBackgroundWithId:zanModel.User.objectId block:^(BmobObject *object, NSError *error) {
        _zanModel.User = (BmobUser *)object;
        self.usernameLabel.text = [NSString stringWithFormat:@"%@",[zanModel.User objectForKey:@"username"]];
    }];
    
    if (zanModel.Note == nil) {
        self.noteTitleLabel.text = @"";
        [self.noteTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.usernameLabel.mas_bottom).mas_equalTo(0);
        }];
        self.stateLabel.text = @"赞了你";
    }
    if (zanModel.Comment != nil) {
        BmobQuery *noteQuery = [BmobQuery queryWithClassName:@"Comment"];
        [noteQuery getObjectInBackgroundWithId:zanModel.Comment.objectId block:^(BmobObject *object, NSError *error) {
            _zanModel.Comment = object;
            self.commentLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"comment"]];
        }];
    }else if(zanModel.Note != nil){
        self.stateLabel.text = @"赞了你的笔记";
    }
    
    BmobQuery *noteQuery = [BmobQuery queryWithClassName:@"Note"];
    [noteQuery getObjectInBackgroundWithId:zanModel.Note.objectId block:^(BmobObject *object, NSError *error) {
        _zanModel.Note = object;
        self.noteTitleLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"title"]];
    }];
    
    self.createdLabel.text = [Utils parseTimeWithTime:zanModel.createdAt];
}

- (void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;
    
    self.commentLabel.text = commentModel.comment;
    BmobQuery *UserQuery = [BmobQuery queryWithClassName:@"_User"];
    [UserQuery getObjectInBackgroundWithId:commentModel.User.objectId block:^(BmobObject *object, NSError *error) {
        _commentModel.User = (BmobUser *)object;
        self.usernameLabel.text = [NSString stringWithFormat:@"%@",[commentModel.User objectForKey:@"username"]];
    }];
    
    if (commentModel.Note != nil) {
        self.stateLabel.text = @"评论了你的笔记";
        
        BmobQuery *noteQuery = [BmobQuery queryWithClassName:@"Note"];
        [noteQuery getObjectInBackgroundWithId:commentModel.Note.objectId block:^(BmobObject *object, NSError *error) {
            _commentModel.Note = object;
            self.noteTitleLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"title"]];
        }];
        
    }
    if (commentModel.CommentObject != nil) {
        self.stateLabel.text = @"评论了你在笔记下的评论";
        
        BmobQuery *noteQuery = [BmobQuery queryWithClassName:@"Comment"];
        [noteQuery getObjectInBackgroundWithId:commentModel.CommentObject.objectId block:^(BmobObject *object, NSError *error) {
            _commentModel.CommentObject = object;
            self.noteTitleLabel.text = [NSString stringWithFormat:@"%@",[object objectForKey:@"comment"]];
        }];
        
    }
    self.createdLabel.text = [Utils parseTimeWithTime:commentModel.createdAt];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
