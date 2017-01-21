//
//  CommentCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentModel : JSONModel

@property (nonatomic) BmobUser *User;
@property (nonatomic) BmobUser *ToUser;
@property (nonatomic) BmobObject *Note;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *updatedAt;

@property (nonatomic) BmobObject *CommentObject;

@property (nonatomic) BOOL isZaned;//是否被当前用户赞过

@property (nonatomic) BmobObject *bmobObject;

- (instancetype)initWithBmobObject:(BmobObject *)object;

@end
