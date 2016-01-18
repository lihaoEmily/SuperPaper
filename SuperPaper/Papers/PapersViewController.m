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
#import "UIImageView+WebCache.h"
#import "ClassifiedPapersViewController.h"
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>

@interface PapersViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation PapersViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 论文分类数组
    NSArray *_paperArray;
    
    /// 论文指导与发表电话
    NSString *_paper_tel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    _paperArray = [NSArray array];
    [self setupUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}

- (void)getData
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:2],@"ownertype",nil];
    NSLog(@"%@",paramDic);
    NSString *urlString =  [NSString stringWithFormat:@"%@paper_type.php",BASE_URL];
    NSLog(@"%@",urlString);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:paramDic progress:^(NSProgress * _Nonnull uploadProgress) {

       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           NSDictionary * dataDic = [NSDictionary dictionary];
           dataDic = responseObject;
           NSLog(@"%@",dataDic);
           if (dataDic) {
               NSArray * listData = [dataDic objectForKey:@"list"];
               _paperArray = listData;
               self.tableView.delegate = self;
               self.tableView.dataSource = self;
               [self.tableView reloadData];
               
               _paper_tel = [dataDic valueForKey:@"paper_tel"];
           }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           NSLog(@"%@",error);
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

    self.tableView = tableView;
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:tableView];
}

- (void)clickToCall
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_paper_tel]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.tableView addSubview:callWebView];
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
    cell.textLabel.text = [[_paperArray objectAtIndex:indexPath.row] objectForKey:@"typename"];
    NSString *imageUrlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_paperArray objectAtIndex:indexPath.row] objectForKey:@"picname"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifiedPapersViewController *classifiedPapersVC = [[ClassifiedPapersViewController alloc] init];
    classifiedPapersVC.title = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"typename"];
    classifiedPapersVC.type_id = [[_paperArray objectAtIndex:indexPath.row] valueForKey:@"id"];
    [AppDelegate.app.nav pushViewController:classifiedPapersVC animated:YES];
}

@end
