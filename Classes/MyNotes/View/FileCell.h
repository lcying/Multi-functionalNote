//
//  FileCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell

@property (nonatomic) FileModel *fileModel;

@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *createdAtLabel;

@end
