//
//  FileCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/4.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
        [self headImageView];
        [self createdAtLabel];
        [self titleLabel];
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)];
        longTap.minimumPressDuration = 1.0;
        
        [self addGestureRecognizer:longTap];
    }
    return self;
}

#pragma mark - Method -----------------

-(void)longTap:(UILongPressGestureRecognizer *)longRecognizer{
    
    NSString *readString = @"开启阅读密码";
    if ([self.fileModel.readOpen isEqualToString:@"YES"]) {
        readString = @"关闭阅读密码";
    }
    
    NSString *message = [NSString stringWithFormat:@"%@",self.fileModel.filename];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"文件夹" message:message preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"移动至..." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"重命名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *name = ac.textFields.firstObject.text;
            
            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"Category" objectId:self.fileModel.objectId];
            [object setObject:name forKey:@"filename"];
            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (error) {
                    [Utils toastViewWithError:error];
                }else{
                    [Utils toastview:@"修改成功"];
                    self.titleLabel.text = name;
                }
            }];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder = @"请输入新的文件夹名";
        }];
        [[self viewController] presentViewController:ac animated:YES completion:nil];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:readString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *isOn = @"NO";
        if ([readString containsString:@"开启"]) {
            isOn = @"YES";
        }
        
        BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"Category" objectId:self.fileModel.objectId];
        [obj setObject:isOn forKey:@"readOpen"];
        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                [Utils toastViewWithError:error];
            }else{
                self.fileModel.readOpen = isOn;
            }
        }];
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除文件夹将会删除底下所有内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BmobObject *object = self.fileModel.currentObject;
            [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    BmobQuery *allNote = [BmobQuery queryWithClassName:@"Note"];
                    [allNote whereKey:@"User" equalTo:[BmobUser currentUser]];
                    [allNote whereKey:@"Category" equalTo:self.fileModel.currentObject];
                    [allNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                        if (array.count > 0) {
                            for (BmobObject *obj in array) {
                                [obj deleteInBackground];
                            }
                        }
                        
                        BmobQuery *allCategory = [BmobQuery queryWithClassName:@"Category"];
                        [allCategory whereKey:@"User" equalTo:[BmobUser currentUser]];
                        [allCategory whereKey:@"Category" equalTo:self.fileModel.currentObject];
                        [allCategory findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            if (array.count > 0) {
                                for (BmobObject *obj in array) {
                                    [obj deleteInBackground];
                                }
                            }
                        }];
                    }];
                    
                    [Utils toastview:@"删除成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshAction" object:nil];
                }else{
                    [Utils toastViewWithError:error];
                }
            }];
            
            
            
            
            
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        [[self viewController] presentViewController:ac animated:YES completion:nil];
        
        
    }];
    [action4 setValue:[UIColor redColor] forKey:@"titleTextColor"];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
//    [ac addAction:action1];
    [ac addAction:action2];
    [ac addAction:action3];
    [ac addAction:action4];
    [ac addAction:action5];
    [[self viewController] presentViewController:ac animated:YES completion:nil];
}


- (void)setFileModel:(FileModel *)fileModel{
    _fileModel = fileModel;
    self.titleLabel.text = fileModel.filename;
    self.createdAtLabel.text = [Utils parseTimeWithTime:fileModel.createdAt];
}

- (UIImageView *)headImageView{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(8);
            make.width.height.mas_equalTo(40);
        }];
        _headImageView.image = [UIImage imageNamed:@"fileColor"];
    }
    return _headImageView;
}

- (UILabel *)createdAtLabel{
    if (_createdAtLabel == nil) {
        _createdAtLabel = [[UILabel alloc] init];
        [self addSubview:_createdAtLabel];
        [_createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
            make.right.mas_equalTo(-8);
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
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(self.createdAtLabel.mas_left).mas_equalTo(-8);
        }];
        _titleLabel.dk_textColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#333333"],[UIColor whiteColor],[UIColor whiteColor]);
        
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

@end
