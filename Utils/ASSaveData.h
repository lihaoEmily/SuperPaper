//
//  ASSaveData.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHE_DIR @"Papers"
/**
 *  @brief 将文件保存到本地Document中
 */
@interface ASSaveData : NSObject
/**
 *  保存Data数据
 *
 *  @param cacheData Data类型数据
 *  @param title     保存标题
 *
 *  @return YES，成功；NO，失败
 */
- (BOOL)saveToLocationWithData:(NSData *)cacheData withTitle:(NSString *)title;

/**
 *  保存String数据
 *
 *  @param cacheStrings String类型数据
 *  @param title        保存标题
 *
 *  @return YES，成功；NO，失败
 */
- (BOOL)saveToLocationwithStrings:(NSString *)cacheStrings withTitle:(NSString *)title;

/**
 *  删除保存目录
 *
 *  @param directoyName 目录名（CACHE_DIR）
 *
 *  @return YES，成功；NO，失败
 */
- (BOOL)deleteCustomPathWithName:(NSString *)directoyName;

@end
