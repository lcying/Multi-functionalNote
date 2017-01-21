//
//  PhotoBroswerVC.h
//  CorePhotoBroswer
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "PhotoBroswerType.h"

@interface PhotoBroswerVC : UIViewController

+(void)show:(UIViewController *)handleVC type:(PhotoBroswerVCType)type index:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock;


@end
