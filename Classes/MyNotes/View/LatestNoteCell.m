//
//  LatestNoteCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/24.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "LatestNoteCell.h"
#import "OnlyFileViewController.h"

@implementation LatestNoteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
        [self headImageView];
        [self createdAtLabel];
        [self titleLabel];
        [self updatedAtLabel];
        
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        longTap.minimumPressDuration = 1.0;
        
        [self addGestureRecognizer:longTap];
    }
    return self;
}

#pragma mark - Method -----------------

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer{
    
    NSString *message = [NSString stringWithFormat:@"%@",self.noteModel.title];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"笔记" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"移动至..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        OnlyFileViewController *vc = [[OnlyFileViewController alloc] init];
        vc.currentNoteModel = self.noteModel;
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }];
    
    if (![self.noteModel.isOpen isEqualToString:@"YES"]) {
        
        NSString *readString = @"开启阅读密码";
        if ([self.noteModel.readOpen isEqualToString:@"YES"]) {
            readString = @"关闭阅读密码";
        }
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:readString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *isOn = @"NO";
            if ([readString containsString:@"开启"]) {
                isOn = @"YES";
            }
            
            BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Note" objectId:self.noteModel.objectId];
            [obj setObject:isOn forKey:@"readOpen"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    self.noteModel.readOpen = isOn;
                }
            }];
        }];
        [ac addAction:action2];
    }


    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BmobObject *object = self.noteModel.bmobObject;
        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [Utils toastview:@"删除成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshAction" object:nil];
            }else{
                [Utils toastViewWithError:error];
            }
        }];
        
        
    }];
    [action3 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:action1];
    [ac addAction:action3];
    [ac addAction:action4];
    [[self viewController] presentViewController:ac animated:YES completion:nil];
}

- (void)setNoteModel:(NoteModel *)noteModel{
    _noteModel = noteModel;
    if ([noteModel.type isEqualToString:@"0"]) {
        self.headImageView.image = [UIImage imageNamed:@"fileText"];
    }
    if ([noteModel.type isEqualToString:@"1"]) {
        self.headImageView.image = [UIImage imageNamed:@"filePic"];
    }
    if ([noteModel.type isEqualToString:@"2"]) {
        self.headImageView.image = [UIImage imageNamed:@"fileRecord"];
    }
    if ([noteModel.type isEqualToString:@"3"]) {
        self.headImageView.image = [UIImage imageNamed:@"filePainting"];
    }
    
    NSString *timeString = [Utils parseTimeWithTime:noteModel.updatedAt];
    self.updatedAtLabel.text = [NSString stringWithFormat:@"最近更新：%@",timeString];
    self.createdAtLabel.text = [[NSString stringWithFormat:@"%@",noteModel.createdAt] componentsSeparatedByString:@" "].firstObject;
    if ([noteModel.isOpen isEqualToString:@"YES"]) {
        self.titleLabel.text = [NSString stringWithFormat:@"［公开］%@",noteModel.title];
        
        NSRange range = [self.titleLabel.text rangeOfString:@"［公开］"];
        self.titleLabel.attributedText = [Utils setTextColor:self.titleLabel.text FontNumber:[UIFont systemFontOfSize:16] AndRange:range AndColor:[UIColor redColor]];
        
    }else{
        self.titleLabel.text = noteModel.title;
    }
}

#pragma mark - LazyLoading -------------------
- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(8);
            make.width.height.mas_equalTo(40);
        }];
    }
    return _headImageView;
}

- (UILabel *)createdAtLabel{
    if (_createdAtLabel == nil) {
        _createdAtLabel = [[UILabel alloc] init];
        [self addSubview:_createdAtLabel];
        [_createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        _createdAtLabel.textColor = [Utils colorRGB:@"#999999"];
        _createdAtLabel.font = [UIFont systemFontOfSize:12];
        _createdAtLabel.textAlignment = NSTextAlignmentRight;
    }
    return _createdAtLabel;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.createdAtLabel.mas_left).mas_equalTo(-8);
        }];
        _titleLabel.dk_textColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#333333"],[UIColor whiteColor],[UIColor whiteColor]);

        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)updatedAtLabel{
    if (_updatedAtLabel == nil) {
        _updatedAtLabel = [[UILabel alloc] init];
        [self addSubview:_updatedAtLabel];
        [_updatedAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImageView.mas_right).mas_equalTo(8);
            make.top.mas_equalTo(self.createdAtLabel.mas_bottom).mas_equalTo(8);
            make.height.mas_equalTo(18);
            make.right.mas_equalTo(-8);
        }];
        _updatedAtLabel.textColor = [Utils colorRGB:@"#999999"];
        _updatedAtLabel.font = [UIFont systemFontOfSize:12];
        _updatedAtLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _updatedAtLabel;
}

@end
