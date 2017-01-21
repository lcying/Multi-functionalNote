//
//  FontChangeView.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/23.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontChangeView : UIView

@property (nonatomic) void(^FontCallBack) (id obj);

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UITextField *fontTextField;
@property (weak, nonatomic) IBOutlet UILabel *exampleLabel;

@end
