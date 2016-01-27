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

@interface MyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_list;
    NSInteger _total_num;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

static NSString *const MessageTableViewCellIdentifier = @"Message";
@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[UIView new]];
    _list = @[];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = [NSString stringWithFormat:@"%@mynotice.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@"0",@"list_num":@"10"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            _list = responseObject[@"list"];
            _total_num = [responseObject[@"total_num"] integerValue];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的消息列表出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: TableViewDatasource,delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageTableViewCellIdentifier];
    NSDictionary *dic = _list[indexPath.row];
    NSString *content = dic[@"content"];
    NSString *title = dic[@"title"];
    cell.timeLabel.text = dic[@"createdate"];
    
    cell.titleLabel.text = title;
    cell.detailsLabel.text = content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    NSInteger messageID = [dic[@"id"]integerValue];
    NSString *title = dic[@"title"];
    NSString *content = dic[@"content"];
    ReadMyMessagesViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"readmymessage"];
    vc.messageID = messageID;
    vc.messageTitle = title;
    vc.messageContent = content;
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
