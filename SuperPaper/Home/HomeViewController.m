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
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *studyTableView;
@end

@implementation HomeViewController{
    // 返回主页资讯数据
    NSMutableArray *_responseNewsInfoArr;
    NSMutableArray *_responseActivityInfoArr;
    // 返回广告信息数据
    NSArray *_responseAdInfoArr;
    BOOL isNews;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //TODO: for testing
//    [self viewTest];
    isNews = YES;
    [self initData];
    
    [self getHomePageNewsInfo];
    [self getStudyPageAdInfo];
}

- (void)initData {
    
    _studyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, OWIDTH,self.view.bounds.size.height-64-49) style:UITableViewStylePlain];
    _studyTableView.dataSource = self;
    _studyTableView.delegate = self;
    _studyTableView.sectionHeaderHeight = 10;
    _studyTableView.sectionFooterHeight = 10;
    [self.view addSubview:_studyTableView];
    
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
     ** parameters 参数
     * ownertype  整型    2：学生
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:(int)_responseNewsInfoArr.count],@"start_pos",[NSNumber numberWithInt:15],@"list_num",@"1",@"ownertype", nil];
    NSLog(@"parameters %@",parameters);
    NSString *urlString = [NSString stringWithFormat:@"%@homepage_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//获取首页资讯接口
- (void)getHomePageActivityInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置返回类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    /**
     ** parameters 参数
     * ownertype  整型    1:教师主页，2：学生主页
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSDictionary *parameters = @{@"ownertype":@"1", @"start_pos":[NSNumber numberWithInt:(int)_responseActivityInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSLog(@"parameters %@",parameters);
    NSString *urlString = [NSString stringWithFormat:@"%@homepage_activityinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseActivityInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


//获取广告信息
- (void)getStudyPageAdInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    1：学习主页
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1]};
    NSString *urlString = [NSString stringWithFormat:@"%@getadinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"POST %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _responseAdInfoArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        NSLog(@"responseObject %@",responseObject);
        [_studyTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
    }];
}

#pragma mark - 活动图片点击事件
- (void)serviceBtnClick:(UIButton *)button{
    switch (button.tag) {
        case 100:{
            button.selected = !button.selected;
            isNews = YES;
            [self getHomePageNewsInfo];
        }
            break;
        case 101:{
            button.selected = !button.selected;
            isNews = NO;
            [self getHomePageActivityInfo];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        
        static NSString *ID = @"Cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        
        
        //采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in _responseAdInfoArr) {
            NSString *iamgeURL = [NSString stringWithFormat:@"%@%@",IMGURL,[dic valueForKey:@"adpicname"]];
            
            
            [imagesURLStrings addObject:iamgeURL];
        }
        
        // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        // 网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) delegate:self placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
        
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        [cell.contentView addSubview:cycleScrollView];
        
        //         --- 模拟加载延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        });
        
        
        return cell;
    }
    else if (1 == indexPath.section) {
        
        static NSString *ID = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSArray *nameArray = [NSArray arrayWithObjects:@"新闻",@"活动", nil];
        for (int i = 0; i < nameArray.count; i ++) {
            UIButton *serviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            serviceBtn.frame = CGRectMake((i%2)*OWIDTH/2, (i/3)*OWIDTH/2, OWIDTH/2, 60);
            serviceBtn.tag = i+100;
            serviceBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:241.0/255.0f alpha:1].CGColor;
            serviceBtn.layer.borderWidth = 1;
            [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [serviceBtn setTitle:nameArray[i] forState:UIControlStateNormal];
            if (isNews) {
                if (i==0) {
                    serviceBtn.selected = YES;
                    serviceBtn.backgroundColor = kSelColor;
                }
                if (i==1){
                    serviceBtn.selected = NO;
                    serviceBtn.backgroundColor = [UIColor whiteColor];
                }
            }
            else{
                if (i==0) {
                    serviceBtn.selected = NO;
                    serviceBtn.backgroundColor = [UIColor whiteColor];
                }
                if (i==1){
                    serviceBtn.selected = YES;
                    serviceBtn.backgroundColor = kSelColor;
                }
            }
            
            [cell.contentView addSubview:serviceBtn];
        }
        
        return cell;
    }
    else {
        
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
            
            NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  urlString,@"image",
                                  [[_responseActivityInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"],@"title", nil];
            
            cell.infoDict = dict;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ((0 == section) || (1 == section)) {
        
        return 1;
    }
    else
    {
        if (isNews) {
            return _responseNewsInfoArr.count;
        }
        else{
            return _responseActivityInfoArr.count;
        }
        
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        return 180;
    }
    else if (1 == indexPath.section) {
        return  60;
    }
    else {
        if (isNews) {
            return 70;
        }else{
            return 120;
        }
    }
    return 70;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section) {
        NormalWebViewController *vc = [[NormalWebViewController alloc]init];

        if (isNews) {
            vc.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
            vc.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
        }
        else{
            vc.title = [[_responseActivityInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
            vc.urlString = [[_responseActivityInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
        }
        
        /**
         * 跳转页面
         */
        [AppDelegate.app.nav pushViewController:vc animated:YES];
        
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
