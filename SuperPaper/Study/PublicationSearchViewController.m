//
//  PublicationSearchViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSearchViewController.h"
#import "PublicationSearchTableViewCell.h"
#import "UserSession.h"
#import "PublicationIntroduceViewController.h"
#import "LoginViewController.h"

#define SEARCHPAGESIZE 15

@interface PublicationSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation PublicationSearchViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 搜索框
    UITextField *_searchBar;
    
    /// 返回数据
    NSMutableArray *_responseArr;
    
    /// 搜索table
    UITableView *_searchTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _responseArr = [[NSMutableArray alloc] init];
    [self setupUI];
}

#pragma mark - 网络请求
- (void)getData
{
    UserRole role = [UserSession sharedInstance].currentRole;
    NSNumber *ownertype = [NSNumber numberWithInt:role];
//    NSNumber *group_id;
//    if ([ownertype intValue] == 1) {
//        group_id = [NSNumber numberWithInt:1];
//    }else if ([ownertype intValue] == 2){
//        group_id = [NSNumber numberWithInt:10];
//    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     ** parameters 参数
     * ownertype  整型    1：老师  其他不明确
     * keywords   字符串  搜索的关键字
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     * group_id   整型    ownertype为1时,group_id为1表示刊物;ownertype为2时,group_id为10表示刊物  
     */
    NSDictionary *parameters = @{@"ownertype":ownertype, @"keywords":_searchBar.text, @"start_pos":[NSNumber numberWithInt:(int)_responseArr.count], @"list_num":[NSNumber numberWithInt:SEARCHPAGESIZE], @"group_id":[NSNumber numberWithInteger:self.groupId]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_searchnews.php",BASE_URL];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
        NSArray *listArray = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseArr addObjectsFromArray:listArray];
        NSLog(@"%@",responseObject);
        [_searchTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"搜索失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%@",error);
    }];
    
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
}

- (void)getSearchData
{
    UserRole role = [UserSession sharedInstance].currentRole;
    NSNumber *ownertype = [NSNumber numberWithInt:role];
//    NSNumber *group_id;
//    if ([ownertype intValue] == 1) {
//        group_id = [NSNumber numberWithInt:1];
//    }else if ([ownertype intValue] == 2){
//        group_id = [NSNumber numberWithInt:10];
//    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"ownertype":ownertype, @"keywords":_searchBar.text, @"start_pos":[NSNumber numberWithInt:0], @"list_num":[NSNumber numberWithInt:SEARCHPAGESIZE], @"group_id":[NSNumber numberWithInteger:self.groupId]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_searchnews.php",BASE_URL];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
        if (responseObject) {
            NSArray *listArray = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            if ([listArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"没有数据"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                return ;
            }
            [_responseArr removeAllObjects];
            [_responseArr addObjectsFromArray:listArray];
            NSLog(@"-----%@-----",responseObject);
            [_searchTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.indicatorView setHidden:YES];
        [self.indicatorView stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"搜索失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"%@",error);
    }];
    [self.indicatorView setHidden:NO];
    [self.indicatorView startAnimating];
}

// 加载前一页数据
- (void)loadPrePageData
{
    [_responseArr removeAllObjects];
    [self getData];
    [_searchTableView.mj_header endRefreshing];
}

// 加载后一页数据
- (void)loadNextPageData
{
    [self getData];
    [_searchTableView.mj_footer endRefreshing];
}

#pragma mark - UI搭建
// UI搭建
- (void)setupUI
{
    [self setupSearchBar];
    [self setupTableView];
    // add indicator view
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.indicatorView setFrame:CGRectMake((self.view.frame.size.width - 40)/2,
//                                            (self.view.frame.size.height - 40)/2,
//                                            40,
//                                            40)];
    [self.indicatorView setCenter:self.view.center];
    [self.view addSubview:self.indicatorView];
    [self.indicatorView setHidden:YES];
}

// 配置搜索框
- (void)setupSearchBar
{
    // searchBar的容器View
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.view addSubview:searchBgView];
    
    // 灰色背景图片
    UIImageView *searchBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBg" ofType:@"png" inDirectory:@"temp"]];
    searchBgImg.image = image;
    [searchBgView addSubview:searchBgImg];
    searchBgImg.userInteractionEnabled = YES;
    
    // 白色背景图片
    UIImageView *searchBarImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 40)];
    searchBarImg.layer.cornerRadius = 6;
    searchBarImg.layer.masksToBounds = YES;
    UIImage *searchBarImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBar" ofType:@"png" inDirectory:@"temp"]];
    searchBarImg.image = searchBarImage;
    [searchBgImg addSubview:searchBarImg];
    searchBarImg.userInteractionEnabled = YES;
    
    // 左侧图片搜索button
    UIButton *searchIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchIconBtn.frame = CGRectMake(10, 5, 30, 30);
//    UIImage *searchIconBtnImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchIcon" ofType:@"png" inDirectory:@"temp"]];
    UIImage *searchIconBtnImage = [UIImage imageNamed:@"searchIcon"];
    [searchIconBtn setBackgroundImage:searchIconBtnImage forState:UIControlStateNormal];
    [searchIconBtn addTarget:self action:@selector(clickToShowKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [searchBarImg addSubview:searchIconBtn];
    
    // 搜索textfield
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, searchBarImg.frame.size.width - 50, 40)];
    _searchBar.layer.cornerRadius = 6;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchBar.placeholder = @"输入您要搜索的关键词";
//    [_searchBar setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_searchBar setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    _searchBar.font = [UIFont systemFontOfSize:16.0];
    _searchBar.textColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f];
    _searchBar.clearButtonMode = UITextFieldViewModeAlways;
    
    // 右侧文字搜索button
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(_searchBar.frame.size.width - 80, 0, 80, _searchBar.frame.size.height);
    [searchBtn setTitle:@"搜一下" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickToSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [AppConfig appNaviColor];
    _searchBar.rightView = searchBtn;
    _searchBar.rightViewMode = UITextFieldViewModeAlways;
    [searchBarImg addSubview:_searchBar];
}

// 配置tableView
- (void)setupTableView
{
    _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    _searchTableView.showsVerticalScrollIndicator = NO;
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _searchTableView.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    [self.view addSubview:_searchTableView];
    
    // 下拉刷新
    _searchTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self loadPrePageData];
    }];
    
    // 上拉加载
    _searchTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self loadNextPageData];
    }];
    
    _searchTableView.mj_header.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
    _searchTableView.mj_footer.backgroundColor = [UIColor colorWithRed:242.0 / 255.0 green:242.0 / 255.0 blue:242.0 / 255.0 alpha:1.0];
}

#pragma mark - Actions
- (void)clickToShowKeyboard
{
    [_searchBar becomeFirstResponder];
}

- (void)clickToSearch
{
    [_searchBar resignFirstResponder];
    if ([UserSession sharedInstance].currentUserID == 0) {
        LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"login"];
        [AppDelegate.app.nav pushViewController:loginVC animated:YES];
    }else{
        if ([_searchBar.text isEqualToString:@""] || _searchBar.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入搜索关键字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self getSearchData];
        }
    }
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _responseArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PublicationSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PublicationSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (_responseArr.count == 0) {
        return cell;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
    cell.titleLabel.text = [[_responseArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublicationIntroduceViewController *publicationIntroduceVC = [[PublicationIntroduceViewController alloc] init];
    publicationIntroduceVC.publicationID = [[[_responseArr objectAtIndex:indexPath.row] valueForKey:@"id"] integerValue];
    if (self.groupId == 1 || self.groupId == 10) {
        publicationIntroduceVC.showPaper = YES;
    }else{
        publicationIntroduceVC.showPaper = NO;
    }
    [AppDelegate.app.nav pushViewController:publicationIntroduceVC animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

@end
