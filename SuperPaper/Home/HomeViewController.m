//
//  HomeViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "HomeViewController.h"
#import "NormalWebViewController.h"
#import "ExportableWebViewController.h"
#import "HomeNewsCell.h"
#import "HomeActivityCell.h"
#import "ASShare.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSDictionary *dict;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //TODO: for testing
    [self viewTest];
//    [self loadUI];
}

/**
 *  测试显示网页
 */
- (void)viewTest {
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
    [btnWeb setTitle:@"ShareSDK" forState:UIControlStateNormal];
    [btnWeb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnWeb];
    [btnWeb addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //TODO:for texting
    UIButton *btnWebExp = [[UIButton alloc] initWithFrame:CGRectMake(216,64,100, 100)];
    btnWebExp.backgroundColor = kSelColor;
    btnWebExp.tag = 102;
    [btnWebExp setTitle:@"导出网页" forState:UIControlStateNormal];
    [btnWebExp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnWebExp];
    [btnWebExp addTarget:self
                  action:@selector(buttonAction:)
        forControlEvents:UIControlEventTouchUpInside];
}

-(void)loadUI{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    dict = @{@"image":@"http://pic1.nipic.com/2008-08-12/200881211331729_2.jpg",@"title":@"最美高校老师系列推选活动结果巩个",@"time":@"2016-1-16"};
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *cellName = @"cellName";
    HomeActivityCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil)
    {
        cell = [[HomeActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellName];
    }

    cell.infoDict = dict;
    return cell;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
//            NormalWebViewController *vc = [[NormalWebViewController alloc] init];
//            vc.title = @"网页展示";
//            vc.urlString = @"http://www.baidu.com";
//            /**
//             * 跳转页面
//             */
//            [AppDelegate.app.nav pushViewController:vc animated:YES];
            [ASShare commonShareWithData:nil];
            break;
        }
        case 102:
        {
            ExportableWebViewController *vc = [[ExportableWebViewController alloc] init];
            vc.title = @"导出网页展示";
            vc.urlString = @"http://www.baidu.com";
            /**
             * 跳转页面
             */
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
