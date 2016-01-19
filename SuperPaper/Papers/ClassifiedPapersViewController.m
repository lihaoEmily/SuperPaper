//
//  ClassifiedPapersViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/15.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ClassifiedPapersViewController.h"
#import "PapersSortsViewController.h"

@interface ClassifiedPapersViewController ()<UITableViewDataSource, UITableViewDelegate,ClassifiedPapersViewControllerDelegate>

@end

@implementation ClassifiedPapersViewController
{
    UITableView *_tableView;
    NSArray *_paperArray;
    /// 资源图片文件路径
    NSString *_bundleStr;
    NSString *tagId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tagId =@""; 
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self getData];
    [self setupUI];
    [self addToolBar];
}
- (void)addToolBar{
    
    UIButton * sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sortButton.frame=CGRectMake(0, 5, 25, 25);
    [sortButton setImage:[UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchIcon" ofType:@"png" inDirectory:@"temp"]] forState:UIControlStateNormal];
    sortButton.backgroundColor = [UIColor blueColor];
    [sortButton addTarget:self action:@selector(sortButtonWasClicked)forControlEvents:UIControlEventTouchDown];
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 31)];
    [rightBarView addSubview:sortButton];
    
     UIButton * creatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [creatButton setFrame:CGRectMake(30, 5, 25, 25)];
    [creatButton setImage:[UIImage imageNamed:@"c_address.png"] forState:UIControlStateNormal];
    [creatButton addTarget:self action:@selector(creatButtonWasClicked)forControlEvents:UIControlEventTouchDown];
    creatButton.backgroundColor = [UIColor greenColor];
    [rightBarView addSubview:creatButton];
    rightBarView.backgroundColor=[UIColor clearColor];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    
    self.navigationItem.rightBarButtonItem = rightBtn;


}
- (void)passTypeId:(NSString *)typeId
{
    tagId = typeId;
    [self getData];
}

- (void)sortButtonWasClicked
{



}
- (void)creatButtonWasClicked
{
    PapersSortsViewController *sortsView = [[PapersSortsViewController alloc]init];
    sortsView.typeId = self.type_id;
    sortsView.delegate = self;
    [self.navigationController pushViewController:sortsView animated:YES];
    
}

- (void)getData
{
    NSDictionary *parameters = @{@"type_id":[NSNumber numberWithInt:[self.type_id intValue]], @"start_pos":[NSNumber numberWithInt:0], @"list_num":[NSNumber numberWithInt:15], @"paper_tagid":tagId};
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_list.php",BASE_URL];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [dataDic objectForKey:@"list"];
               _paperArray = listData;
               _tableView.delegate = self;
               _tableView.dataSource = self;
               [_tableView reloadData];
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
       }];
}

- (void)setupUI
{
    [self setupTitleView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_tableView];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_header endRefreshing];
        });
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tableView.mj_footer endRefreshing];
        });
    }];
}

- (void)setupTitleView
{
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, 44)];
//    titleView.backgroundColor = [UIColor yellowColor];
//    self.navigationItem.titleView = titleView;
//    UIButton
    
//    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    searchBtn setBackgroundImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
}

#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.detailTextLabel.text = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"description"];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 110, 80, 100, 20)];
    dataLabel.text = [[[[_paperArray objectAtIndex:indexPath.row] valueForKey:@"createdate"] componentsSeparatedByString:@" "] objectAtIndex:0];
    dataLabel.textAlignment = NSTextAlignmentRight;
    dataLabel.font = [UIFont systemFontOfSize:12.0];
    dataLabel.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dataLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

@end
