//
//  FileModel.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FileModel : JSONModel

@property (nonatomic) BmobObject *currentObject;//当前分类
@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *updatedAt;
@property (nonatomic) NSString *readOpen;
@property (nonatomic) BmobObject<Optional> *Category;//父分类

@end
