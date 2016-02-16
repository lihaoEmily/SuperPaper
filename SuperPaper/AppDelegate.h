//
//  AppDelegate.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NavigationController.h"
/**
 *  测试用推送KEY
 */
static NSString * const JPushAppKey = @"e550c163c9dd30914734847c";

/**
 *  新推送KEY
 */
//static NSString * const JPushAppKey = @"32169657b8e7a567a6a9fc5b";

/**
 *  推送渠道
 */
static NSString * const JPushChannel = @"Publish channel";

/**
 *  友盟分享KEY
 */
static NSString * const UMShareAppKey = @"56af0b3be0f55ab9b1001511";

/**
 *  微信分享应用ID
 */
static NSString * const WXShareAppId = @"wx1bb4e3dee024af61";

/**
 *  微信消息URL
 */
static NSString * const WXShareAppSecret = @"513ad74a27c611b9afac24f3226b897d";

/**
 *  QQ分享应用ID
 */
static NSString * const QQShareAppId = @"1105051018";

/**
 *  QQ分享KEY
 */
static NSString * const QQShareAppKey = @"qqWTYTx2Yhh8q82R";

/**
 *  Reachability监听HOST
 */
static NSString * const HostName = @"121.42.179.44";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NavigationController *nav;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppDelegate *)app;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

