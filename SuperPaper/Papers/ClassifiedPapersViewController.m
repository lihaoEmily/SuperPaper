//
//  ClassifiedPapersViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ClassifiedPapersViewController.h"

@interface ClassifiedPapersViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ClassifiedPapersViewController
{
    UITableView *_tableView;
    NSArray *_paperArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    [self setupUI];
}

- (void)getData
{
    NSDictionary *parameters = @{@"type_id":[NSNumber numberWithInt:[self.type_id intValue]], @"start_pos":[NSNumber numberWithInt:0], @"list_num":[NSNumber numberWithInt:15], @"paper_tagid":@""};
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

- (void)setupUI
{
    [self setupTitleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
        });
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)setupTitleView
{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 44)];
//    titleView.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.titleView = titleView;
//    UIButton 
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
    NSLog(@"%@",[[_paperArray objectAtIndex:indexPath.row] valueForKey:@"description"]);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
