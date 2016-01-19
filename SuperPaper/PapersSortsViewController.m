//
//  PapersSortsViewController.m
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersSortsViewController.h"

@interface PapersSortsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_sortData;
}
@end

@implementation PapersSortsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    _sortData = [NSArray array];
    [self setUpTableView];
    [self getData];

}
- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, OWIDTH, OHIGHT - 72) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];

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
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           if (dataDic) {
               NSArray * listData = [dataDic objectForKey:@"list"];
               _sortData = listData;
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
    cell.textLabel.text = [[_sortData objectAtIndex:indexPath.row] objectForKey:@"tagname"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;

}

#pragma -mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
