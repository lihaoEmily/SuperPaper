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

#define SEARCHPAGESIZE 30

@interface PublicationViewController ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) JournalsPressView *contentView;
@property (nonatomic, strong) PublicationView* contentView;
@property (nonatomic, strong) NSMutableArray* publicationSortArray;
@property (nonatomic, strong) NSMutableArray* publicationDataArray;
@property (nonatomic, strong) NSString* bundleStr;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, assign) NSInteger subgroupId;
@property (nonatomic, strong) NSDictionary* selectedSortDic;

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
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
//    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBtn" ofType:@"png" inDirectory:@"Paper"]];
    UIImage *image = [UIImage imageNamed:@"SearchImage"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, 0, 25, 25);
    [searchBtn setImage:image forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchPublication:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"sortBtn" ofType:@"png" inDirectory:@"Paper"]];
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.frame = CGRectMake(10, 0, 25, 25);
    [sortBtn setImage:image forState:UIControlStateNormal];
    [sortBtn addTarget:self action:@selector(sortPublication:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortBtn];
    self.navigationItem.rightBarButtonItems = @[searchItem, sortItem];
}

- (void) searchPublication :(id) sender{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:[UserSession sharedInstance].currentRole], @"group_id":[NSNumber numberWithInt:1],@"list_num":[NSNumber numberWithInt:15], @"group_id":[NSNumber numberWithInt:1]};
    NSString *urlString = [NSString stringWithFormat:@"%@confer_newsinfo.php",BASE_URL];
    NSLog(@"URL＝ %@",urlString);
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *array = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
            [_publicationSortArray addObjectsFromArray:array];
            NSLog(@"%@",responseObject);
            [_contentView.leftTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}

- (void) sortPublication:(id) sender{
    
}

- (void)getPublicationSortData
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSDictionary *parameters = @{@"groupid":[NSNumber numberWithInt:1]};
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
    
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:1], @"group_id":[NSNumber numberWithInt:1], @"subgroup_id":[sortDic objectForKey:@"id"], @"tag_id":[NSNumber numberWithInt:0], @"start_pos":[NSNumber numberWithUnsignedInteger:_publicationDataArray.count], @"list_num":[NSNumber numberWithInt:15]};
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        return 50;
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
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
    else{
        static NSString *CellIdentifierPublicationRight = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPublicationRight];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierPublicationRight];
        }
        
//        cell.textLabel.text = @"right";
        NSDictionary* dataDic = (NSDictionary*)_publicationDataArray[indexPath.row];
        cell.textLabel.text = [dataDic objectForKey:@"title"];
        cell.detailTextLabel.text = [dataDic objectForKey:@"description"];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        
//        NSString* urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
//        [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:urlString]];
//        cell.titleLabel.text = [[_responseArr objectAtIndex:indexPath.row] valueForKey:@"title"];
//
//        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"image",
//                              [[_publicationDataArray objectAtIndex:indexPath.row] valueForKey:@"title"],@"title",
//                              nil];
//        cell.imageView
//        UIImageView* cellImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 55, 55)];
//        cell.imageView.image;
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
        cell.textLabel.textColor = [UIColor redColor];
        _selectedIndexPath = indexPath;
        _selectedSortDic = [_publicationSortArray objectAtIndex:indexPath.row];
        [_publicationDataArray removeAllObjects];
        [self getPublicationDataWithSort:_publicationSortArray[indexPath.row]];
    }
    else{
        //        NSLog(@"tap right tableview index:%ld",(long)indexPath.row);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1000) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];
    }
}

@end
