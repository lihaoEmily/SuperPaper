//
//  StudyViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "StudyViewController.h"
#import "ServiceButton.h"
#import "SDCycleScrollView.h"
#import "HomeNewsCell.h"
#import "NormalWebViewController.h"
#import "NormalStudyViewController.h"
#import "PublicationViewController.h"
#import "HomeDetailController.h"

/** 获取屏幕尺寸*/
//#define KAppWidth [UIScreen mainScreen].bounds.size.width
//#define KAppHeight [UIScreen mainScreen].bounds.size.height

@interface StudyViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *studyTableView;

/**
 *  数据总数
 */
@property (nonatomic, assign) NSInteger totalCountOfItems;

/**
 *  是否正在请求
 */
@property (nonatomic, assign) BOOL isRequiring;

@end

@implementation StudyViewController{
    // 返回学习主页资讯数据
    NSMutableArray *_responseNewsInfoArr;

    // 返回学习广告信息数据
    NSArray *_responseAdInfoArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self getStudyPageNewsInfo];
    [self getStudyPageAdInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleName {
    return @"学习";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _studyTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,self.view.bounds.size.height - 30);

}

- (void)initData {
    
    _studyTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _studyTableView.dataSource = self;
    _studyTableView.delegate = self;
    _studyTableView.sectionHeaderHeight = 10;
    _studyTableView.sectionFooterHeight = 10;
    if ([_studyTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_studyTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_studyTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_studyTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_studyTableView];
    
    //变量初始化

    _responseNewsInfoArr = [[NSMutableArray alloc]init];
    
    // 下拉刷新
    _studyTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullDownPageData];
    }];
    
    // 上拉加载
//    _studyTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self pullUpPageData];
//    }];
    _studyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ;
    }];
    
}

// 下拉刷新
- (void)pullDownPageData
{
    [_responseNewsInfoArr removeAllObjects];
    [self getStudyPageNewsInfo];

    [_studyTableView.mj_header endRefreshing];
}

// 上拉加载
- (void)pullUpPageData
{

    [self getStudyPageNewsInfo];

    [_studyTableView.mj_footer endRefreshing];
}

#pragma mark - Afnetworking 网络数据请求
//获取学习主页资讯
- (void)getStudyPageNewsInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters 参数
     * ownertype  整型    2：学生
     * start_pos  整型    表单中获取数据的开始位置。从0开始
     * list_num   整型    一次获取list数
     */
//    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSInteger startPos = [_responseNewsInfoArr count];
    NSLog(@"----> startPosition:%ld",(long)startPos);
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:2], @"start_pos":[NSNumber numberWithInteger:startPos], @"list_num":[NSNumber numberWithInt:15]};
    NSString *urlString = [NSString stringWithFormat:@"%@studypage_newsinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
        self.isRequiring = YES;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.isRequiring = NO;
        NSArray *myArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        [_responseNewsInfoArr addObjectsFromArray:myArr];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        NSInteger num = [responseObject[@"total_num"] integerValue];
        self.totalCountOfItems = num;
//        if (_responseNewsInfoArr.count < num) {
//            [self getStudyPageNewsInfo];
//        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        self.isRequiring = NO;
    }];
    self.isRequiring = YES;
}

//获取学习广告信息
- (void)getStudyPageAdInfo
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    /**
     * parameters 参数
     * ownertype  整型    4：学习主页
     */
//    UserRole ownerType = [[UserSession sharedInstance] currentRole];
    NSDictionary *parameters = @{@"ownertype":[NSNumber numberWithInt:4]};
    NSString *urlString = [NSString stringWithFormat:@"%@getadinfo.php",BASE_URL];
    NSLog(@"%@",urlString);
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _responseAdInfoArr = [NSArray arrayWithArray:[responseObject valueForKey:@"list"]];
        NSLog(@"%@",responseObject);
        [_studyTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 活动图片点击事件
- (void)serviceBtnClick:(UIButton *)button{
    switch (button.tag) {
        case 0:{
            PublicationViewController *vc = [[PublicationViewController alloc] init];
            vc.title = @"刊物";
            vc.groupId = 10;
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 1:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"考研";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 2:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"留学";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 3:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"比赛";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"考证";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"计算机";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"大学46级";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 7:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"论文指导";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        case 8:{
            NormalStudyViewController *vc = [[NormalStudyViewController alloc] init];
            vc.title = @"作业指导";
            [AppDelegate.app.nav pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0 == indexPath.section) {
        
        static NSString *ID = @"Cell0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        //采用网络图片实现
        NSMutableArray *imagesURLStrings = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dic in _responseAdInfoArr) {
            NSString *iamgeURL = [NSString stringWithFormat:@"%@%@",IMGURL,[dic valueForKey:@"adpicname"]];
            
            
            [imagesURLStrings addObject:iamgeURL];
        }

        // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        // 网络加载 --- 创建带标题的图片轮播器
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180) delegate:self placeholderImage:[UIImage imageWithASName:@"default_image" directory:@"common"]];
        
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"circle_select"];
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"circle"];
        
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//        cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        
        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        [cell.contentView addSubview:cycleScrollView];
        
        //         --- 模拟加载延迟
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            cycleScrollView.imageURLStringsGroup = imagesURLStrings;
//        });
        

        return cell;
    }
    else if (1 == indexPath.section) {
        
        static NSString *ID = @"Cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        NSString *service   = [[NSBundle mainBundle] pathForResource:@"Service" ofType:@"plist"];
        NSArray  *services = [NSArray arrayWithContentsOfFile:service];
        for (int i = 0; i < services.count; i ++) {
            NSDictionary *dic = services[i];
            CGFloat tileWidth = SCREEN_WIDTH/3;
            CGFloat tileHeight = SCREEN_WIDTH/3-HEIGHT_OFFSET;
            ServiceButton *serviceBtn = [[ServiceButton alloc] initWithFrame:CGRectMake((i%3)*tileWidth, (i/3)*tileHeight, tileWidth, tileHeight)];
            serviceBtn.tag = i;
            serviceBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:241.0/255.0f alpha:1].CGColor;
            serviceBtn.layer.borderWidth = 1;
            [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [serviceBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
//            [serviceBtn setImage:[UIImage imageWithASName:dic[@"icon"] directory:@"studyPage"] forState:UIControlStateNormal];
            [serviceBtn setImage:[UIImage imageNamed:dic[@"icon"]]
                        forState:UIControlStateNormal];
            [cell.contentView addSubview:serviceBtn];
        }
        
        return cell;
    }
    else {
        
        static NSString *ID = @"Cell2";
        HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[HomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        if (_responseNewsInfoArr.count == 0) {
            return cell;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",IMGURL,[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"listitem_pic_name"]];
        NSString *timeString = [[[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"createdate"] substringToIndex:10];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              urlString,@"image",
                              [[_responseNewsInfoArr objectAtIndex:indexPath.row] valueForKey:@"title"],@"title",
                              timeString,@"time", nil];
        
        cell.infoDict = dict;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ((0 == section) || (1 == section)) {
        
        return 1;
    }
    else
    {
        return _responseNewsInfoArr.count;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        return 180;
    }
    else if (1 == indexPath.section) {
        return  SCREEN_WIDTH - HEIGHT_OFFSET*3;
    }
    
    return TABLE_CELL_HEIGHT;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSInteger rowIndex = [indexPath row];
        NSInteger currentCountOfItems = [_responseNewsInfoArr count];
        NSLog(@"----> rowIndex=%ld, currentCountOfItems=%ld, totalCountOfItems=%ld",(long)rowIndex, (long)currentCountOfItems, (long)self.totalCountOfItems);
        if (currentCountOfItems < self.totalCountOfItems) {
            NSInteger visibleCountOfItems = [[tableView visibleCells] count];
            NSInteger offsetCountOfItems = rowIndex + visibleCountOfItems/2 + 1;
            NSLog(@"----> OffsetCountOfItems = %ld", (long)offsetCountOfItems);
            if (self.isRequiring == NO && offsetCountOfItems >= currentCountOfItems) {
                NSLog(@"----> Load more data");
                [self pullUpPageData];
            }
        } else {
            NSLog(@"----> CurrentCountOfItems >= TotalCountOfItems");
            //        [_studyTableView.mj_footer endRefreshing];
            [tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (2 == indexPath.section) {
//        
//        NormalWebViewController *vc = [[NormalWebViewController alloc]init];
//        vc.title = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"title"];
//        vc.urlString = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"url"];
//        
//        /**
//         * 跳转页面
//         */
//        [AppDelegate.app.nav pushViewController:vc animated:YES];
        
        NSDictionary *info = _responseNewsInfoArr[indexPath.row];
        
        NSString *title = [info valueForKey:@"title"];
        NSString *urlStr = [info valueForKey:@"url"];
        
        /**
         * 跳转页面
         */
        UIViewController *viewController = nil;
        if (urlStr.length > 1) {
            NormalWebViewController *vc = [[NormalWebViewController alloc]init];
            vc.title = title;
            vc.urlString = urlStr;
            viewController = vc;
        } else {
            HomeDetailController *vc = [[HomeDetailController alloc] init];
            vc.title = title;
            vc.passId = [[_responseNewsInfoArr objectAtIndex:indexPath.row]valueForKey:@"id"];
            vc.isNews = YES;
            viewController = vc;
        }
        [AppDelegate.app.nav pushViewController:viewController animated:YES];
        
    }
}


#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    NormalWebViewController *vc = [[NormalWebViewController alloc]init];
    vc.title = @"资讯";
    vc.urlString = [[_responseAdInfoArr objectAtIndex:index]valueForKey:@"url"];

    /**
     * 跳转页面
     */
    [AppDelegate.app.nav pushViewController:vc animated:YES];
}
@end
