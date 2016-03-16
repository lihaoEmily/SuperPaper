//
//  InvitationsViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "InvitationsViewController.h"
#import "InvitationsTableViewCell.h"

#import "ShareManage.h"
#import "UserSession.h"
#import "AppConfig.h"

@interface InvitationsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_list;
    NSInteger _total_num;
    BOOL _showFriend;
    UIActivityIndicatorView *_webIndicator;
    
    NSString *_shareUrlString;
    
}
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIView *shareTopView;
@property (weak, nonatomic) IBOutlet UIView *shareBottomView;
@property (weak, nonatomic) IBOutlet UILabel *shareContentLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *labelView;
@property (weak, nonatomic) IBOutlet UIButton *myFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *friendNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBtnCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondBtnCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBtnLeadingCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastBtnLeadingCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBtnWidthCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBtnHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomCaptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *pasteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqLabelBottomCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqBtnBottomCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqLabelHeightCon;
@property (weak, nonatomic) IBOutlet UILabel *bottomShareLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomSubBG;

@end

static NSString *const InvitationIdentifier = @"Invitation";
@implementation InvitationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [NSMutableArray array];
    _showFriend = YES;
    self.myFriendBtn.backgroundColor = [AppConfig appNaviColor];
    
    self.topView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.topView.layer.borderWidth = 1.5;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullupRefresh];
    }];

    // 以下是自定义分享view
    [[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:nil];
    self.shareView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *shareViewTopCon = [NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *shareViewLeadingCon = [NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *shareViewTrailingCon = [NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *shareViewBottomCon = [NSLayoutConstraint constraintWithItem:self.shareView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _shareUrlString = [NSString stringWithFormat:@"http://121.42.179.44/admin/invite/index/uid/%ld",(long)[UserSession sharedInstance].currentUserID];
    self.topLabel.text = [NSString stringWithFormat:@"我的邀请码：%@",[UserSession sharedInstance].currentUserInviteCode];
    self.shareTopView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.shareTopView.layer.borderWidth = 1;
    self.pasteBtn.backgroundColor = [AppConfig appNaviColor];
    [self.captionLabel setTextColor:[AppConfig appNaviColor]];
    [self.bottomCaptionLabel setTextColor:[AppConfig appNaviColor]];
    self.trailingCon.constant = self.leadingCon.constant;
    self.lastBtnLeadingCon.constant = self.firstBtnLeadingCon.constant;
    self.firstBtnCon.constant = (self.view.bounds.size.width - self.firstBtnLeadingCon.constant - self.lastBtnLeadingCon.constant - 4 * self.iconBtnWidthCon.constant - self.leadingCon.constant - self.trailingCon.constant) / 3;
    self.secondBtnCon.constant = self.firstBtnCon.constant;
    self.shareBottomView.layer.borderWidth = 1;
    self.shareBottomView.layer.borderColor = [AppConfig appNaviColor].CGColor;
    self.shareContentLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.shareContentLabel.layer.borderWidth = 0.5;

    self.shareContentLabel.text = [NSString stringWithFormat:@"立即注册超级论文，还可以【免费】得到10元现金券，机会难得，赶紧看看啊！下载链接：http://121.42.179.44/admin/invite/index/uid/%ld",(long)[UserSession sharedInstance].currentUserID];
    [self.view addSubview:self.shareView];
    [self.view addConstraints:@[shareViewTopCon,shareViewLeadingCon,shareViewTrailingCon,shareViewBottomCon]];
    self.shareView.hidden = YES;
    
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.qqLabelBottomCon.constant = (self.bottomSubBG.bounds.size.height - CGRectGetMaxY(self.bottomShareLabel.frame) - self.iconBtnHeightCon.constant - self.qqBtnBottomCon.constant - self.qqLabelHeightCon.constant) / 2;
}

- (IBAction)pasteUrl:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
//    pasteBoard.string = _shareUrlString;
    pasteBoard.string = self.shareContentLabel.text;
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"已复制到剪切板" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}
- (IBAction)shareToSocailPlatform:(UIButton *)sender {
    [self shareBtnClickWithIndex:sender.tag];
}
- (IBAction)showMyFriends:(id)sender {
    if (!_showFriend) {
        _showFriend = !_showFriend;
        [self.myFriendBtn setBackgroundColor:[AppConfig appNaviColor]];
        [self.myFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shareBtn setBackgroundColor:[UIColor whiteColor]];
        [self.shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.friendNumLabel setTextColor:[UIColor whiteColor]];
        [self getInvitationsListFromWeb];
        self.tableView.hidden = NO;
        self.labelView.hidden = NO;
        self.shareView.hidden = YES;
    }
}
- (IBAction)iwanttoshare:(id)sender {
    if (_showFriend) {
        _showFriend = !_showFriend;
        [self.shareBtn setBackgroundColor:[AppConfig appNaviColor]];
        [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.myFriendBtn setBackgroundColor:[UIColor whiteColor]];
        [self.myFriendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.friendNumLabel setTextColor:[UIColor blackColor]];
        self.tableView.hidden = YES;
        self.labelView.hidden = YES;
        self.shareView.hidden = NO;

    }
}

//MARK: ShareCustomDelegate
- (void)shareBtnClickWithIndex:(NSInteger)tag
{
    NSString *title = @"更多精彩内容尽在[超级论文]";
    NSString *text = self.shareContentLabel.text;
    NSString *urlString = _shareUrlString;
    switch (tag) {
        case 1000:
            [[ShareManage shareManage] QQFriendsShareWithViewControll:self text:text urlString:urlString title:title];
            break;
        case 1001:
            [[ShareManage shareManage] QzoneShareWithViewControll:self text:text urlString:urlString title:title];
            break;
        case 1002:
            [[ShareManage shareManage] wxShareWithViewControll:self text:text urlString:urlString title:title];
            break;
        case 1003:
            [[ShareManage shareManage] wxpyqShareWithViewControll:self text:text urlString:urlString title:title];
            break;
            
        default:
            break;
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
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)_total_num];
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
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)_total_num];
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
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%ld人",(long)_total_num];
                }else{
                    self.friendNumLabel.text = [NSString stringWithFormat:@"%@人",responseObject[@"total_num"]];
                    _total_num = [self.friendNumLabel.text integerValue];
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
    if (userName.length < 6) {
        cell.idLabel.text = userName;
    }else{
        NSString *dotString = @"";
        for (int i = 0; i < userName.length - 6; i++) {
            dotString = [dotString stringByAppendingString:@"*"];
        }
        cell.idLabel.text = [[[userName substringToIndex:3]stringByAppendingString:dotString]stringByAppendingString:[userName substringFromIndex:userName.length - 3]];
    }
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
