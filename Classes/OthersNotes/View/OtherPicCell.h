//
//  OtherPicCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic) NoteModel *noteModel;
@property (nonatomic) NSString *collectionObjectId;

@end
