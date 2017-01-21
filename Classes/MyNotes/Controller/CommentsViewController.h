//
//  CommentsViewController.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentView.h"

@interface CommentsViewController : UIViewController

@property (nonatomic) CommentView *commentView;
@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) NSMutableArray *allZanedCommentIdArray;//所有被当前用户赞过的评论id

@end
