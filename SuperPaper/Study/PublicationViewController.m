//
//  PublicationViewController.m
//  SuperPaper
//
//  Created by elsie on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationViewController.h"
#import "JournalsPressView.h"
#import "PublicationView.h"
#import "UserSession.h"
#import "PublicationViewTableViewCell.h"
#import "PublicationSearchViewController.h"
#import "PublicationSortsViewController.h"
#import "PublicationIntroduceViewController.h"

#define SEARCHPAGESIZE 30

@interface PublicationViewController ()<UITableViewDataSource,UITableViewDelegate,ClassifiedPublicationViewControllerDelegate>

//@property (nonatomic, strong) JournalsPressView *contentView;
@property (nonatomic, strong) PublicationView* contentView;
@property (nonatomic, strong) NSMutableArray* publicationSortArray;
@property (nonatomic, strong) NSMutableArray* publicationDataArray;
@property (nonatomic, strong) NSString* bundleStr;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) NSInteger subgroupId;
@property (nonatomic, strong) NSDictionary* selectedSortDic;
@property (nonatomic ,assign) NSInteger tagId;

@end

@implementation PublicationViewController

- (instancetype)init
{
    if(self = [super init]){
        _contentView = nil;
        _publicationSortArray = [NSMutableArray arrayWithCapacity:0];
        _publicationDataArray = [NSMutableArray arrayWithCapacity:0];
        _bundleStr = nil;
        _selectedIndexPath = nil;
        _subgroupId = 0;
        _selectedSortDic = nil;
        _tagId = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _contentView = [[JournalsPressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _contentView = [[PublicationView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = _contentView;
    _contentView.leftTableView.dataSource = self;
    _contentView.leftTableView.delegate = self;
    _contentView.rightTableView.dataSource = self;
    _contentView.rightTableView.delegate = self;
    _tagId = 0;
    
    _contentView.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh:_selectedSortDic];
    }];
    _contentView.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullupRefresh:_selectedSortDic];
    }];
    
    [self getPublicationSortData];
    
    [self loadNavigationView];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidLayoutSubviews
{
    if ([_contentView.leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_contentView.leftTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        [_contentView.rightTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_contentView.leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_contentView.leftTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        [_contentView.rightTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)loadNavigationView
{
//    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
//    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBtn" ofType:@"png" inDirectory:@"Paper"]];
    UIImage *searhImage = [UIImage imageNamed:@"searchImage"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 0, 40, 25);
    [searchBtn setImage:searhImage forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchPublication:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
//    image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"sortBtn" ofType:@"png" inDirectory:@"Paper"]];
    UIImage *FilterImage = [UIImage imageNamed:@"FilterImage"];
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(0, 0, 40, 25);
    [sortBtn setImage:FilterImage forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortPublication:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
    self.navigationItem.rightBarButtonItems = @[searchItem, sortItem];
}

- (void) searchPublication :(id) sender{
    PublicationSearchViewController *vc = [[PublicationSearchViewController alloc] init];
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}

- (void) sortPublication:(id) sender{
    PublicationSortsViewController *sortsView = [[PublicationSortsViewController alloc]init];
    sortsView.tagId = _tagId;
    sortsView.groupId = 1;
    sortsView.delegate = self;
    [self.navigationController pushViewController:sortsView animated:YES];
}

- (void)getPublicationSortData
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"groupid":[NSNumber numberWithInteger:_groupId]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_subgroup.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
        }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
            NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            [_publicationSortArray addObjectsFromArray:array];
            [_contentView.leftTableView reloadData];
              
            NSIndexPath* selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [_contentView.leftTableView selectRowAtIndexPath:selectedIndex animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView: _contentView.leftTableView didSelectRowAtIndexPath:selectedIndex];
            _selectedIndexPath = selectedIndex;
              
        }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

- (void)getPublicationDataWithSort:(NSDictionary*) sortDic
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInteger:_groupId], @"subgroup_id":[sortDic objectForKey:@"id"], @"tag_id":[NSNumber numberWithInteger:_tagId], @"start_pos":[NSNumber numberWithUnsignedInteger:_publicationDataArray.count], @"list_num":[NSNumber numberWithInt:15]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
              [_publicationDataArray addObjectsFromArray:array];
              [_contentView.rightTableView reloadData];

          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
}

- (void)pulldownRefresh:(NSDictionary*) sortDic
{
//    [_publicationDataArray removeAllObjects];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInteger:_groupId], @"subgroup_id":[sortDic objectForKey:@"id"], @"tag_id":[NSNumber numberWithInteger:_tagId], @"start_pos":[NSNumber numberWithUnsignedInteger:0], @"list_num":[NSNumber numberWithInt:15]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
              if (array && [array count] > 0) {
                  [_publicationDataArray removeAllObjects];
                  [_publicationDataArray addObjectsFromArray:array];
                  [_contentView.rightTableView reloadData];
              }
              [_contentView.rightTableView.mj_header endRefreshing];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
              [_contentView.rightTableView.mj_header endRefreshing];
          }];
}

- (void)pullupRefresh:(NSDictionary*) sortDic
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInteger:_groupId], @"subgroup_id":[sortDic objectForKey:@"id"], @"tag_id":[NSNumber numberWithInteger:_tagId], @"start_pos":[NSNumber numberWithUnsignedInteger:_publicationDataArray.count], @"list_num":[NSNumber numberWithInt:15]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
              [_publicationDataArray addObjectsFromArray:array];
              [_contentView.rightTableView reloadData];
              [_contentView.rightTableView.mj_footer endRefreshing];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
              [_contentView.rightTableView.mj_footer endRefreshing];
          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ClassifiedPublicationViewControllerDelegate
- (void)searchByTagid:(NSInteger)tagid
{
    _tagId = tagid;
    [_publicationDataArray removeAllObjects];
    [self getPublicationDataWithSort:_selectedSortDic];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return [_publicationSortArray count];
    }
    else{
        return [_publicationDataArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 2000) {
        return 70;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *CellIdentifierPublicationLeft = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPublicationLeft];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPublicationLeft];
        }
//        cell.textLabel.text = @"left";
        cell.textLabel.text = [((NSDictionary*)_publicationSortArray[indexPath.row]) objectForKey:@"subgroupname"];
//        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    }
    else{
        static NSString *CellIdentifierPublicationRight = @"rightCell";
        PublicationViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPublicationRight];
        
        if (cell == nil) {
            cell = [[PublicationViewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierPublicationRight];
        }
        
//        cell.textLabel.text = @"right";
//        NSDictionary* dataDic = (NSDictionary*)_publicationDataArray[indexPath.row];
//        cell.textLabel.text = [dataDic objectForKey:@"title"];
//        cell.detailTextLabel.text = [dataDic objectForKey:@"description"];
//        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        NSString* urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
        [cell.cellImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.titleLabel.text = [[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];

        return cell;
    }
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1000) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [AppConfig appNaviColor];
        _selectedIndexPath = indexPath;
        _selectedSortDic = [_publicationSortArray objectAtIndex:indexPath.row];
        
        [_publicationDataArray removeAllObjects];
        [self getPublicationDataWithSort:_selectedSortDic];
    }
    else{
        PublicationIntroduceViewController *vc = [[PublicationIntroduceViewController alloc]init];
        vc.publicationID = [[[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"id"]integerValue];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1000) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

@end
