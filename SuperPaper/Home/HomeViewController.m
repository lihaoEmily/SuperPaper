//
//  HomeViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeViewController.h"
#import "NormalWebViewController.h"
#import "UserSession.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,64,100, 100)];
    btn.backgroundColor = kSelColor;
    btn.tag = 100;
    [btn setTitle:@"画面迁移" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self
            action:@selector(buttonAction:)
  forControlEvents:UIControlEventTouchUpInside];
    //TODO:for texting
    UIButton *btnWeb = [[UIButton alloc] initWithFrame:CGRectMake(108,64,100, 100)];
    btnWeb.backgroundColor = kSelColor;
    btnWeb.tag = 101;
    [btnWeb setTitle:@"WebView" forState:UIControlStateNormal];
    [btnWeb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnWeb];
    [btnWeb addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self testUserSession];
}

- (void)buttonAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.title = @"新页面";
            vc.view.backgroundColor = [UIColor yellowColor];
            /**
             * 跳转页面
             */
            [AppDelegate.app.nav pushViewController:vc animated:YES];
            break;
        }
        case 101:
        {
            NormalWebViewController *vc = [[NormalWebViewController alloc] init];
            vc.title = @"网页展示";
            vc.urlString = @"http://www.baidu.com";
            /**
             * 跳转页面
             */
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
        default:
            break;
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleName {
    return @"首页";
}

- (void)testUserSession {
    UserRole role = [[UserSession sharedInstance] currentRole];
    NSLog(@"----> CurrentUserRole:%ld",role);
//    if (role == kUserRoleStudent) {
//        [[UserSession sharedInstance] setCurrentRole:kUserRoleTeacher];
//    } else if (role == kUserRoleTeacher) {
//        [[UserSession sharedInstance] setCurrentRole:kUserRoleStudent];
//    }
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
