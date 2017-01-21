//
//  ZanModel.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZanModel : NSObject

@property (nonatomic) NSString *objectId;
@property (nonatomic) BmobUser *User;
@property (nonatomic) BmobUser *ToUser;
@property (nonatomic) BmobObject *Note;
@property (nonatomic) BmobObject *Comment;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *updatedAt;

- (instancetype)initWithBmobObject:(BmobObject *)bmobObject;

@end
