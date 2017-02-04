//
//  AppDelegate.m
//  Multi-functionalNote
//
//  Created by 刘岑颖 on 16/12/20.
//  Copyright © 2016年 lcy. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginHomeViewController.h"
#import "LoginHomeNaviViewController.h"
#import "LeftMenuViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "NSObject+NSLocalNotification.h"

/*友盟分享appKey
586c9bc85312dd61240004fb  */
/*微信appKey
 wxc52e2345e3d54f6c
 appSecret
 14c6acd9a47d3f13e7b6f5ba07c57840  */
/*微博appKey
 1364330619
 appSecret
 9c62fdba940ff5c7d8813c2f829fb6a3  */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    if ([BmobUser currentUser]) {
        [self showHomeVC];
    }else{
        LoginHomeViewController *vc = [[LoginHomeViewController alloc] init];
        self.window.rootViewController = [[LoginHomeNaviViewController alloc] initWithRootViewController:vc];
    }
    
    //注册bmob
    [Bmob registerWithAppKey:@"cd8c9583341a41c2341e88673e98ade1"];
    
    //设置为日间模式
    self.dk_manager.themeVersion = DKThemeVersionNormal;
    [self.dk_manager dawnComing];
    
    //友盟分享
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"586c9bc85312dd61240004fb"];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxc52e2345e3d54f6c" appSecret:@"14c6acd9a47d3f13e7b6f5ba07c57840" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1364330619"  appSecret:@"9c62fdba940ff5c7d8813c2f829fb6a3" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //环信即时通讯
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"652602287#lcyzufe" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //使用通知推送必须在appDelegate中注册一下
    UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [EaseMobManager shareManager];
    
    return YES;
}

- (void)showHomeVC{
    XHDrawerController *vc = [[XHDrawerController alloc]init];
    vc.springAnimationOn = YES;
    self.tabBarController = [[MainTabBarViewController alloc] init];
    vc.centerViewController = self.tabBarController;
    vc.leftViewController = [[LeftMenuViewController alloc] init];
    self.window.rootViewController = vc;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

/**
 只有当发送出一个本地通知, 并且满足以下条件时, 才会调用该方法
 APP 处于前台情况
 当用用户点击了通知, 从后台, 进入到前台时,
 当锁屏状态下, 用户点击了通知, 从后台进入前台
 
 注意: 当App彻底退出时, 用户点击通知, 打开APP , 不会调用这个方法
 
 但是会把通知的参数传递给 application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
 
 */

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIAlertView  *alert = [[UIAlertView alloc] initWithTitle:@"收到通知" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    // 查看当前的状态出于(前台: 0)/(后台: 2)/(从后台进入前台: 1)
//    NSLog(@"applicationState.rawValue: %zd", application.applicationState);
    
    // 执行响应操作
    // 如果当前App在前台,执行操作
    if (application.applicationState == UIApplicationStateActive) {
//        NSLog(@"执行前台对应的操作");
    } else if (application.applicationState == UIApplicationStateInactive) {
        // 后台进入前台
//        NSLog(@"执行后台进入前台对应的操作");
//        NSLog(@"*****%@", notification.userInfo);
    } else if (application.applicationState == UIApplicationStateBackground) {
        // 当前App在后台
        
//        NSLog(@"执行后台对应的操作");
    }
    
    [AppDelegate cancelLocalNotificationWithKey:notification.alertBody];
}

//监听通知操作行为的点击
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    NSLog(@"监听通知操作行为的点击");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"loginAgain"];
    [ud synchronize];
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}


@end
