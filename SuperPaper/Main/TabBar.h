//
//  ASTabBar.h
//  Demo
//
//  Created by Ehan on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , TabBarDisplayType) {

    TabBarDisplayTypeTeacher = 1,
    TabBarDisplayTypeStudent
};

typedef enum{
    SelectedButtonTypeNormal = 5,
    SelectedButtonTypeHome = 0,
    SelectedButtonTypeAssessmentTitle,
    SelectedButtonTypeStudy,
    SelectedButtonTypeJobs,
    SelectedButtonTypePapers,
    SelectedButtonTypeUser,
    
} SelectedButtonType;

@protocol TabBarDelegate;

@interface TabBar : UIView
@property (weak, nonatomic) id delegate;
@property (assign, nonatomic) TabBarDisplayType tabBarDisplayType;
@property (assign, nonatomic) NSUInteger selectIndex;


@end

@protocol TabBarDelegate <NSObject>

@required
- (void)TabBarDisplayType:(SelectedButtonType)selectedButtonType didSelectAtIndex:(NSInteger)index;

@end