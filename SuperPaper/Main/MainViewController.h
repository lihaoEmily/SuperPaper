//
//  ASMainViewController.h
//  Demo
//
//  Created by 王强 on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger , MainTabBarDisplayType) {
    
    MainTabBarDisplayTypeTeacher = 1,
    MainTabBarDisplayTypeStudent
};

@interface MainViewController : BaseViewController

- (void)changeTabBarDisplayType:(MainTabBarDisplayType)type;

@end
