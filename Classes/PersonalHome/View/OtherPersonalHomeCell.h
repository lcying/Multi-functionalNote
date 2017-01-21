//
//  OtherPersonalHomeCell.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/7.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherPersonalHomeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDetailLabel;

@property (nonatomic) NoteModel *noteModel;

@end
