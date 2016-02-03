//
//  PublicationIntroduceViewController.m
//  SuperPaper
//
//  Created by mapbarios on 16/2/2.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationIntroduceViewController.h"

//#define TOP_WIEW_HEIGHT 136.0
//#define TITLE_HEIGHT    72.0
//#define kDefaultColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]
//#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface PublicationIntroduceViewController ()

//@property (nonatomic, strong) PublicationDetailData* detailData;

@end


@implementation PublicationIntroduceViewController
{
    NSString* _bundleStr;
    UIView* _leftColorView;
    UILabel* _titleLabel;
    UILabel* _keyLabel;
    UILabel* _numOfReader;
    UIImageView* _imageView;
    UIImageView* _centerImageView;
    UILabel* _contentLabel;
    UIScrollView* _scrollView;
    UIButton* _telBtn;
    NSString* _telNum;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    [self.view addSubview:_scrollView];
    
    _leftColorView = [[UIView alloc]initWithFrame:CGRectMake(5, 15, 8, 44)];
    _leftColorView.backgroundColor = kSelColor;
    [_scrollView addSubview:_leftColorView];
    
    //    标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_leftColorView.frame)+15, 15, kWidth-CGRectGetMaxX(_leftColorView.frame)-15 - 15, 44)];
    _titleLabel.font = [UIFont systemFontOfSize:21];
    _titleLabel.numberOfLines = 2;
    [_scrollView addSubview:_titleLabel];
    
    //    中间的图片
    _centerImageView = [[UIImageView alloc]init];
    _centerImageView.frame = CGRectMake((kWidth-100)/2,CGRectGetMaxY(_leftColorView.frame) + 40, 100, 140);
    [_scrollView addSubview:_centerImageView];
    
    _contentLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_centerImageView.frame) + 20, kWidth - 20, 10000)];
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    [_scrollView addSubview:_contentLabel];
    
    _telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _telBtn.frame = CGRectMake(0, 0, self.view.frame.size.width, 35);
    _telBtn.backgroundColor = kSelColor;
    [_telBtn addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_telBtn];
    _telBtn.hidden = YES;
    
    UIImage *telIconImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"telcon" ofType:@"png" inDirectory:@"Paper"]];
    [_telBtn setImage:telIconImage forState:UIControlStateNormal];
    [_telBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 17, 10, _telBtn.frame.size.width - 37)];
    
    _telBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [_telBtn setTitle:@"拨打联系电话" forState:UIControlStateNormal];
    [_telBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_telBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, -10, 5, 0)];
    
    [self getPublicationDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getPublicationDetailData
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:25.0f];
    
    NSDictionary *parameters = @{@"id":[NSNumber numberWithInteger:_publicationID]};
    NSString *urlString = [NSString stringWithFormat:@"%@get_newscontent.php",BASE_URL];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary* dataDic = (NSDictionary*)responseObject;
              if (dataDic) {
                  [self reloadViewDateWithdict:dataDic];
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
}

-(void)reloadViewDateWithdict:(NSDictionary *)dic
{
    self.title = dic[@"title"];
    _titleLabel.text = dic[@"title"];
    [_titleLabel sizeToFit];
    
    _contentLabel.text = dic[@"content"];
    [_contentLabel sizeToFit];

    NSString *imageUrl = [NSString stringWithFormat:@"%@",dic[@"content_pic_name"]];
    NSString *url = [NSString stringWithFormat:@"%@%@",IMGURL,dic[@"content_pic_name"]];
    if ([self isBlankString:imageUrl]||[imageUrl isEqualToString:@"<null>"]) {
        CGRect rect = _contentLabel.frame;
        rect.origin.y = CGRectGetMaxY(_leftColorView.frame) + 10;
        rect.size.height = _contentLabel.frame.size.height;
        _contentLabel.frame = rect;
        _centerImageView.hidden = YES;
    }
    else{
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:url]];
        _centerImageView.hidden = NO;
    }
    _scrollView.contentSize = CGSizeMake(kWidth, CGRectGetMaxY(_contentLabel.frame) + 64 + 10);
    
    _telNum = dic[@"tel"];
    if (_telNum && _telNum.length) {
        _telBtn.hidden = NO;
    }
}

- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (void)clickToCall
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_telNum]];
    [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebView];
}

//- (void)onCallButtonClicked:(UIButton*) button
//{
//    NSString* url = [NSString stringWithFormat:@"telprompt://%@", _poiPhoneNumber];
//        
//    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此设备不支持通话"
//                                                            message:nil
//                                                            delegate:nil
//                                                            cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
//        [alertView show];
//    }
//    else
//    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
//}

@end