//
//  FontChangeView.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "FontChangeView.h"

@implementation FontChangeView
- (IBAction)redSliderChanged:(UISlider *)sender {
    [self changeString];
}

- (IBAction)greenSliderChanged:(UISlider *)sender {
    [self changeString];
}

- (IBAction)blueSliderChanged:(UISlider *)sender {
    [self changeString];
}

- (IBAction)decreaseFontAction:(UIButton *)sender {
    NSInteger font = [self.fontTextField.text integerValue];
    if (font == 1) {
        return;
    }
    font --;
    self.fontTextField.text = [NSString stringWithFormat:@"%ld",font];
    [self changeString];
}
- (IBAction)increaseFontAction:(UIButton *)sender {
    NSInteger font = [self.fontTextField.text integerValue];
    if (font == 60) {
        return;
    }
    font ++;
    self.fontTextField.text = [NSString stringWithFormat:@"%ld",font];
    [self changeString];
}

- (IBAction)sureButtonClicked:(UIButton *)sender {
    _FontCallBack(sender);
}

- (void)changeString{
    NSString *string = self.exampleLabel.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    // 设置字体大小 range是设置范围，下同
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[self.fontTextField.text floatValue]] range:NSMakeRange(0, string.length)];
    // 设置字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:self.redSlider.value/255.0 green:self.greenSlider.value/255.0 blue:self.blueSlider.value/255.0 alpha:1.0] range:NSMakeRange(0, string.length)];
    self.exampleLabel.attributedText = str;
}

@end
