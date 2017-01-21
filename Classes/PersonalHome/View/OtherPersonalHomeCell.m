//
//  OtherPersonalHomeCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "OtherPersonalHomeCell.h"

@implementation OtherPersonalHomeCell

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    self.noteTitleLabel.text = noteModel.title;
    self.noteTimeLabel.text = [Utils parseTimeWithTime:noteModel.createdAt];
    
    
    
    
    self.noteDetailLabel.text = [NSString stringWithFormat:@"阅读%d・评论%d・收藏%d・点赞%d",noteModel.readCount,noteModel.commentCount,noteModel.collectionCount,noteModel.zanCount];
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
