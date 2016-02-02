//
//  InvitationsViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "InvitationsViewController.h"
#import "InvitationsTableViewCell.h"
#import "UserSession.h"
#import "AppConfig.h"

@interface InvitationsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_list;
    NSInteger _total_num;
    BOOL _showFriend;
    UIActivityIndicatorView *_webIndicator;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *myFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;

@end

static NSString *const InvitationIdentifier = @"Invitation";
@implementation InvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [NSMutableArray array];
    _showFriend = YES;
    self.topView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.topView.layer.borderWidth = 1.5;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullupRefresh];
    }];
    
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
    if (_showFriend) {//当前在我的朋友标签下
        [self getInvitationsListFromWeb];
    }
}
- (IBAction)showMyFriends:(id)sender {
    if (!_showFriend) {
        _showFriend = !_showFriend;
        [self.myFriendBtn setBackgroundColor:[AppConfig appNaviColor]];
        [self.myFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shareBtn setBackgroundColor:[UIColor whiteColor]];
        [self.shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self getInvitationsListFromWeb];
        self.tableView.hidden = NO;
    }
}
- (IBAction)iwanttoshare:(id)sender {
    if (_showFriend) {
        _showFriend = !_showFriend;
        [self.shareBtn setBackgroundColor:[AppConfig appNaviColor]];
        [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myFriendBtn setBackgroundColor:[UIColor whiteColor]];
        [self.myFriendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.tableView.hidden = YES;
    }
}

//MARK:Helper
- (void) pulldownRefresh
{
    NSString *urlString = [NSString stringWithFormat:@"%@myinvite.php",BASE_URL];
    NSDictionary *params = @{@"myinvite_code":[UserSession sharedInstance].currentUserInviteCode,@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {//获取我的邀请列表成功
                if ([responseObject[@"total_num"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                    _total_num = [responseObject[@"total_num"] integerValue];
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%lu人",_total_num];
                }
                _list = [responseObject[@"list"]mutableCopy];
                [self.tableView reloadData];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的邀请列表失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
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
    NSString *urlString = [NSString stringWithFormat:@"%@myinvite.php",BASE_URL];
    NSDictionary *params = @{@"myinvite_code":[UserSession sharedInstance].currentUserInviteCode,@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {//获取我的邀请列表成功
                if ([responseObject[@"total_num"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                    _total_num = [responseObject[@"total_num"] integerValue];
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%lu人",_total_num];
                }
                
                NSArray *list = responseObject[@"list"];
                
                if (_list.count + list.count < _total_num) {
                    [_list addObjectsFromArray:list];
                }else
                    _list = [responseObject[@"list"]mutableCopy];
                [self.tableView reloadData];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的邀请列表失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
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
- (void) getInvitationsListFromWeb
{
    NSString *urlString = [NSString stringWithFormat:@"%@myinvite.php",BASE_URL];
    NSDictionary *params = @{@"myinvite_code":[UserSession sharedInstance].currentUserInviteCode,@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {//获取我的邀请列表成功
                if ([responseObject[@"total_num"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                    _total_num = [responseObject[@"total_num"] integerValue];
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%lu人",_total_num];
                }
                
                _list = [responseObject[@"list"]mutableCopy];
                [self.tableView reloadData];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的邀请列表失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
//MARK:TableViewDataSource, Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvitationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InvitationIdentifier];
    NSDictionary *dic = _list[indexPath.row];
    NSString *userName = dic[@"username"];
    NSString *dotString = @"";
    for (int i = 0; i < userName.length - 6; i++) {
        dotString = [dotString stringByAppendingString:@"*"];
    }
    
    cell.idLabel.text = [[[userName substringToIndex:3]stringByAppendingString:dotString]stringByAppendingString:[userName substringFromIndex:userName.length - 3]];
    cell.progressLabel.text = dic[@"status"];
    NSString *timeString = dic[@"createdate"];
    cell.timeLabel.text = [timeString componentsSeparatedByString:@" "][0];
    if (_list.count - 1 == indexPath.row) {
        cell.seperatorLine.hidden = YES;
    }else
        cell.seperatorLine.hidden = NO;
    return cell;
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
