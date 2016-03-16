//
//  NormalStudyViewController.m
//  SuperPaper
//
//  Created by wangli on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalStudyViewController.h"
#import "HomeNewsCell.h"
#import "NormalWebViewController.h"
#import "TextWebViewController.h"
#import "HomeDetailController.h"

//#define KAppWidth [UIScreen mainScreen].bounds.size.width
//#define KAppHeight [UIScreen mainScreen].bounds.size.height

@interface NormalStudyViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  数据总数
 */
@property (nonatomic, assign) NSInteger totalCountOfItems;

/**
 *  是否正在请求
 */
@property (nonatomic, assign) BOOL isRequiring;
@property (nonatomic, assign) BOOL isDragging;
@end

@implementation NormalStudyViewController {
    UITableView *_studyTableView;
    NSMutableArray *_responseNewsInfoArr;
    int _type_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _studyTableView.delegate = self;
    _studyTableView.dataSource = self;
    
    if ([self.title isEqualToString:@"考研"]) {
        _type_id = 11;
    }
    else if ([self.title isEqualToString:@"留学"]) {
        _type_id = 12;
    }
    else if ([self.title isEqualToString:@"比赛"]) {
        _type_id = 13;
    }
    else if ([self.title isEqualToString:@"考证"]) {
        _type_id = 14;
    }
    else if ([self.title isEqualToString:@"计算机"]) {
        _type_id = 15;
    }
    else if ([self.title isEqualToString:@"大学46级"]) {
        _type_id = 16;
    }
    else if ([self.title isEqualToString:@"论文指导"]) {
        _type_id = 17;
    }
    else if ([self.title isEqualToString:@"作业指导"]) {
        _type_id = 18;
    }
    
    [self setUI];
    
    //获取学习情报
    [self getStudyNewsInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _studyTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height);
    
}

- (void)setUI {
    
    _studyTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _studyTableView.dataSource = self;
    _studyTableView.delegate = self;
    _studyTableView.sectionHeaderHeight = 10;
    _studyTableView.sectionFooterHeight = 10;
    
    if ([_studyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_studyTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_studyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_studyTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self.view addSubview:_studyTableView];
    
    //变量初始化
    _responseNewsInfoArr = [[NSMutableArray alloc]init];
    
    // 下拉刷新
    _studyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
//    _studyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self pullUpPageData];
//    }];
    _studyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ;
    }];
    
}

// 下拉刷新
- (void)pullDownPageData
{
    [_responseNewsInfoArr removeAllObjects];
    [self getStudyNewsInfo];
    
    [_studyTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{
    
    [self getStudyNewsInfo];
    
    [_studyTableView.mj_footer endRefreshing];
}

#pragma mark - AFnetworking 网络数据请求
//获取学习主页资讯
- (void)getStudyNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters 参数
     * ownertype  整型    固定值2:学习页
     * group_id   整型    10:刊物，11：考研，12：留学，13：比赛，14：考证，15：计算机，16：大学46级，17：论文指导，18：作业指导
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
    NSInteger startPos = [_responseNewsInfoArr count];
    NSLog(@"----> start position:%ld",(long)startPos);
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:2], @"group_id":[NSNumber numberWithInt:_type_id], @"start_pos":[NSNumber numberWithInteger:startPos], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@study_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        self.isRequiring = YES;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.isRequiring = NO;
        NSInteger num = [responseObject[@"total_num"] integerValue];
        self.totalCountOfItems = num;
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        self.isRequiring = NO;
    }];
    self.isRequiring = YES;
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"classifiCell";
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
    /**
    * 跳转页面
    */
    [AppDelegate.app.nav pushViewController:viewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _responseNewsInfoArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger rowIndex = [indexPath row];
    NSInteger currentCountOfItems = _responseNewsInfoArr.count;

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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isRequiring)
        return;
    self.isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!self.isRequiring && self.isDragging && scrollView.contentOffset.y < 0) {
//        [self headerViewDidScroll:scrollView.contentOffset.y < 0 - [self headerRefreshHeight]
//                       scrollView:scrollView];
//    } else if (!isLoadingMore && canLoadMore) {
//        CGFloat scrollPosition = scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y;
//        if (scrollPosition < [self footerLoadMoreHeight]) {
//            [self loadMore];
//        }
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    ;
}

@end
