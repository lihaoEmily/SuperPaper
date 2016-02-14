//
//  AppDelegate.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "../Common/SPGlobal.h"
//ShareSDK3.1.5
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//QQ Plateform
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//WebChat
#import "WXApi.h"
//SinaWeibo
#import "WeiboSDK.h"
//JPush
#import "JPUSHService.h"
// UMSocialSDK
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "NormalWebViewController.h"

@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSString * pushUrlString;

@end

@implementation AppDelegate

- (NavigationController *)nav{
    if (!_nav)
    {
        _nav = [[NavigationController alloc] initWithRootViewController:[[MainViewController alloc] init]];
        [_nav setNavigationBarHidden:NO];
    }
    
    return _nav;
}

+ (AppDelegate *)app{
    return [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [self registerShareSdkForApplication];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:FALSE];
   // [self registerJushSDKWith:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = AppDelegate.app.nav; 
    [self.window makeKeyAndVisible];
    NSLog(@"----> upload url %@", UPLOAD_SERVER);
    
    // 友盟社会化分享
    // 隐藏未安装的应用
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    
    // 设置友盟APPKey
    [UMSocialData setAppKey:@"56af0b3be0f55ab9b1001511"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx1bb4e3dee024af61" appSecret:@"513ad74a27c611b9afac24f3226b897d" url:@""];
    
    //设置手机QQ 的AppId，Appkey，和分享URL
    [UMSocialQQHandler setQQWithAppId:@"1104770869" appKey:@"GBjkYtbypyf8uQHW" url:@""];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.sharetechnology.SuperPaper" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SuperPaper" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SuperPaper.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - ShareSDK Register
- (void)registerShareSdkForApplication {
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:@"iosv1101"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)/*,
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)*/]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
//             case SSDKPlatformTypeRenren:
//                 [ShareSDKConnector connectRenren:[RennClient class]];
//                 break;
//             case SSDKPlatformTypeGooglePlus:
//                 [ShareSDKConnector connectGooglePlus:[GPPSignIn class]
//                                           shareClass:[GPPShare class]];
//                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                       appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeGooglePlus:
                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
                                            redirectUri:@"http://localhost"
                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

#pragma mark - UMS Register
- (void)registerUMSocialForApplication {
    ;
}

#pragma mark - APNS

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    NSLog(@"deviceToken is%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"----> received remote notification:%@",userInfo);
    // Required,For systems with less than or equal to iOS6
    BOOL ret = [self handlePushNotification:userInfo];
    if (ret) {
        return;
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"----> received remote notification:%@",userInfo);
    // IOS 7 Support Required
    BOOL ret = [self handlePushNotification:userInfo];
    if (ret) {
        return;
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark - Handle push notification
- (BOOL)handlePushNotification:(NSDictionary *)userInfo {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSDictionary* apsDic = [userInfo objectForKey:@"aps"];
    NSString *urlStr = [userInfo objectForKey:@"url"];
    if (urlStr) {
        _pushUrlString = [NSString stringWithString:urlStr];
    }
    if (apsDic != nil) {
        NSString* msg = [apsDic objectForKey:@"alert"];
        if(msg != nil) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:msg
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
            return YES;
        }
    }
    
    return NO;
}

- (void)showWebViewForPushNotification {
    NormalWebViewController* vc = [[NormalWebViewController alloc] init];
    vc.urlString = _pushUrlString;
    vc.title = @"推送";
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    nav.navigationBarHidden = NO;
    UIViewController *rootViewController = AppDelegate.app.nav.topViewController;
    [rootViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"----> push url string : %@", _pushUrlString);
        [self showWebViewForPushNotification];
    } else {
        ;
    }
}

@end
