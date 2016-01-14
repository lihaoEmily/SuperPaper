//
//  StudyViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "StudyViewController.h"
#import "ServiceButton.h"

/** 获取屏幕尺寸*/
#define KAppWidth [UIScreen mainScreen].bounds.size.width
#define KAppHeight [UIScreen mainScreen].bounds.size.height

@interface StudyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *homeTableView;

@end

@implementation StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)titleName {
    return @"学习";
}

- (void)initData {
    
    _homeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KAppWidth, KAppHeight) style:UITableViewStyleGrouped];
    _homeTableView.dataSource = self;
    _homeTableView.delegate = self;
    _homeTableView.sectionHeaderHeight = 10;
    _homeTableView.sectionFooterHeight = 10;
    [self.view addSubview:_homeTableView];
    
}

#pragma mark - 活动图片点击事件
- (void)serviceBtnClick:(UIButton *)button{
    switch (button.tag) {
        case 0:{

        }
            break;
        case 1:{
           
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
            
        }
            break;
        case 4:{
           
        }
            break;
        case 5:{
           
        }
            break;
        case 6:{
            
        }
            break;
        case 7:{
            
        }
            break;
        case 8:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSString *service   = [[NSBundle mainBundle] pathForResource:@"Service" ofType:@"plist"];
    NSArray  *services = [NSArray arrayWithContentsOfFile:service];
    for (int i = 0; i < services.count; i ++) {
        NSDictionary *dic = services[i];
        ServiceButton *serviceBtn = [[ServiceButton alloc] initWithFrame:CGRectMake((i%3)*KAppWidth/3, (i/3)*KAppWidth/3, KAppWidth/3, KAppWidth/3)];
        serviceBtn.tag = i;
        serviceBtn.layer.borderColor = [UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:241.0/255.0f alpha:1].CGColor;
        serviceBtn.layer.borderWidth = 0.5;
        [serviceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        serviceBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [serviceBtn addTarget:self action:@selector(serviceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [serviceBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [serviceBtn setImage:[UIImage imageNamed:dic[@"icon"]] forState:UIControlStateNormal];
        [cell.contentView addSubview:serviceBtn];
    }
    return cell;
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ((0 == section) || (1 == section)) {
        
        return 1;
    }
    else
    {
        //T.B.D 根据接口返回值数量而定
        return 10;
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KAppWidth;
    
}

@end
