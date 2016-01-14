//
//  PublicationSearchViewController.m
//  SuperPaper
//
//  Created by lihao on 16/1/13.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationSearchViewController.h"
#import "PublicationSearchTableViewCell.h"
#import "AFNetworking.h"

@interface PublicationSearchViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PublicationSearchViewController
{
    NSArray *_iconArr;
    NSArray *_titleArr;
    NSString *_bundleStr;
    UITextField *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self setupUI];
    
    _iconArr = @[@"searchList1", @"searchList2", @"searchList3", @"searchList1", @"searchList2", @"searchList3"];
    _titleArr = @[@"马克思主义与现实 Marxism & Reality", @"外国文学评论 Foreign Literature Review", @"外国文学评论 Foreign Literature Review", @"马克思主义与现实 Marxism & Reality", @"外国文学评论 Foreign Literature Review", @"外国文学评论 Foreign Literature Review"];
}

- (void)getData
{
    
}

// UI搭建
- (void)setupUI
{
    self.title = @"刊物搜索";
    [self setupSearchBar];
    [self setupTableView];
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
    UIImage *searchBarImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBar" ofType:@"png" inDirectory:@"temp"]];
    searchBarImg.image = searchBarImage;
    [searchBgImg addSubview:searchBarImg];
    searchBarImg.userInteractionEnabled = YES;
    
    // 左侧图片搜索button
    UIButton *searchIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchIconBtn.frame = CGRectMake(10, 5, 30, 30);
    UIImage *searchIconBtnImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchIcon" ofType:@"png" inDirectory:@"temp"]];
    [searchIconBtn setBackgroundImage:searchIconBtnImage forState:UIControlStateNormal];
    [searchIconBtn addTarget:self action:@selector(clickToShowKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [searchBarImg addSubview:searchIconBtn];
    
    // 搜索textfield
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, searchBarImg.frame.size.width - 50, 40)];
    _searchBar.layer.cornerRadius = 5;
    _searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // 右侧文字搜索button
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(_searchBar.frame.size.width - 80, 0, 80, _searchBar.frame.size.height);
    _searchBar.placeholder = @"输入您要搜索的关键词";
    [searchBtn setTitle:@"搜一下" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickToSearch) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f];
    _searchBar.rightView = searchBtn;
    _searchBar.rightViewMode = UITextFieldViewModeAlways;
    [searchBarImg addSubview:_searchBar];
}

// 配置tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

#pragma mark - Actions
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickToShowKeyboard
{
    [_searchBar resignFirstResponder];
    NSLog(@"clickToShowKeyboard");
}

- (void)clickToSearch
{
    [_searchBar resignFirstResponder];
    NSLog(@"clickToSearch");
}

#pragma mark - UITableView DataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    PublicationSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PublicationSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:[_iconArr objectAtIndex:indexPath.row] ofType:@"png" inDirectory:@"temp"]];
    [cell.iconImg setImage:image];
    cell.titleLabel.text = [_titleArr objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}

@end
