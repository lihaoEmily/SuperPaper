//
//  ASSaveData.h
//  SuperPaper
//
//  Created by 瞿飞 on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CACHE_DIR @"Papers"

@interface ASSaveData : NSObject

- (BOOL)saveToLocationWithData:(NSData *)cacheData withTitle:(NSString *)title;
- (BOOL)saveToLocationwithStrings:(NSString *)cacheStrings withTitle:(NSString *)title;
- (BOOL)deleteCustomPathWithName:(NSString *)directoyName;

@end
