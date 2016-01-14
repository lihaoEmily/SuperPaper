//
//  UserViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserViewController.h"
#import "MainViewController.h"
@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //TODO: for testing
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,64,100, 100)];
    btn.backgroundColor = kSelColor;
    [btn setTitle:@"Teacher" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self
            action:@selector(buttonAction:)
  forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleName {
    return @"我的";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)buttonAction:(UIButton *)btn
{
    MainViewController *mainController = (MainViewController *)self.mainControllerDelegate;
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn setTitle:@"Student" forState:UIControlStateNormal] ;
        [mainController changeTabBarDisplayType:MainTabBarDisplayTypeStudent];
    }else{
        [btn setTitle:@"Teacher" forState:UIControlStateNormal] ;
        [mainController changeTabBarDisplayType:MainTabBarDisplayTypeTeacher];
    }
}

@end
