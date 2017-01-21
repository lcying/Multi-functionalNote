//
//  Utils.h
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/12.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <UMSocialCore/UMSocialCore.h>

@interface Utils : NSObject

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

+ (CGSize)getAttributedStringSizeWithMinSize:(CGSize)minSize andAttributedString:(NSAttributedString *)attributedString;

+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view;//得到navigationcontroller下navigationBar底下的线视图

+ (NSString *)md5String:(NSString *)inputText;//md5密码加密

+ (void)clearAllUserDefaultsData;//清除userdefaults所有数据

+ (void)toastViewWithTitle:(NSString *)title andBackColor:(UIColor *)backColor andTextColor:(UIColor *)textColor;

+(void)toastview:(NSString *)title;

+ (void)toastViewWithError:(NSError *)error;

+ (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andStr:(NSString *)str;

+ (NSMutableAttributedString *)setTextColor:(NSString *)text FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;

+ (UIColor *)colorRGB:(NSString *)color;

+ (UIBarButtonItem *)returnBackButton;//导航栏返回按钮样式

+ (UITextField *)returnTextFieldWithImageName:(NSString *)imageName andPlaceholder:(NSString *)placeholder;//返回左边带图片的UITextField

+ (UIButton *)returnButtonWithTitle:(NSString *)title;//返回登陆注册的按钮样式

+ (BOOL) isMobile:(NSString *)mobileNumbel;

+ (BOOL)checkPassword:(NSString *)password;

+ (BOOL)checkReadPassword:(NSString *)readPassword;

+ (void)phAuthorizationCheckWithImage:(UIImage *)image;

+ (NSString *)getHTMLWithAttributedString:(NSAttributedString *)attributedString;

+ (NSAttributedString *)getAttributedStringWithHTML:(NSString *)htmlString;

+ (void)playVoiceWithPath:(NSString *)path;

+(NSString *)parseTimeWithTime:(NSString *)timeString;

+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType andText:(NSString *)text;

+ (NSString *)dateToStringWithDate:(NSDate *)date;

+ (BOOL) isTableOK:(NSString *)tableName;

@end
