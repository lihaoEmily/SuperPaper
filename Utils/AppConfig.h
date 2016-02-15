//
//  AppConfig.h
//  SuperPaper
//
//  Created by admin on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  @brief 通用颜色,字体,Size等
 *
 */

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAVIGATIONBAR_HEIGHT 64
#define TABBAR_HEIGHT        49
#pragma mark 随机色
#define kArcColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#pragma mark 自定义颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface AppConfig : NSObject
/**
 *  NavigationBar颜色
 *
 *  @return 颜色值
 */
+ (UIColor *)appNaviColor;

/**
 *  View背景色
 *
 *  @return 颜色值
 */
+ (UIColor *)viewBackgroundColor;
@end
