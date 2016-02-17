//
//  PapersSortsViewController.m
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersSortsViewController.h"
#import "PapersSearchViewController.h"

@interface PapersSortsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_sortData;
}
@end

@implementation PapersSortsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _sortData = [NSMutableArray array];
    [self setupTitleView];
    [self setUpTableView];
    [self getData];
    

}
- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,-36, SCREEN_WIDTH, SCREEN_HEIGHT - 36) style:UITableViewStyleGrouped ];
    [self.view addSubview:self.tableView];

}
- (void)setupTitleView
{
    UIImage *image = [UIImage imageNamed:@"searchImage"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 0, 25, 25);
    [searchBtn setImage:image forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchpPapers) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[searchItem];
}
- (void)searchpPapers
{
    PapersSearchViewController *papersSearchVC = [[PapersSearchViewController alloc] init];
    papersSearchVC.title = [NSString stringWithFormat:@"%@搜索",self.title];
    [AppDelegate.app.nav pushViewController:papersSearchVC animated:YES];
}

-(void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.typeId,@"type_id",nil];
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_tag.php",BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           if (responseObject) {
               NSArray * listData = [responseObject objectForKey:@"list"];
                _sortData = [NSMutableArray arrayWithArray:listData];
               NSDictionary * firstDic = [NSDictionary dictionaryWithObjectsAndKeys:@"全部",@"tagname",@"",@"id",nil];
               [_sortData insertObject:firstDic atIndex:0];
               self.tableView.delegate = self;
               self.tableView.dataSource = self;
               [self.tableView reloadData];
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];

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
    if ([self.tagId isEqualToString:[[_sortData objectAtIndex:indexPath.row] objectForKey:@"id"]]) {
        cell.textLabel.textColor = [AppConfig appNaviColor];
    }
    cell.textLabel.text = [[_sortData objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;

}

#pragma -mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate passTypeId:[[_sortData objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
