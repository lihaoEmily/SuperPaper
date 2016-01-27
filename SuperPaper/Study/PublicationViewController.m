//
//  PublicationViewController.m
//  SuperPaper
//
//  Created by else on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationViewController.h"
#import "JournalsPressView.h"

@interface PublicationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) JournalsPressView *contentView;

@end

@implementation PublicationViewController
{
    UITableView* _leftTable;
    UITableView* _rightTable;
    NSIndexPath* _selectedCellIndex;
    NSString* _bundleStr;
}

- (instancetype)init {
    if (self = [super init]) {
        _selectedCellIndex = nil;
        _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftTable = [[UITableView alloc] init];
    _leftTable.frame = CGRectMake(0, 0, self.view.bounds.size.width/4, self.view.bounds.size.height);
    _leftTable.dataSource = self;
    _leftTable.delegate = self;
//    _leftTable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _leftTable.showsVerticalScrollIndicator = NO;
//    _leftTable.tableFooterView = [[UIView alloc] init];
    _leftTable.tag = 1000;
    _leftTable.separatorColor = [UIColor whiteColor];
    _leftTable.allowsSelection = YES;
    _leftTable.allowsMultipleSelection = NO;
    [self.view addSubview:_leftTable];
    
    _rightTable = [[UITableView alloc] init];
    _rightTable.frame = CGRectMake(self.view.bounds.size.width/4, 0, self.view.bounds.size.width*3/4, self.view.bounds.size.height);
    _rightTable.dataSource = self;
    _rightTable.delegate = self;
    _rightTable.showsVerticalScrollIndicator = YES;
    _rightTable.tag = 2000;
    [self.view addSubview:_rightTable];
    
    [self loadNavigationView];
}

-(void)viewDidLayoutSubviews
{
    if ([_leftTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_leftTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        [_rightTable setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_leftTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_leftTable setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        [_rightTable setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)loadNavigationView
{
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBtn" ofType:@"png" inDirectory:@"Paper"]];
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
    
}

- (void) sortPublication:(id) sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1000) {
        return 5;
    }
    else{
        return 100;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000) {
        static NSString *CellIdentifierPublicationLeft = @"leftCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPublicationLeft];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPublicationLeft];
        }
        cell.textLabel.text = @"left";
        cell.backgroundColor = [UIColor grayColor];
        return cell;
    }
    else{
        static NSString *CellIdentifierPublicationRight = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierPublicationRight];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierPublicationRight];
        }
        
        cell.textLabel.text = @"right";
        return cell;
    }
}

#pragma mark - tableView 代理方法
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
//        _selectedCellTag = indexPath;
    }
    else{
//        NSLog(@"tap right tableview index:%ld",(long)indexPath.row);
    }
}

@end
