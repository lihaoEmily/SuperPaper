//
//  NormalAssessmentViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/21.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalAssessmentViewController.h"
#import "HomeNewsCell.h"
#import "NormalWebViewController.h"
#import "HomeDetailController.h"
#import "ExportableWebViewController.h"

@interface NormalAssessmentViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  加载进度
 */
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;
/**
 *  数据总数
 */
@property (nonatomic, assign) NSInteger totalCountOfItems;

/**
 *  是否正在请求
 */
@property (nonatomic, assign) BOOL isRequiring;
@end

@implementation NormalAssessmentViewController
{
    UITableView *_jobTableView;
    NSMutableArray *_responseNewsInfoArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _responseNewsInfoArr = [[NSMutableArray alloc] init];
    
    [self setupUI];
    [self getJobNewsInfo];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI搭建
- (void)setupUI
{
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(SCREEN_WIDTH / 2 - 15, SCREEN_HEIGHT / 2 - 15, 30, 30);
    [_indicatorView startAnimating];
    [self.view addSubview:_indicatorView];
    
    _jobTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT)];
    _jobTableView.dataSource = self;
    _jobTableView.delegate = self;
    _jobTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_jobTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_jobTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_jobTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_jobTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:_jobTableView];
    
    // 下拉刷新
    _jobTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
//    _jobTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self pullUpPageData];
//    }];
    _jobTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ;
    }];
}

// 下拉刷新
- (void)pullDownPageData
{
    [_responseNewsInfoArr removeAllObjects];
    [self getJobNewsInfo];
    [_jobTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    
    [self getJobNewsInfo];
    [_jobTableView.mj_footer endRefreshing];
}

#pragma mark - AFnetworking 网络数据请求
//获取评职主页资讯
- (void)getJobNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    固定值 1:
     * group_id   整型    19:公务员，20：事业单位，21：国企单位，22：外企，23：民营，24：兼职
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInteger:self.group_id], @"start_pos":[NSNumber numberWithInt:(int)_responseNewsInfoArr.count], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        self.isRequiring = YES;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.isRequiring = NO;
        [_indicatorView stopAnimating];
        [_indicatorView setHidden:YES];
        NSInteger num = [responseObject[@"total_num"] integerValue];
        self.totalCountOfItems = num;
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_jobTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        self.isRequiring = NO;
    }];
    self.isRequiring = YES;
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _responseNewsInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Incell";
    HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_responseNewsInfoArr.count == 0) {
        return cell;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
    NSString *timeString = [[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] substringToIndex:10];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: urlString, @"image", [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"], @"title", timeString, @"time", nil];
    cell.infoDict = dict;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = [indexPath row];
    NSInteger currentCountOfItems = [_responseNewsInfoArr count];
    NSLog(@"----> rowIndex=%ld, currentCountOfItems=%ld, totalCountOfItems=%ld",(long)rowIndex, (long)currentCountOfItems, (long)self.totalCountOfItems);
    if (currentCountOfItems < self.totalCountOfItems) {
        NSInteger visibleCountOfItems = [[tableView visibleCells] count];
        NSInteger offsetCountOfItems = rowIndex + visibleCountOfItems/2 + 1;
        NSLog(@"----> OffsetCountOfItems = %ld", (long)offsetCountOfItems);
        if (self.isRequiring == NO && offsetCountOfItems >= currentCountOfItems) {
            NSLog(@"----> Load more data");
            [self pullUpPageData];
        }
    } else {
        NSLog(@"----> CurrentCountOfItems >= TotalCountOfItems");
        //        [_studyTableView.mj_footer endRefreshing];
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NormalWebViewController *normalWebVC = [[NormalWebViewController alloc]init];
//    normalWebVC.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
//    normalWebVC.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
    
    NSString *title  = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
    NSString *urlStr = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
    UIViewController *viewController = nil;
    if (urlStr.length > 1) {
        NormalWebViewController *vc = [[NormalWebViewController alloc]init];
        vc.title = title;
        vc.urlString = urlStr;
        viewController = vc;
    } else {
        HomeDetailController *vc = [[HomeDetailController alloc] init];
        vc.title = title;
        vc.passId = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"id"];
        vc.isNews = YES;
        viewController = vc;
    }
    
    [AppDelegate.app.nav pushViewController:viewController animated:YES];
}

@end
