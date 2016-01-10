//
//  ASMainViewController.m
//  Demo
//
//  Created by 王强 on 16/1/8.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "PapersViewController.h"
#import "AssessmentTitleViewController.h"
#import "JobsViewController.h"
#import "StudyViewController.h"
#import "UserViewController.h"
#import "NavigationController.h"
#import "TabBar.h"



@interface MainViewController ()<TabBarDelegate>
/**
 *  TabBar
 */
@property (strong, nonatomic) TabBar *tabbar;
/**
 *  首页
 */
@property (strong, nonatomic) HomeViewController *homeController;
/**
 *  论文
 */
@property (strong, nonatomic) PapersViewController *paperController;
/**
 *  评职
 */
@property (strong, nonatomic) AssessmentTitleViewController *jobTitleController;
/**
 *  就业
 */
@property (strong, nonatomic) JobsViewController *jobsController;
/**
 *  学习
 */
@property (strong, nonatomic) StudyViewController *studyController;
/**
 *  我的
 */
@property (strong, nonatomic) UserViewController *userController;
/**
 *  当前视图
 */
@property (strong, nonatomic) BaseViewController *currentController;

@end

@implementation MainViewController

- (void)changeTabBarDisplayType:(MainTabBarDisplayType)type
{
    if (type == MainTabBarDisplayTypeStudent) {
        self.tabbar.tabBarDisplayType = TabBarDisplayTypeTeacher;
    }else{
        self.tabbar.tabBarDisplayType = TabBarDisplayTypeStudent;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"主页面";
    self.tabbar = [[TabBar alloc] init];
    self.tabbar.delegate = self;
    [self.view addSubview:self.tabbar];
    self.tabbar.selectIndex = 0;
    
    [self addChildViewController:self.homeController];
    [self.view addSubview:self.homeController.view];
    [self.homeController didMoveToParentViewController:self];
    self.currentController = self.homeController;
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    float h = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) > self.topLayoutGuide.length? 20 : 0;
    
    h = self.navigationController.navigationBarHidden? h : h + 44;

    self.tabbar.frame = CGRectMake(0, kHeight - kSizeH - h, kWidth, kSizeH);
    
    [self.view bringSubviewToFront:self.tabbar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASTabBarDelegate
- (void)TabBarDisplayType:(SelectedButtonType)selectedButtonType didSelectAtIndex:(NSInteger)index {
//    NSLog(@"%d   %ld",selectedButtonType,(long)index);
    
    BaseViewController *destinationController = nil;
    switch (selectedButtonType)
    {
        case SelectedButtonTypeHome:
            destinationController = self.homeController;
            break;
        case SelectedButtonTypeStudy:
            destinationController = self.studyController;
            break;
        case SelectedButtonTypeJobs:
            destinationController = self.jobsController;
            break;
        case SelectedButtonTypeAssessmentTitle:
            destinationController = self.jobTitleController;
            break;
        case SelectedButtonTypePapers:
            destinationController = self.paperController;
            break;
        case SelectedButtonTypeUser:
            destinationController = self.userController;
            self.userController.mainControllerDelegate = self;
            break;
            
        default:
            break;
    }
    if (self.currentController == destinationController)
    {
        /**
         *  刷新
         */
        [self.currentController reloadViewController];
        
        return;
    }
//    CGFloat offSizeW = -kWidth;
    [self.currentController.view removeFromSuperview];
    [self.currentController removeFromParentViewController];
    [self addChildViewController:destinationController];
    [self.view addSubview:destinationController.view];
    [destinationController didMoveToParentViewController:self];
//    [self.currentController.view removeFromSuperview];
    self.currentController = destinationController;
    [self.view bringSubviewToFront:self.tabbar];
}




#pragma mark -  private methods


#pragma mark -  event response


#pragma mark -  lazying - getter and setter


#pragma mark - HttpRequest


#pragma mark -  like cycle
- (HomeViewController *)homeController
{
    if (!_homeController)
    {
        _homeController = [[HomeViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_homeController];
        nav.title = _homeController.titleName;
    }
    
    return _homeController;
}

- (PapersViewController *)paperController
{
    if (!_paperController)
    {
        _paperController = [[PapersViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_paperController];
        nav.title = _paperController.titleName;
    }
    
    return _paperController;
}

- (AssessmentTitleViewController *)jobTitleController
{
    if (!_jobTitleController)
    {
        _jobTitleController = [[AssessmentTitleViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_jobTitleController];
        nav.title = _jobTitleController.titleName;
    }
    
    return _jobTitleController;
}

- (JobsViewController *)jobsController
{
    if (!_jobsController)
    {
        _jobsController = [[JobsViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_jobsController];
        nav.title = _jobsController.titleName;
    }
    
    return _jobsController;
}

- (StudyViewController *)studyController
{
    if (!_studyController)
    {
        _studyController = [[StudyViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_studyController];
        nav.title = _studyController.titleName;
    }
    
    return _studyController;
}

- (UserViewController *)userController
{
    if (!_userController)
    {
        _userController = [[UserViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:_userController];

        nav.title = _userController.titleName;
    }
    
    return _userController;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
