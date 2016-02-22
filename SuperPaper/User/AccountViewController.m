//
//  AccountViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/18.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "VoucherIntroViewController.h"
#import "UserSession.h"
#import "UIImageView+WebCache.h"
@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_list;
    NSInteger _total_num;
    NSInteger _valid_num;
    NSString *_intro;
    UIActivityIndicatorView *_webIndicator;
    
}
@property (weak, nonatomic) IBOutlet UIButton *voucherIntroBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

static NSString *const AccountCellIdentifier = @"AccountCell";
@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _list = [NSMutableArray array];
    _intro = @"";
    [self.voucherIntroBtn setTitleColor:[AppConfig appNaviColor] forState:UIControlStateNormal];
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
    [self pullData];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
}
//MARK: Helper
- (void) pullData
{
    NSString *urlString = [NSString stringWithFormat:@"%@mycoupon.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            if ([responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                _list = [responseObject[@"list"]mutableCopy];
            }
            _total_num = [responseObject[@"total_num"] integerValue];
            _valid_num = [responseObject[@"total_num_ok"] integerValue];
            if ([responseObject[@"coupon_info"]isKindOfClass:[NSString class]]) {
                _intro = responseObject[@"coupon_info"];
            }
            self.countLabel.text = [NSString stringWithFormat:@"有%lu张现金券可用",(long)_valid_num];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的账户信息出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
    }
}
- (void) pulldownRefresh
{
    NSString *urlString = [NSString stringWithFormat:@"%@mycoupon.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            if ([responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                _list = [responseObject[@"list"]mutableCopy];
            }
            _total_num = [responseObject[@"total_num"] integerValue];
            _valid_num = [responseObject[@"total_num_ok"] integerValue];
            if ([responseObject[@"coupon_info"]isKindOfClass:[NSString class]]) {
                _intro = responseObject[@"coupon_info"];
            }
            self.countLabel.text = [NSString stringWithFormat:@"有%lu张现金券可用",(long)_valid_num];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的账户信息出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
    }
}
- (void) pullupRefresh
{

    NSString *urlString = [NSString stringWithFormat:@"%@mycoupon.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID],@"start_pos":@(0),@"list_num":@(10)};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *result = responseObject[@"result"];
        if (0 == result.integerValue) {//获取我的消息列表成功
            if ([responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *list = responseObject[@"list"];
                
                if (_list.count + list.count < _total_num) {
                    [_list addObjectsFromArray:list];
                }else
                    _list = [responseObject[@"list"]mutableCopy];

            }
            _total_num = [responseObject[@"total_num"] integerValue];
            _valid_num = [responseObject[@"total_num_ok"] integerValue];
            if ([responseObject[@"coupon_info"]isKindOfClass:[NSString class]]) {
                _intro = responseObject[@"coupon_info"];
            }
            self.countLabel.text = [NSString stringWithFormat:@"有%lu张现金券可用",(long)_valid_num];
            [self.tableView reloadData];
        }else{//失败
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取我的账户信息出错" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
    }
}
- (IBAction)introduce:(id)sender {
    VoucherIntroViewController *vc = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"voucherintro"];
    vc.content = _intro;
    [self.navigationController pushViewController:vc animated:YES];
}

//MARK:Tableviewdatasource,Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    NSDictionary *dic = _list[indexPath.row];
    
    if (dic[@"picname"] != [NSNull null]) {
        NSString *imageName = dic[@"picname"];
        NSString *imageURL = [NSString stringWithFormat:@"%@%@",IMGURL,imageName];
        [cell.voucherImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
    }else{
        cell.voucherImageView.image = [UIImage imageWithASName:@"default_image" directory:@"common"];
    }
        
    if (0 == [dic[@"status"]integerValue]) {
        cell.statusImageView.hidden = NO;
        cell.statusImageView.image = [UIImage imageNamed:@"icon_voucher_used"];
    }else if(2 == [dic[@"status"] integerValue]){
        cell.statusImageView.hidden = NO;
        cell.statusImageView.image = [UIImage imageNamed:@"icon_voucher_invalid"];
    }else
        cell.statusImageView.hidden = YES;
    if (_list.count - 1 == indexPath.row) {
        cell.seperatorLine.hidden = YES;
    }else
        cell.seperatorLine.hidden = NO;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _list[indexPath.row];
    NSInteger status = [dic[@"status"] integerValue];
    if (0 == status) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"该现金券已被使用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }else if(1 == status){
        
        NSString *urlString = [NSString stringWithFormat:@"%@usecoupon.php",BASE_URL];
        NSDictionary *params = @{@"id":dic[@"id"]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"现金券使用成功！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"现金券使用失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        if (!_webIndicator.isAnimating) {
            [_webIndicator startAnimating];
            [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
        }
    }else if(2 == status){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"该现金券已被冻结" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
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
