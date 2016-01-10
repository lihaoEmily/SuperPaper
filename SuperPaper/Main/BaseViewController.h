//
//  ASBaseViewController.h
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kSizeH 49
#pragma mark 随机色
#define kArcColor kColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#pragma mark 自定义颜色
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

/**
 *  @brief 父窗口类
 *
 */
@interface BaseViewController : UIViewController

@property (assign, nonatomic) BaseViewController *mainControllerDelegate;
- (NSString *)titleName;

- (void)reloadViewController;

@end
