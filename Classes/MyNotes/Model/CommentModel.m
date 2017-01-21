//
//  CommentCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (instancetype)initWithBmobObject:(BmobObject *)object{
    self = [super init];
    if (self) {
        self.bmobObject = object;
        self.comment = [object objectForKey:@"comment"];
        self.User = [object objectForKey:@"User"];
        self.createdAt = [object objectForKey:@"createdAt"];
        self.updatedAt = [object objectForKey:@"updatedAt"];
        self.objectId = object.objectId;
        self.Note = [object objectForKey:@"Note"];
        self.ToUser = [object objectForKey:@"ToUser"];
        self.CommentObject = [object objectForKey:@"CommentPointer"];
    }
    return self;
}

@end
