//
//  MyMessageViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "MyMessageViewController.h"
#import "MyMessageTableViewCell.h"
#import "ReadMyMessagesViewController.h"
#import "UserSession.h"
#import "NormalWebViewController.h"

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_list;
    NSInteger _total_num;
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *const MessageTableViewCellIdentifier = @"Message";
@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullupRefresh];
    }];
    _list = [NSMutableArray array];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;

    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pullData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: Helper
- (void) pullData
{
    NSString *urlString = [NSString stringWithFormat:@"%@mynotice.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@"0",@"list_num":@"10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            _list = [responseObject[@"list"]mutableCopy];
            _total_num = [responseObject[@"total_num"] integerValue];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的消息列表出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
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

- (void) pulldownRefresh
{
    NSString *urlString = [NSString stringWithFormat:@"%@mynotice.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@"0",@"list_num":@"10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            _list = [responseObject[@"list"]mutableCopy];
            _total_num = [responseObject[@"total_num"] integerValue];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的消息列表出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        [self.tableView.mj_header endRefreshing];
    }];
    [_webIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
}

- (void) pullupRefresh
{
    NSString *urlString = [NSString stringWithFormat:@"%@mynotice.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            NSArray *list = responseObject[@"list"];
            
            if (_list.count + list.count < _total_num) {
                [_list addObjectsFromArray:list];
            }else
                _list = [responseObject[@"list"]mutableCopy];
            
            _total_num = [responseObject[@"total_num"] integerValue];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的消息列表出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
        [self.tableView.mj_footer endRefreshing];
    }];
    [_webIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
}
//MARK: TableViewDatasource,delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    NSString *content = dic[@"content"];
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    NSString *totalString = @"";
    arr =  [content componentsSeparatedByString:@"-"];
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    for (NSString *str in marr) {
        totalString = [totalString stringByAppendingString:str];
    }
    CGFloat contentHeight = [totalString boundingRectWithSize:CGSizeMake(tableView.bounds.size.width - 28, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.height;
    return contentHeight + 21 + 21 + 16;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCellIdentifier];
    NSDictionary *dic = _list[indexPath.row];
    NSString *content = dic[@"content"];
    NSString *title = dic[@"title"];
    cell.timeLabel.text = dic[@"createdate"];
    
    cell.titleLabel.text = title;
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n"
                                                                                    options:0
                                                                                      error:nil];
    
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//替换所有html和换行匹配元素为"-"
    
    regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"-{1,}" options:0 error:nil] ;
    content=[regularExpretion stringByReplacingMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) withTemplate:@"-"];//把多个"-"匹配为一个"-"
    
    //根据"-"分割到数组
    NSArray *arr=[NSArray array];
    NSString *totalString = @"";
    arr =  [content componentsSeparatedByString:@"-"];
    NSMutableArray *marr=[NSMutableArray arrayWithArray:arr];
    [marr removeObject:@""];
    for (NSString *str in marr) {
        totalString = [totalString stringByAppendingString:str];
    }

    cell.detailsLabel.text = totalString;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    NSInteger messageID = [dic[@"id"]integerValue];
    NSString *title = dic[@"title"];
    NSString *content = dic[@"content"];
    NSString *urlString = dic[@"url"];

    NSLog(@"----> MessageID:%ld, ContentLengh:%ld",(long)messageID, (long)content.length);
    NormalWebViewController *vc = [[NormalWebViewController alloc]init];
    vc.title = title;
    vc.urlString = urlString;
    [AppDelegate.app.nav pushViewController:vc animated:YES];

//    ReadMyMessagesViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"readmymessage"];
//    vc.messageID = messageID;
//    vc.messageTitle = title;
//    vc.messageContent = content;
//    vc.urlString = urlString;
//    [self.navigationController pushViewController:vc animated:YES];

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
