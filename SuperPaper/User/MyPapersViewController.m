//
//  MyPapersViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MyPapersViewController.h"
#import "MyPapersTableViewCell.h"
#import "ReadMyPapersViewController.h"
#import "UserSession.h"

@interface MyPapersViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_list;
    NSInteger _total_num;
    UIActivityIndicatorView *_webIndicator;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *const MyPapersIdentifier = @"MyPaper";
@implementation MyPapersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = @[];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = [NSString stringWithFormat:@"%@mypaper_list.php",BASE_URL];
    NSDictionary *params = @{@"uid":@([UserSession sharedInstance].currentUserID),@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {//获取我的论文列表成功
                if ([responseObject[@"total_num"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                    _total_num = [responseObject[@"total_num"] integerValue];
                    
                }
                
                _list = responseObject[@"list"];
                [self.tableView reloadData];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的论文列表失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
        }
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    }];
    [_webIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
}


//MARK: TableviewDatasource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPapersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPapersIdentifier];
    NSDictionary *dic = _list[indexPath.row];
    cell.titleLabel.text = dic[@"title"];
    cell.timeLabel.text = [dic[@"createdate"]componentsSeparatedByString:@" "][0];
    if (_list.count - 1 == indexPath.row) {
        cell.seperatorLine.hidden = YES;
    }else
        cell.seperatorLine.hidden = NO;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    ReadMyPapersViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"readmypapers"];
    vc.paperTitle = dic[@"title"];
    vc.dateString = dic[@"createdate"];
    vc.content = dic[@"description"];
    vc.paperID = dic[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
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
