//
//  PublicationSortsViewController.m
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSortsViewController.h"
#import "PublicationSearchViewController.h"

@interface PublicationSortsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@end

@implementation PublicationSortsViewController
{
    NSMutableArray *_sortData;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _sortData = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *searhImage = [UIImage imageNamed:@"searchImage"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 40, 25);
    [searchBtn setImage:searhImage forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchPublication:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    [self setUpTableView];
    [self getData];
}

- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-36, SCREEN_WIDTH, SCREEN_HEIGHT+8)
                                                 style:UITableViewStyleGrouped ];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh];
    }];
    [self.view addSubview:self.tableView];

}

-(void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.groupId],@"groupid",nil];
    NSString *urlString =  [NSString stringWithFormat:@"%@confer_tag.php",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress* _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask* _Nonnull task, id  _Nullable responseObject) {
           NSDictionary* dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           if (dataDic) {
               NSArray* listData = [dataDic objectForKey:@"list"];
                _sortData = [NSMutableArray arrayWithArray:listData];
               NSDictionary* firstDic = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"tagname",@"",@"id",nil];
               [_sortData insertObject:firstDic atIndex:0];
               self.tableView.delegate = self;
               self.tableView.dataSource = self;
               [self.tableView reloadData];
        }
       } failure:^(NSURLSessionDataTask* _Nullable task, NSError* _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

- (void)pulldownRefresh
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.groupId],@"groupid",nil];
    NSString *urlString =  [NSString stringWithFormat:@"%@confer_tag.php",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           if (dataDic) {
               NSArray* listData = [dataDic objectForKey:@"list"];
               if (listData && listData.count > 0) {
                   [_sortData removeAllObjects];
                   [_sortData addObjectsFromArray:listData];
                   NSDictionary* firstDic = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"tagname",@"",@"id",nil];
                   [_sortData insertObject:firstDic atIndex:0];
                   self.tableView.delegate = self;
                   self.tableView.dataSource = self;
                   [self.tableView reloadData];
                   [self.tableView.mj_header endRefreshing];
               }
           }
       } failure:^(NSURLSessionDataTask* _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
           [self.tableView.mj_header endRefreshing];
       }];
}

- (void) searchPublication :(id) sender{
    PublicationSearchViewController *vc = [[PublicationSearchViewController alloc] init];
    vc.groupId = self.groupId;
    
    if (self.groupId == 2) {
        vc.title = @"出版社搜索";
    }
    else{
        vc.title = @"刊物搜索";
    }
    
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}

#pragma -mark tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _sortData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"SortCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[_sortData objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    cell.textLabel.textColor = [UIColor blackColor];
    if (_tagId == [[[_sortData objectAtIndex: indexPath.row] objectForKey:@"id"]integerValue]) {
        cell.textLabel.textColor = [AppConfig appNaviColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma -mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tagId = [[[_sortData objectAtIndex: indexPath.row] objectForKey:@"id"]integerValue];

    [self.delegate searchByTagid:_tagId];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
