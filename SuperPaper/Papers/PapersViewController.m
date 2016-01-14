//
//  PapersViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PapersViewController.h"

@interface PapersViewController ()

@end

@implementation PapersViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self setupUI];
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
}

- (void)clickToCall
{
    NSLog(@"clickToCall");
}

- (void)clickToGenerate
{
    NSLog(@"clickToGenerate");
}

- (NSString *)titleName {
    return @"论文";
}

@end
