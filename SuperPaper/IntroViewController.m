//
//  IntroViewController.m
//  SuperPaper
//
//  Created by YaoQiang on 16/1/14.
//  Copyright © 2016年 Share technology. All rights reserved.
//
#define SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

#import "IntroViewController.h"

@interface IntroViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic)   UIScrollView    *scrollView;
@property (strong, nonatomic)   NSMutableArray  *arrayOfImageSource;
@property (strong, nonatomic)   UIPageControl   *pageControl;
@end

@implementation IntroViewController
- (NSMutableArray *)arrayOfImageSource{
    if (!_arrayOfImageSource) {
        _arrayOfImageSource = [[NSMutableArray alloc]init];
        
        UIImage *image1 =[UIImage imageNamed:@"guide_1.png"];
        UIImage *image2 =[UIImage imageNamed:@"guide_2.png"];
        UIImage *image3 =[UIImage imageNamed:@"guide_3.png"];
        UIImage *image4 =[UIImage imageNamed:@"guide_4.png"];
        
        [_arrayOfImageSource addObject:image1];
        [_arrayOfImageSource addObject:image2];
        [_arrayOfImageSource addObject:image3];
        [_arrayOfImageSource addObject:image4];
    }
    return _arrayOfImageSource;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.numberOfPages = [self.arrayOfImageSource count];
    }
    return _pageControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self setupScrollView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    
}
- (void)setupScrollView{
    CGSize size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    for (int index = 0; index < [self.arrayOfImageSource count]; index ++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[self.arrayOfImageSource objectAtIndex:index]];
        imageView.frame = CGRectMake(index * size.width, 0, size.width, size.height);
        imageView.contentMode = UIViewContentModeScaleToFill;
        
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeMake((index + 1) * size.width, 0);
        if (index == [self.arrayOfImageSource count] - 1) {

        }
    }
}
#pragma -mark scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int pageCount = self.scrollView.contentOffset.x / self.scrollView.bounds.size.width;
    _pageControl.currentPage = pageCount;
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

@end
