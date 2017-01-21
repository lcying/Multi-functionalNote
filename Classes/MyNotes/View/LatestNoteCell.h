//
//  LatestNoteCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface LatestNoteCell : UITableViewCell

@property (nonatomic) NoteModel *noteModel;

@property (nonatomic) UIImageView *headImageView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *createdAtLabel;
@property (nonatomic) UILabel *updatedAtLabel;

@end
