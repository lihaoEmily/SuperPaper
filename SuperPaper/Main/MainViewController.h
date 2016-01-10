//
//  ASMainViewController.h
//  Demo
//
//  Created by Ethan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger , MainTabBarDisplayType) {
    
    MainTabBarDisplayTypeTeacher = 1,
    MainTabBarDisplayTypeStudent
};

/**
 *  @brief 主窗口类
 *
 */
@interface MainViewController : BaseViewController

- (void)changeTabBarDisplayType:(MainTabBarDisplayType)type;

@end
