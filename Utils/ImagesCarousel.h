//
//  ImagesCarousel.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @brief 图片轮播
 */
@interface ImagesCarousel : NSObject
/**
 *  单例
 *
 *  @return ImagesCarousel 单例
 */
+ (instancetype)sharedInstance;
/**
 *  开始图片轮播
 *
 *  @param images    轮播图片
 *  @param imageView 图片视图
 */
- (void) startCarouselWithImages:(NSArray *)images andImageView:(UIImageView *)imageView;
/**
 *  停止图片轮播
 */
- (void) stopCarousel;
@end
