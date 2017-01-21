//
//  OtherTextCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/27.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "OtherTextCell.h"
#import "OtherPersonalHomeViewController.h"

@implementation OtherTextCell

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    
    if (noteModel.title == nil || [noteModel.title isEqualToString:@""]) {
        self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"该笔记已被原作者删除" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    }else{
        if ([noteModel.User objectForKey:@"username"] == nil) {
            BmobQuery *user = [BmobQuery queryForUser];
            
            [user getObjectInBackgroundWithId:noteModel.User.objectId block:^(BmobObject *object, NSError *error) {
                _noteModel.User = (BmobUser *)object;
                [self.headImageView sd_setImageWithURL:[_noteModel.User objectForKey:@"headPath"] placeholderImage:[UIImage imageNamed:@"headIcon"]];
                self.usernameLabel.text = [_noteModel.User objectForKey:@"username"];
            }];
        }else{
            [self.headImageView sd_setImageWithURL:[_noteModel.User objectForKey:@"headPath"] placeholderImage:[UIImage imageNamed:@"headIcon"]];
            self.usernameLabel.text = [_noteModel.User objectForKey:@"username"];
        }
        self.dateLabel.text = [Utils parseTimeWithTime:noteModel.createdAt];
        self.titleLabel.text = self.noteModel.title;
        self.bottomLabel.text = [NSString stringWithFormat:@"阅读%d・评论%d・收藏%d・点赞%d",noteModel.readCount,noteModel.commentCount,noteModel.collectionCount,noteModel.zanCount];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    self.titleLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor lightGrayColor]);
    self.usernameLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],[UIColor lightGrayColor]);
    self.dateLabel.dk_textColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#0A4869"],[Utils colorRGB:@"#7CB1FF"],[UIColor lightGrayColor]);
    
    
    UITapGestureRecognizer *tapHeadImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadImageViewAction)];
    [self.headImageView addGestureRecognizer:tapHeadImageView];
    self.headImageView.userInteractionEnabled = YES;
}

- (void)setCollectionObjectId:(NSString *)collectionObjectId{
    _collectionObjectId = collectionObjectId;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
    longTap.minimumPressDuration = 1.0;
    
    [self addGestureRecognizer:longTap];
}

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer{
    NSString *message = [NSString stringWithFormat:@"%@",self.noteModel.title];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"笔记" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Collection" objectId:self.collectionObjectId];
        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [Utils toastview:@"删除成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectionViewRefresh" object:nil];
            }else{
                [Utils toastViewWithError:error];
            }
        }];
        
    }];
    [action3 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action3];
    [ac addAction:action4];
    [[self viewController] presentViewController:ac animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)tapHeadImageViewAction{
    OtherPersonalHomeViewController *vc = [[OtherPersonalHomeViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.currentUser = self.noteModel.User;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

@end
