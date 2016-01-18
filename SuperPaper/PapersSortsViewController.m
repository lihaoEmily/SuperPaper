//
//  PapersSortsViewController.m
//  SuperPaper
//
//  Created by owenyao on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersSortsViewController.h"

@interface PapersSortsViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PapersSortsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self getData];

}
- (void)setUpTableView{

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, OWIDTH, OHIGHT - 72) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];

}

-(void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.typeId,@"type_id",nil];
    NSLog(@"%@",paramDic);
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_tag.php",BASE_URL];
    NSLog(@"%@",urlString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [dataDic objectForKey:@"list"];

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
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"SortCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;

}

#pragma -mark tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
