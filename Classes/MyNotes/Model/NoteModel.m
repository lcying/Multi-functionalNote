//
//  NoteModel.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

- (instancetype)initWithBmobObject:(BmobObject *)bmobObject{
    self = [super init];
    if (self) {
        self.bmobObject = bmobObject;
        self.title = [bmobObject objectForKey:@"title"];
        self.content = [bmobObject objectForKey:@"content"];
        self.type = [bmobObject objectForKey:@"type"];
        self.imagePaths = [bmobObject objectForKey:@"imagePaths"];
        self.voicePath = [bmobObject objectForKey:@"voicePath"];
        self.createdAt = [bmobObject objectForKey:@"createdAt"];
        self.updatedAt = [bmobObject objectForKey:@"updatedAt"];
        self.objectId = bmobObject.objectId;
        self.seconds = [bmobObject objectForKey:@"seconds"];
        self.isOpen = [bmobObject objectForKey:@"isOpen"];
        self.zanCount = [[bmobObject objectForKey:@"zanCount"] intValue];
        self.commentCount = [[bmobObject objectForKey:@"commentCount"] intValue];
        self.collectionCount = [[bmobObject objectForKey:@"collectionCount"] intValue];
        self.readCount = [[bmobObject objectForKey:@"readCount"] intValue];
        self.shareCount = [[bmobObject objectForKey:@"shareCount"] intValue];
        self.User = [bmobObject objectForKey:@"User"];
        self.readOpen = [bmobObject objectForKey:@"readOpen"];
    }
    return self;
}

@end
