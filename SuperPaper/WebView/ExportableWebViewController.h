//
//  ExportableWebViewController.h
//  SuperPaper
//
//  Created by AppStudio on 16/1/16.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief 可导出文档 WebView
 *
 */
@interface ExportableWebViewController : UIViewController
/**
 *  URL地址
 */
@property(nonatomic, strong) NSString * urlString;
/**
 *  Web内容
 */
@property (nonatomic, strong) NSString * contentText;

/**
 *  用户数据
 */
@property (nonatomic, strong) NSDictionary * userData;

@end
