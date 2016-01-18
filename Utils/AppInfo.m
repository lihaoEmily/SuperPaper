//
//  AppInfo.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo

+ (NSString *)appCurrentVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVerion"];
}

+ (CGFloat)currentDeviceSystemVersion {
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

@end
