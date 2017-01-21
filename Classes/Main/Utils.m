//
//  Utils.m
//  PhoneWorld
//
//  Created by 刘岑颖 on 16/10/12.
//  Copyright © 2016年 xiyoukeji. All rights reserved.
//

#import "Utils.h"
#import "UIView+Toast.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"

#define appKey @"LCY"
#define appPassword @"YCL"

//定义一个全局变量的相册名字
static NSString *photoAssetCollectionName = @"随便笔记相册";

//static修饰的静态变量等工程结束才会释放（保证了播放是同一个player播放）
static AVAudioPlayer *player;

@interface Utils ()

@end

@implementation Utils

//json格式字符串转换成字典
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

//得到NSAttributedString字符串的size
+ (CGSize)getAttributedStringSizeWithMinSize:(CGSize)minSize andAttributedString:(NSAttributedString *)attributedString{
    CGSize textBlockMinSize = minSize;
    CGSize retSize;
    CGRect boundingRect = [attributedString boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    retSize = boundingRect.size;
    return retSize;
}

//得到当前界面的导航栏下的线视图
+ (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//md5加密
+ (NSString *)md5String:(NSString *)inputText{
    NSString *inputText1 = [NSString stringWithFormat:@"%@%@%@",appKey,inputText,appPassword];
    const char *original_str = [inputText1 UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

#pragma mark -- 提醒弹窗
+ (void)toastViewWithTitle:(NSString *)title andBackColor:(UIColor *)backColor andTextColor:(UIColor *)textColor{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [backColor colorWithAlphaComponent:0.9];;
    style.titleColor = textColor;
    style.messageColor = textColor;
    [[[UIApplication sharedApplication] keyWindow] makeToast:title duration:1.0 position:CSToastPositionCenter style:style];
}

+(void)toastview:(NSString *)title
{
    [[[UIApplication sharedApplication] keyWindow] makeToast:title duration:1.0 position:CSToastPositionCenter];
}

+ (void)toastViewWithError:(NSError *)error{
    NSString *errorString = [NSString stringWithFormat:@"%@",error];
    errorString = [errorString componentsSeparatedByString:@"\""][1];
    [Utils toastview:errorString];
}

//通过文本字号、固定宽度或高度得到显示全部文本的size
+ (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)maxSize andStr:(NSString *)str{
    NSDictionary *dic = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
}

//设置文本为带属性的文本
+ (NSMutableAttributedString *)setTextColor:(NSString *)text FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    return str;
}

//清除所有NSUserDefaults本地存储
+ (void)clearAllUserDefaultsData
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

//把#666666格式的文本转换成UIColor
+ (UIColor *)colorRGB:(NSString *)color{
    // 转换成标准16进制数
    NSString *newColor = [color stringByReplacingCharactersInRange:[color rangeOfString:@"#"] withString:@"0x"];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([newColor cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *rgbColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return rgbColor;
}

//定制导航栏上返回按钮样式
+ (UIBarButtonItem *)returnBackButton{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
    backButton.title = @"返回";
    [backButton setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    return backButton;
}

//返回带左图片的文本输入框
+ (UITextField *)returnTextFieldWithImageName:(NSString *)imageName andPlaceholder:(NSString *)placeholder{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.textColor = [Utils colorRGB:@"#707070"];
    textField.font = [UIFont systemFontOfSize:16];
    
    textField.borderStyle = UITextBorderStyleNone;
    textField.backgroundColor = [UIColor whiteColor];
    textField.layer.cornerRadius = 20;
    textField.layer.masksToBounds = YES;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.image = [UIImage imageNamed:imageName];
    textField.leftView = imageV;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

//返回固定样式的按钮
+ (UIButton *)returnButtonWithTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [button setBackgroundImage:[UIImage imageNamed:@"whiteBackImage"] forState:UIControlStateSelected];
    
    [button setBackgroundImage:[UIImage imageNamed:@"whiteBackImage"] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    
    button.layer.cornerRadius = 20;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.masksToBounds = YES;
    
    return button;
}

//判断手机号是否正确
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
          * 手机号码
          * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
          * 联通：130,131,132,152,155,156,185,186
          * 电信：133,1349,153,180,189,181(增加)
          */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
          10         * 中国移动：China Mobile
          11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
          12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
          15         * 中国联通：China Unicom
          16         * 130,131,132,152,155,156,185,186
          17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
          20         * 中国电信：China Telecom
          21         * 133,1349,153,180,189,181(增加)
          22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    return NO;
}

//检查密码格式是否符合要求
+ (BOOL)checkPassword:(NSString*) password{
    NSString*pattern=@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,12}";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch=[pred evaluateWithObject:password];
    return isMatch;
}

//检查阅读密码是否是六位数字
+ (BOOL)checkReadPassword:(NSString *)readPassword{
    NSString *pattern=@"^[0-9]{6}$";
    NSPredicate *pred=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch=[pred evaluateWithObject:readPassword];
    return isMatch;
}

/*-------------------保存图片到自建相册---------------------------*/
//判断是否有权限访问相簿
+ (void)phAuthorizationCheckWithImage:(UIImage *)image{
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        [Utils toastview:@"无法访问相册"];
    } else if (status == PHAuthorizationStatusDenied) {
        [Utils toastview:@"无法访问相册"];
    } else if (status == PHAuthorizationStatusAuthorized) {
        [self saveImageWithImage:image];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                [self saveImageWithImage:image];
            }
        }];
    }
}

//  获得相簿
+ (PHAssetCollection *)createAssetCollection{
    
    //判断是否已存在
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection * assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:photoAssetCollectionName]) {
            //说明已经有哪对象了
            return assetCollection;
        }
    }
    
    //创建新的相簿
    __block NSString *assetCollectionLocalIdentifier = nil;
    NSError *error = nil;
    //同步方法
    [[PHPhotoLibrary sharedPhotoLibrary]performChangesAndWait:^{
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:photoAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (error)return nil;
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

//保存图片
+ (void)saveImageWithImage:(UIImage *)image{
    
    __block  NSString *assetLocalIdentifier;
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        
        //1.保存图片到相机胶卷中----创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if(success == NO){
            [Utils toastview:@"图片保存失败"];
            NSLog(@"保存图片失败----(创建图片的请求)");
            return ;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self createAssetCollection];
        if (createdAssetCollection == nil) {
            [Utils toastview:@"相册创建失败"];
            NSLog(@"保存图片成功----(创建相簿失败!)");
            return;
        }
        
        // 3.将刚刚添加到"相机胶卷"中的图片到"自己创建相簿"中
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            
            //获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            //添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                NSLog(@"保存图片到创建的相簿成功");
            }else{
                NSLog(@"保存图片到创建的相簿失败");
            }
        }];
    }];
}
/*-------------------保存图片到自建相册---------------------------*/

//将带属性的文本转化成HTML格式
+ (NSString *)getHTMLWithAttributedString:(NSAttributedString *)attributedString {
    NSDictionary *exportParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSData *htmlData = [attributedString dataFromRange:NSMakeRange(0, attributedString.length) documentAttributes:exportParams error:nil];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"pt;" withString:@"px;"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"pt}" withString:@"px}"];
    return htmlString;
}

//HTML转化成带属性的文本
+ (NSAttributedString *)getAttributedStringWithHTML:(NSString *)htmlString{
    NSData *htmltest = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSAttributedString *attString = [[NSAttributedString alloc] initWithData:htmltest options:importParams documentAttributes:nil error:nil];
    return attString;
}

//根据路径播放音频
+ (void)playVoiceWithPath:(NSString *)path{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //请求网络数据耗时
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
#warning 解析amr数据到wmv
        data = DecodeAMRToWAVE(data);
        dispatch_async(dispatch_get_main_queue(), ^{
            player = [[AVAudioPlayer alloc] initWithData:data error:nil];
            [player play];
        });
    });
}

//时间转化成固定格式
+(NSString *)parseTimeWithTime:(NSString *)timeString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createDate = [formatter dateFromString:timeString];
    
    //获取当前时间对象
    NSDate *nowDate = [NSDate date];
    long timestamp = [createDate timeIntervalSince1970];
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-timestamp;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

//分享
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType andText:(NSString *)text{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

//日期转换成字符串
+ (NSString *)dateToStringWithDate:(NSDate *)date{
    NSString *dateString = [NSString stringWithFormat:@"%@",date];
    dateString = [dateString componentsSeparatedByString:@" "][1];
    return dateString;
}

//判断是否存在表
+ (BOOL) isTableOK:(NSString *)tableName
{
    NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MyDatabase.db"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    if([database open]){
        FMResultSet *rs = [database executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            NSLog(@"isTableOK %ld", count);
            
            if (0 == count){
                return NO;
            }else{
                return YES;
            }
        }
        
        return NO;
    }
    return NO;
}


@end
