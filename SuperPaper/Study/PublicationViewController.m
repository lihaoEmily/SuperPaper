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
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic ,strong) UIActivityIndicatorView *webIndicator;

/**
 *  数据总数
 */
@property (nonatomic, assign) NSInteger totalCountOfItems;

/**
 *  可见行数
 */
@property (nonatomic, assign) NSInteger visibleRowsOfRightTable;

/**
 *  是否正在请求
 */
@property (nonatomic, assign) BOOL isRequiring;

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
    _contentView.backgroundColor = [UIColor whiteColor];
    self.view = _contentView;
//    _contentView.leftTableView.backgroundColor = [UIColor whiteColor];
//    _contentView.rightTableView.backgroundColor = [UIColor whiteColor];
//    _contentView.leftTableView.layer.borderColor = [UIColor whiteColor].CGColor;
//    _contentView.rightTableView.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentView.leftTableView.dataSource = self;
    _contentView.leftTableView.delegate = self;
    _contentView.rightTableView.dataSource = self;
    _contentView.rightTableView.delegate = self;
    _tagId = 0;
    
    _contentView.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pulldownRefresh:_selectedSortDic];
    }];
//    _contentView.rightTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self pullupRefresh:_selectedSortDic];
//    }];
    _contentView.rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ;
    }];
    
    _webIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _webIndicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    [_webIndicator setHidden:YES];
    [self.view addSubview:_webIndicator];
    
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
    vc.groupId = self.groupId;
    
    if (self.groupId == 2) {
        vc.title = @"出版社搜索";
    }
    else{
        vc.title = @"刊物搜索";
    }
    
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}

- (void) sortPublication:(id) sender{
    PublicationSortsViewController *sortsView = [[PublicationSortsViewController alloc]init];
    
    sortsView.tagId = _tagId;
    sortsView.groupId = self.groupId;
    if (self.groupId == 2) {
        sortsView.title = @"出版社分类";
    }
    else{
        sortsView.title = @"刊物分类";
    }
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
              [_webIndicator stopAnimating];
              [_webIndicator setHidden:YES];
        }];
    
    if (!_webIndicator.isAnimating) {
        [_webIndicator setHidden:NO];
        [_webIndicator startAnimating];
    }
}

- (void)getPublicationDataWithSort:(NSDictionary*) sortDic
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters  参数
     * ownertype   整型    1：老师  2:学生
     * subgroup_id 整型    期刊属性
     * tag_id      整型    期刊标签
     * start_pos   整型    表单中获取数据的开始位置。从0开始
     * list_num    整型    一次获取list数
     * group_id    整型    ownertype为1时,group_id为1表示刊物;ownertype为2时,group_id为10表示刊物
     */
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInteger:ownerType],
                                 @"group_id":[NSNumber numberWithInteger:_groupId],
                                 @"subgroup_id":[sortDic objectForKey:@"id"],
                                 @"tag_id":[NSNumber numberWithInteger:_tagId],
                                 @"start_pos":[NSNumber numberWithUnsignedInteger:_publicationDataArray.count],
                                 @"list_num":[NSNumber numberWithInt:15]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
//              NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
              NSArray *array = [responseObject valueForKey:@"list"];
              if ([array count] == 0) {
                  [self showAlertViewWithMessage:@"无数据"];
                  return ;
              }
              [_publicationDataArray addObjectsFromArray:array];
              NSInteger total_num = [[responseObject valueForKey:@"total_num"] integerValue];
              self.totalCountOfItems = total_num;
              [_contentView.rightTableView reloadData];
              [_webIndicator stopAnimating];
              [_webIndicator setHidden:YES];
              
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
              [_webIndicator stopAnimating];
              [_webIndicator setHidden:YES];

              [self showAlertViewWithMessage:@"数据获取失败"];

          }];
    if (!_webIndicator.isAnimating) {
        [_webIndicator setHidden:NO];
        [_webIndicator startAnimating];
    }
}

- (void)pulldownRefresh:(NSDictionary*) sortDic
{
//    [_publicationDataArray removeAllObjects];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:ownerType],
                                 @"group_id":[NSNumber numberWithInteger:_groupId],
                                 @"subgroup_id":[sortDic objectForKey:@"id"],
                                 @"tag_id":[NSNumber numberWithInteger:_tagId],
                                 @"start_pos":[NSNumber numberWithUnsignedInteger:0],
                                 @"list_num":[NSNumber numberWithInt:15]};
    
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
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:ownerType],
                                 @"group_id":[NSNumber numberWithInteger:_groupId],
                                 @"subgroup_id":[sortDic objectForKey:@"id"],
                                 @"tag_id":[NSNumber numberWithInteger:_tagId],
                                 @"start_pos":[NSNumber numberWithUnsignedInteger:_publicationDataArray.count],
                                 @"list_num":[NSNumber numberWithInt:15]};
    
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              self.isRequiring = NO;
//              NSInteger total_num = [[responseObject valueForKey:@"total_num"] integerValue];
//              self.totalCountOfItems = total_num;
              NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
              if ([array count] == 0) {
                  [self showAlertViewWithMessage:@"暂无数据"];
                  return ;
              }
              [_publicationDataArray addObjectsFromArray:array];
              [_contentView.rightTableView reloadData];
              [_contentView.rightTableView.mj_footer endRefreshing];

          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
              self.isRequiring = NO;
              [_contentView.rightTableView.mj_footer endRefreshing];
          }];
    
    self.isRequiring = YES;
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
        
        if (!_publicationDataArray || !_publicationDataArray.count) {//防止刷新左侧table的时候，点击右侧table,崩溃
            return cell;
        }
//        cell.textLabel.text = @"right";
//        NSDictionary* dataDic = (NSDictionary*)_publicationDataArray[indexPath.row];
//        cell.textLabel.text = [dataDic objectForKey:@"title"];
//        cell.detailTextLabel.text = [dataDic objectForKey:@"description"];
//        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        NSString* urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
//        [cell.cellImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
        [cell.cellImg sd_setImageWithURL:[NSURL URLWithString:urlString]
                        placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.titleLabel.text = [[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"title"];

        return cell;
    }
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    return;
    
    if (tableView == _contentView.rightTableView) {
        NSInteger rowIndex = [indexPath row];
        NSInteger currentCountOfItems = _publicationDataArray.count;
        
        NSLog(@"----> rowIndex=%ld, currentCountOfItems=%ld, totalCountOfItems=%ld",(long)rowIndex, (long)currentCountOfItems, (long)self.totalCountOfItems);
        if (currentCountOfItems < self.totalCountOfItems) {
            NSInteger visibleCountOfItems = [[_contentView.rightTableView visibleCells] count];
            if (visibleCountOfItems == 0) {
                visibleCountOfItems = _contentView.rightTableView.frame.size.height / 70;
            }
            NSInteger offsetCountOfItems = rowIndex + visibleCountOfItems/2 + 1;
            NSLog(@"----> OffsetCountOfItems = %ld", (long)offsetCountOfItems);
            if (self.isRequiring == NO && offsetCountOfItems >= currentCountOfItems) {
                NSLog(@"----> Load more data");
                [self pullupRefresh:_selectedSortDic];
            }
        } else {
            NSLog(@"----> CurrentCountOfItems >= TotalCountOfItems");
            //        [_studyTableView.mj_footer endRefreshing];
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
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
        if (self.groupId == 1 || self.groupId == 10) {
            vc.showPaper = YES;
        }else{
            vc.showPaper = NO;
        }
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1000) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - Show alert view
- (void)showAlertViewWithMessage:(NSString *)message {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:@"确认"
                                             otherButtonTitles:nil, nil];
    [alerView show];
}

@end
