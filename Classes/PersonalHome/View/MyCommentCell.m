//
//  MyCommentCell.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 17/1/6.
//  Copyright © 2017年 lcy. All rights reserved.
//

#import "MyCommentCell.h"

@implementation MyCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dk_backgroundColorPicker = DKColorPickerWithColors([UIColor whiteColor],[UIColor darkGrayColor],[UIColor lightGrayColor]);
        [self commentTitleLabel];
        [self commentLabel];
        [self createdAtLabel];
    }
    return self;
}

- (UILabel *)commentTitleLabel{
    if (_commentTitleLabel == nil) {
        _commentTitleLabel = [[UILabel alloc] init];
        [self addSubview:_commentTitleLabel];
        [_commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(19);
            make.top.mas_equalTo(8);
        }];
        _commentTitleLabel.dk_textColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#0081eb"],[UIColor whiteColor],[UIColor whiteColor]);
        _commentTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _commentTitleLabel;
}

- (UILabel *)commentLabel{
    if (_commentLabel == nil) {
        _commentLabel = [[UILabel alloc] init];
        [self addSubview:_commentLabel];
        [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(19);
            make.top.mas_equalTo(self.commentTitleLabel.mas_bottom).mas_equalTo(8);
        }];
        _commentLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor blackColor],[UIColor whiteColor],[UIColor whiteColor]);
        _commentLabel.font = [UIFont systemFontOfSize:15];
        _commentLabel.layer.cornerRadius = 3;
        _commentLabel.layer.masksToBounds = YES;
        _commentLabel.numberOfLines = 0;
        _commentLabel.dk_backgroundColorPicker = DKColorPickerWithColors([Utils colorRGB:@"#f9f9f9"],[UIColor darkGrayColor],[UIColor lightGrayColor]);
    }
    return _commentLabel;
}

- (UILabel *)createdAtLabel{
    if (_createdAtLabel == nil) {
        _createdAtLabel = [[UILabel alloc] init];
        [self addSubview:_createdAtLabel];
        [_createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.height.mas_equalTo(19);
            make.top.mas_equalTo(self.commentLabel.mas_bottom).mas_equalTo(8);
        }];
        _createdAtLabel.dk_textColorPicker = DKColorPickerWithColors([UIColor darkGrayColor],[UIColor whiteColor],[UIColor whiteColor]);
        _createdAtLabel.font = [UIFont systemFontOfSize:13];
    }
    return _createdAtLabel;
}

- (void)setCommentObject:(BmobObject *)commentObject{
    _commentObject = commentObject;
    
    BmobObject *noteObject = [commentObject objectForKey:@"Note"];
    
    NSString *title = [NSString stringWithFormat:@"你在 %@ 中评论",[noteObject objectForKey:@"title"]];
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, 3)];
    [att addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(title.length - 3, 3)];
    
    CGSize titleSize = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 16, 0) andStr:title];
    
    [self.commentTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(8);
        make.height.mas_equalTo(titleSize.height + 1);
    }];
    
    self.commentTitleLabel.attributedText = att;
    
    self.commentLabel.text = [commentObject objectForKey:@"comment"];
    
    CGSize commentSize = [Utils sizeWithFont:[UIFont systemFontOfSize:15] andMaxSize:CGSizeMake(screenWidth - 40, 0) andStr:[commentObject objectForKey:@"comment"]];
    

    [self.commentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.commentTitleLabel.mas_bottom).mas_equalTo(8);
        make.height.mas_equalTo(commentSize.height + 19);
    }];
    
    self.createdAtLabel.text = [Utils parseTimeWithTime:[commentObject objectForKey:@"createdAt"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
