//
//  PapersGeneratorViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersGeneratorViewController.h"
#define kScreenWidth self.view.frame.size.width

@interface PapersGeneratorViewController ()

@end

@implementation PapersGeneratorViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 搜索框
    UITextField *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI
{
    // searchBar的容器View
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [self.view addSubview:searchBgView];
    
    // 灰色背景图片
    UIImageView *searchBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIImage *image = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"generatorBox" ofType:@"png" inDirectory:@"Paper"]];
    searchBgImg.image = image;
    [searchBgView addSubview:searchBgImg];
    searchBgImg.userInteractionEnabled = YES;
    
    UILabel *topicLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 55, 30)];
    topicLabel.text = @"题目：";
    topicLabel.textColor = [UIColor blackColor];
    topicLabel.font = [UIFont systemFontOfSize:18.0];
    [searchBgImg addSubview:topicLabel];
    
    // 白色背景图片
    UIImageView *searchBarImg = [[UIImageView alloc] initWithFrame:CGRectMake(65, 5, self.view.frame.size.width - 140, 40)];
    UIImage *searchBarImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"searchBar" ofType:@"png" inDirectory:@"Paper"]];
    searchBarImg.image = searchBarImage;
    [searchBgImg addSubview:searchBarImg];
    searchBarImg.userInteractionEnabled = YES;
    
    // 搜索textfield
    _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, searchBarImg.frame.size.width - 5, 40)];
    _searchBar.layer.cornerRadius = 5;
    _searchBar.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _searchBar.placeholder = @"请输入论文题目";
    [searchBarImg addSubview:_searchBar];
    
    // 右侧文字搜索button
    UIButton *generatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    generatorBtn.frame = CGRectMake(CGRectGetMaxX(searchBarImg.frame) + 5, 5, 60, _searchBar.frame.size.height);
    generatorBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [generatorBtn setTitle:@"生成" forState:UIControlStateNormal];
    [generatorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [generatorBtn addTarget:self action:@selector(clickToGenerator) forControlEvents:UIControlEventTouchUpInside];;
    UIImage *generatorBtnImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"generator" ofType:@"png" inDirectory:@"Paper"]];
    [generatorBtn setBackgroundImage:generatorBtnImage forState:UIControlStateNormal];
    [searchBgImg addSubview:generatorBtn];
    
    /// 底部导出论文的背景图片
    UIImageView *exportBoxImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 114, self.view.frame.size.width, 50)];
    UIImage *exportBoxImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"exportBox" ofType:@"png" inDirectory:@"Paper"]];
    exportBoxImg.image = exportBoxImage;
    [self.view addSubview:exportBoxImg];
    exportBoxImg.userInteractionEnabled = YES;
    
    UILabel *exportLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 60, 40)];
    exportLabel.text = @"导出：";
    exportLabel.textColor = [UIColor blackColor];
    exportLabel.font = [UIFont systemFontOfSize:18.0];
    [exportBoxImg addSubview:exportLabel];
    
    /// txtIcon按钮
    UIButton *txtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    txtBtn.frame = CGRectMake(CGRectGetMaxX(exportLabel.frame), 10, 30, 30);
    txtBtn.tag = 1001;
    UIImage *txtImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"txtIcon" ofType:@"png" inDirectory:@"Paper"]];
    [txtBtn setBackgroundImage:txtImage forState:UIControlStateNormal];
    [txtBtn addTarget:self action:@selector(exportPapers:) forControlEvents:UIControlEventTouchUpInside];
    [exportBoxImg addSubview:txtBtn];
    
    /// 导出按钮
    UIButton *exportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kScreenWidth == 375) {
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 52, 10, 45, 30);
    }else if (kScreenWidth == 320){
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 45, 10, 40, 30);
    }else{
        exportBtn.frame = CGRectMake(CGRectGetMaxX(exportBoxImg.frame) - 56, 10, 50, 30);
    }
    exportBtn.tag = 1002;
    UIImage *exportImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"export" ofType:@"png" inDirectory:@"Paper"]];
    [exportBtn setBackgroundImage:exportImage forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(exportPapers:) forControlEvents:UIControlEventTouchUpInside];
    [exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [exportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    exportBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [exportBoxImg addSubview:exportBtn];
}

#pragma mark - action
/// 生成论文
- (void)clickToGenerator
{
    NSLog(@"clickToGenerator");
}

- (void)exportPapers:(UIButton *)sender
{
    NSLog(@"tag为%ld的btn点击了导出",sender.tag);
}

@end
