//
//  FileModel.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel

- (void)setCurrentObject:(BmobObject *)currentObject{
    _currentObject = currentObject;
    self.filename = [currentObject objectForKey:@"filename"];
    self.objectId = currentObject.objectId;
    self.createdAt = [currentObject objectForKey:@"createdAt"];
    self.updatedAt = [currentObject objectForKey:@"updatedAt"];
    if ([currentObject objectForKey:@"Category"]) {
        self.Category = [currentObject objectForKey:@"Category"];
    }
    self.readOpen = [currentObject objectForKey:@"readOpen"];
}

@end
