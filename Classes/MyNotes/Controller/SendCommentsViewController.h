//
//  SendCommentsViewController.h
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/26.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendCommentsViewController : UIViewController

@property (nonatomic) BmobObject *commentObject;//是noteModel中的BmobObject
@property (nonatomic) BmobUser *user;

@end
