//
//  PapersViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersViewController.h"

#import "AFNetworking.h"
#import "SPGlobal.h"

#import "PapersGeneratorViewController.h"


@interface PapersViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PapersViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 论文分类数组
    NSArray *_paperArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _paperArray = @[@"艺术类论文", @"经济类论文", @"法学类论文", @"教育类论文", @"计算机类论文", @"可以类论文", @"建筑类论文", @"管理学类论文", @"文化类论文"];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"ownertype",nil];
    NSString *urlString =  [NSString stringWithFormat:@"%@mobileapp/paper_type.php",BASE_URL];
    //初始化AFHTTPRequestOperationManager
    NSLog(@"%@",urlString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)setupUI
{
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"bgImg" ofType:@"png" inDirectory:@"Paper"]];
    UIImageView *topImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 44)];
    topImg.image = image;
    [self.view addSubview:topImg];
    topImg.userInteractionEnabled = YES;
    
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telBtn.frame = CGRectMake(0, 0, self.view.frame.size.width / 2 - 10, 44);
    [telBtn addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
    [topImg addSubview:telBtn];
    
    UIImage *telIconImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"telcon" ofType:@"png" inDirectory:@"Paper"]];
    [telBtn setImage:telIconImage forState:UIControlStateNormal];
    [telBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 17, 10, telBtn.frame.size.width - 37)];
    
    telBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [telBtn setTitle:@"论文指导与发表" forState:UIControlStateNormal];
    [telBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [telBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, -10, 5, 0)];
    
    UIButton *generatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    generatorBtn.frame = CGRectMake(CGRectGetMaxX(telBtn.frame) + 20, 0, self.view.frame.size.width / 2 - 10, 44);
    [generatorBtn addTarget:self action:@selector(clickToGenerate) forControlEvents:UIControlEventTouchUpInside];
    [topImg addSubview:generatorBtn];
    
    UIImage *generatorImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"generatorIcon" ofType:@"png" inDirectory:@"Paper"]];
    [generatorBtn setImage:generatorImage forState:UIControlStateNormal];
    [generatorBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 30, 10, generatorBtn.frame.size.width - 50)];
    
    generatorBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [generatorBtn setTitle:@"论文生成器" forState:UIControlStateNormal];
    [generatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [generatorBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, -20, 5, 0)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 64)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

- (void)clickToCall
{
    NSLog(@"clickToCall");
}

- (void)clickToGenerate
{
    PapersGeneratorViewController *papersGeneratorVC = [[PapersGeneratorViewController alloc] init];
    papersGeneratorVC.title = @"论文生成器";
    [AppDelegate.app.nav pushViewController:papersGeneratorVC animated:YES];
}

- (NSString *)titleName {
    return @"论文";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _paperArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_paperArray objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

@end
