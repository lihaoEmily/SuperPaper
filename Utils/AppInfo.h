//
//  AppInfo.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @brief 应用程序信息
 *
 */
@interface AppInfo : NSObject
/**
 *  取得当前App版本号
 *
 *  @return App版本号
 */
+ (NSString *)appCurrentVersion;
/**
 *  取得当前App Build版本号
 *
 *  @return Build版本号
 */
+ (NSString *)appBuildVersion;
/**
 *  当前系统版本号
 *
 *  @return 系统版本号
 */
+ (CGFloat)currentDeviceSystemVersion;

@end
