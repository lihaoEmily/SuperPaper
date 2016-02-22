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
#import "SDCycleScrollView.h"
#import "ServiceButton.h"
#import "HomeDetailController.h"
#import "TAPageControl.h"

@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *studyTableView;
@end

@implementation HomeViewController{
    // 返回主页资讯数据
    NSMutableArray *_responseNewsInfoArr;
    // 返回主页活动数据
    NSMutableArray *_responseActivityInfoArr;
    // 返回广告信息数据
    NSArray *_responseAdInfoArr;
    
    NSMutableArray *imagesURLString;
    SDCycleScrollView *cycleScrollView;
    UIView *headerView;
    BOOL isNews;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    isNews = YES;
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullDownPageData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initData {
    
    _studyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT)
                                                  style:UITableViewStylePlain];
    _studyTableView.dataSource = self;
    _studyTableView.delegate = self;
    _studyTableView.sectionHeaderHeight = 10;
    _studyTableView.sectionFooterHeight = 10;
    [self.view addSubview:_studyTableView];
    [self creatHeaderView];
    if ([_studyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_studyTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_studyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_studyTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    //变量初始化
    
    _responseNewsInfoArr = [[NSMutableArray alloc]init];
    _responseActivityInfoArr = [[NSMutableArray alloc]init];
    
    // 下拉刷新
    _studyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
    _studyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullUpPageData];
    }];
    
}

// 下拉刷新
- (void)pullDownPageData
{
    if (isNews) {
        [_responseNewsInfoArr removeAllObjects];
        [self getHomePageNewsInfo];
    }
    else{
        [_responseActivityInfoArr removeAllObjects];
        [self getHomePageActivityInfo];
    }
    
    if (imagesURLString) {
        [imagesURLString removeAllObjects];
    }
    [self getHomePageAdInfo];
    
    [_studyTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    if (isNews) {
        [self getHomePageNewsInfo];
    }
    else{
        [self getHomePageActivityInfo];
    }
    
    [_studyTableView.mj_footer endRefreshing];
}

#pragma mark - Afnetworking 网络数据请求
//获取首页资讯接口
- (void)getHomePageNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    /**
     * parameters 参数
     * ownertype  整型    1:老师主页，2：学生主页
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)_responseNewsInfoArr.count],@"start_pos",[NSNumber numberWithInt:15],@"list_num",[NSNumber numberWithInteger:ownerType],@"ownertype", nil];
    
    // NSLog(@"parameters %@",parameters);
    
    NSString *urlString = [NSString stringWithFormat:@"%@homepage_newsinfo.php",BASE_URL];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        //  NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]] isEqualToString:@"0"]) {
            NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            [_responseNewsInfoArr addObjectsFromArray:myArr];
            [_studyTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
//获取首页活动接口
- (void)getHomePageActivityInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    /**
     * parameters 参数
     * ownertype  整型    1:老师主页，2：学生主页
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInteger:ownerType], @"start_pos":[NSNumber numberWithInt:(int)_responseActivityInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@homepage_activityinfo.php",BASE_URL];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]] isEqualToString:@"0"]) {
            NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            [_responseActivityInfoArr addObjectsFromArray:myArr];
            [_studyTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


//获取广告信息
- (void)getHomePageAdInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters 参数
     * ownertype  整型
     */
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:ownerType]};
    NSString *urlString = [NSString stringWithFormat:@"%@getadinfo.php",BASE_URL];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]] isEqualToString:@"0"]) {
            _responseAdInfoArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            NSMutableArray *imageUrls = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in _responseAdInfoArr) {
                NSString *iamgeURL = [NSString stringWithFormat:@"%@%@",IMGURL,[dic valueForKey:@"adpicname"]];
                [imageUrls addObject:iamgeURL];
            }
            imagesURLString = imageUrls;
            SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 164) delegate:self placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
            cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"circle_select"];
            cycleScrollView3.pageDotImage = [UIImage imageNamed:@"circle"];
            cycleScrollView3.imageURLStringsGroup = imagesURLString;
            
            [headerView addSubview:cycleScrollView3];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - 活动图片点击事件
- (void)serviceBtnClick:(UIButton *)button{
    button.selected = !button.selected;
    switch (button.tag) {
        case 101:{
            [button setImage:[UIImage imageNamed:@"activity_select"]
                    forState:UIControlStateNormal];
            UIButton *btn = (UIButton *)[self.view viewWithTag:100];
            [btn setImage:[UIImage imageNamed:@"news"]
                 forState:UIControlStateNormal];
            UIView *view = (UIView *)[self.view viewWithTag:201];
            view.hidden = NO;
            UIView *view1 = (UIView *)[self.view viewWithTag:200];
            view1.hidden = YES;
            isNews = NO;
            if (_responseActivityInfoArr.count > 0) {
                [_studyTableView reloadData];
            }
            else{
                [self getHomePageActivityInfo];
            }
        }
            break;
        case 100:{
            [button setImage:[UIImage imageNamed:@"news_select"]
                    forState:UIControlStateNormal];
            UIButton *btn = (UIButton *)[self.view viewWithTag:101];
            [btn setImage:[UIImage imageNamed:@"activity"]
                 forState:UIControlStateNormal];
            UIView *view = (UIView *)[self.view viewWithTag:200];
            view.hidden = NO;
            UIView *view1 = (UIView *)[self.view viewWithTag:201];
            view1.hidden = YES;
            isNews = YES;
            if (_responseNewsInfoArr.count > 0) {
                [_studyTableView reloadData];
            }
            else{
                [self getHomePageNewsInfo];
            }
        }
            break;
        default:
            break;
    }
}

-(void)creatHeaderView
{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 218)];
    [headerView setBackgroundColor:kColor(236, 236, 236)];
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 164) delegate:self placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cycleScrollView.frame) + 4, SCREEN_WIDTH, 0.5)];
    grayView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:grayView];
    NSArray *nameArray = [NSArray arrayWithObjects:@"新闻",@"活动", nil];
    for (int i = 0; i < nameArray.count; i ++) {
        UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        serviceBtn.frame = CGRectMake(i*SCREEN_WIDTH/2, CGRectGetMaxY(cycleScrollView.frame), SCREEN_WIDTH/2, 52);
        serviceBtn.tag = i+100;
        serviceBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:241.0/255.0f alpha:1].CGColor;
        serviceBtn.layer.borderWidth = 0;
        [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [serviceBtn addTarget:self
                       action:@selector(serviceBtnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:serviceBtn];
        
        UIView *pinkView = [[UIView alloc]init];
        pinkView.backgroundColor = kColor(250, 0, 89);
        [headerView addSubview:pinkView];
        pinkView.tag = i+200;
        if (i==0) {
            serviceBtn.selected = YES;
            //            [serviceBtn setImage:[UIImage imageNamed:@"news_select"]
            //                                  forState:UIControlStateSelected];
            [serviceBtn setImage:[UIImage imageNamed:@"news_select"]
                        forState:UIControlStateNormal];
            pinkView.frame = CGRectMake(10, CGRectGetMaxY(serviceBtn.frame)-5, (SCREEN_WIDTH-20)/2, 0.8);
            UIView *grayView_vertical = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serviceBtn.frame), CGRectGetMaxY(cycleScrollView.frame) + 20, 0.5, 16)];
            grayView_vertical.backgroundColor = [UIColor lightGrayColor];
            [headerView addSubview:grayView_vertical];
        }
        else{
            //            [serviceBtn setImage:[UIImage imageNamed:@"activity_select"]
            //                                  forState:UIControlStateSelected];
            [serviceBtn setImage:[UIImage imageNamed:@"activity"]
                        forState:UIControlStateNormal];
            pinkView.frame = CGRectMake(10+(SCREEN_WIDTH-20)/2, CGRectGetMaxY(serviceBtn.frame)-5, (SCREEN_WIDTH-20)/2, 0.8);
            pinkView.hidden = YES;
        }
    }
    _studyTableView.tableHeaderView = headerView;
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isNews) {
        static NSString *ID = @"Cell2";
        HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        if (_responseNewsInfoArr.count == 0) {
            return cell;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
        NSString *timeString = [[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] substringToIndex:10];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              urlString,@"image",
                              [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"],@"title",
                              timeString,@"time", nil];
        
        cell.infoDict = dict;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }
    else{
        static NSString *ID = @"Cell3";
        HomeActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[HomeActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        if (_responseActivityInfoArr.count == 0) {
            return cell;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseActivityInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              urlString,@"image",
                              [[_responseActivityInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"],@"title", nil];
        
        cell.infoDict = dict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        return cell;
    }
    return nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (isNews) {
        return _responseNewsInfoArr.count;
    }
    else{
        return _responseActivityInfoArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isNews) {
        return TABLE_CELL_HEIGHT;
    }else{
        return 150;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - UITableView Delgate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NormalWebViewController *vc = [[NormalWebViewController alloc]init];
    HomeDetailController *detailVC = [[HomeDetailController alloc]init];
    NSDictionary *dicNews = [_responseNewsInfoArr objectAtIndex:indexPath.row];
    NSString *strNews = [NSString stringWithFormat:@"%@",dicNews[@"url"]];
    if (isNews) {
        if (strNews.length > 0) {
            vc.title = [NSString stringWithFormat:@"%@",dicNews[@"title"]];
            vc.urlString = strNews;
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
        else{
            detailVC.passId = [NSString stringWithFormat:@"%@",dicNews[@"id"]];
            detailVC.title = [NSString stringWithFormat:@"%@",dicNews[@"title"]];
            detailVC.isNews = YES;
            [AppDelegate.app.nav pushViewController:detailVC animated:YES];
        }
    }
    else{
        NSDictionary *dicActivity = [_responseActivityInfoArr objectAtIndex:indexPath.row];
        NSString *strActivity = [NSString stringWithFormat:@"%@",dicActivity[@"url"]];
        if (strActivity.length > 0) {
            vc.title = [NSString stringWithFormat:@"%@",dicActivity[@"title"]];;
            vc.urlString = strActivity;
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
        else{
            detailVC.passId = [NSString stringWithFormat:@"%@",dicActivity[@"id"]];
            detailVC.title = [NSString stringWithFormat:@"%@",dicActivity[@"title"]];
            detailVC.isNews = NO;
            [AppDelegate.app.nav pushViewController:detailVC animated:YES];
        }
    }
    
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    NormalWebViewController *vc = [[NormalWebViewController alloc]init];
    vc.title = @"资讯";
    vc.urlString = [[_responseAdInfoArr objectAtIndex:index]valueForKey:@"url"];
    
    /**
     * 跳转页面
     */
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}


/**
 *  测试显示网页
 */
- (void)viewTest {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0,64,100, 100)];
    btn.backgroundColor = [AppConfig appNaviColor];
    btn.tag = 100;
    [btn setTitle:@"画面迁移" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self
            action:@selector(buttonAction:)
  forControlEvents:UIControlEventTouchUpInside];
    //TODO:for texting
    UIButton *btnWeb = [[UIButton alloc] initWithFrame:CGRectMake(108,64,100, 100)];
    btnWeb.backgroundColor = [AppConfig appNaviColor];
    btnWeb.tag = 101;
    [btnWeb setTitle:@"ShareSDK" forState:UIControlStateNormal];
    [btnWeb setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnWeb];
    [btnWeb addTarget:self
               action:@selector(buttonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    //TODO:for texting
    UIButton *btnWebExp = [[UIButton alloc] initWithFrame:CGRectMake(216,64,100, 100)];
    btnWebExp.backgroundColor = [AppConfig appNaviColor];
    btnWebExp.tag = 102;
    [btnWebExp setTitle:@"导出网页" forState:UIControlStateNormal];
    [btnWebExp setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btnWebExp];
    [btnWebExp addTarget:self
                  action:@selector(buttonAction:)
        forControlEvents:UIControlEventTouchUpInside];
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
