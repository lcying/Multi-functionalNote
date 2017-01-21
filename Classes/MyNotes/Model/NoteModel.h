//
//  NoteModel.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NoteModel : JSONModel

@property (nonatomic) BmobUser *User;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *content;
@property (nonatomic) NSString *type;
@property (nonatomic) NSArray<Optional> *imagePaths;
@property (nonatomic) NSString<Optional> *voicePath;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString<Optional> *seconds;
@property (nonatomic) NSString *isOpen;
@property (nonatomic) int zanCount;
@property (nonatomic) int commentCount;
@property (nonatomic) int readCount;
@property (nonatomic) int collectionCount;
@property (nonatomic) int shareCount;
@property (nonatomic) NSString *readOpen;

@property (nonatomic) BmobObject *bmobObject;

- (instancetype)initWithBmobObject:(BmobObject *)bmobObject;

@end
