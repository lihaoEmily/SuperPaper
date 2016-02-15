//
//  TextWebViewController.h
//  SuperPaper
//
//  Created by AppStudio on 16/2/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 显示文本和浏览数量 WebView
 *
 */
@interface TextWebViewController : UIViewController

/**
 *  URL地址
 */
@property (nonatomic, strong) NSString * urlString;

/**
 *  Web内容
 */
@property (nonatomic, strong) NSString * contentText;

/**
 *  用户数据
 */
@property (nonatomic, strong) NSDictionary * userData;

@end
