//
//  ClassifiedPapersViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ClassifiedPapersViewController.h"
#import "PapersSearchViewController.h"
#import "ExportableWebViewController.h"
#define SEARCHPAGESIZE 30

@interface ClassifiedPapersViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClassifiedPapersViewController
{
    UITableView *_tableView;
    NSArray *_paperArray;
    
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 下拉加载header
    MJRefreshNormalHeader *header;
    
    /// 上拉刷新footer
    MJRefreshAutoNormalFooter *footer;
    
    /// 当前数据页数
    NSInteger _linePageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _linePageIndex = 0;
    [self getData];
    [self setupUI];
}

- (void)getData
{
    NSDictionary *parameters = @{@"type_id":[NSNumber numberWithInt:[self.type_id intValue]], @"start_pos":[NSNumber numberWithInt:(int)(SEARCHPAGESIZE * _linePageIndex)], @"list_num":[NSNumber numberWithInt:SEARCHPAGESIZE], @"paper_tagid":@""};
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_list.php",BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [dataDic objectForKey:@"list"];
               _paperArray = listData;
               _tableView.delegate = self;
               _tableView.dataSource = self;
               [_tableView reloadData];
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

// 加载前一页数据
- (void)loadPrePageData
{
    if (_linePageIndex > 0) {
        --_linePageIndex;
    }
    [self getData];
    [_tableView.mj_header endRefreshing];
}

// 加载后一页数据
- (void)loadNextPageData
{
    ++_linePageIndex;
    [self getData];
    [_tableView.mj_footer endRefreshing];
}

- (void)setupUI
{
    [self setupTitleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    // 下拉刷新
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPrePageData];
    }];
    
    // 上拉加载
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadNextPageData];
    }];
}

- (void)setupTitleView
{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 44)];
//    titleView.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.titleView = titleView;
//    UIButton
    
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 80, 100, 20)];
    dataLabel.text = [[[[_paperArray objectAtIndex:indexPath.row] valueForKey:@"createdate"] componentsSeparatedByString:@" "] objectAtIndex:0];
    dataLabel.textAlignment = NSTextAlignmentRight;
    dataLabel.font = [UIFont systemFontOfSize:12.0];
    dataLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dataLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExportableWebViewController *vc = [[ExportableWebViewController alloc] init];
    vc.title = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    vc.urlString = @"http://www.baidu.com";
    /**
     * 跳转页面
     */
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}

@end
