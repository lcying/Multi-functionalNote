//
//  ZanModel.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/12.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "ZanModel.h"

@implementation ZanModel

- (instancetype)initWithBmobObject:(BmobObject *)bmobObject{
    self = [super init];
    if (self) {
        self.createdAt = [bmobObject objectForKey:@"createdAt"];
        self.updatedAt = [bmobObject objectForKey:@"updatedAt"];
        self.User = [bmobObject objectForKey:@"User"];
        self.ToUser = [bmobObject objectForKey:@"ToUser"];
        self.Comment = [bmobObject objectForKey:@"Comment"];
        self.Note = [bmobObject objectForKey:@"Note"];
        self.objectId = [bmobObject objectForKey:@"objectId"];
    }
    return self;
}

@end
