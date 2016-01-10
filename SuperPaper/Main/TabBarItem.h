//
//  ASTabBarItem.h
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>


// title文字的颜色
#define kSelColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

#define kNormalColor [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0f]

@interface TabBarItem : UIButton

- (instancetype)initTabbarItemTitle:(NSString *)titleStr image:(NSString *)imageStr selImage:(NSString *)selImageStr;

@end
