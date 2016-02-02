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

@property (nonatomic, strong) PublicationDetailData* detailData;

@end


@implementation PublicationIntroduceViewController
{
    NSString *_bundleStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self getPublicationDetailData];
    // Do any additional setup after loading the view.
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
                  _detailData.p_title = [dataDic valueForKey:@"title"];
                  _detailData.p_content = [dataDic valueForKey:@"content"];
                  _detailData.p_keywords = [dataDic valueForKey:@"keywords"];
                  _detailData.p_viewnum = [[dataDic valueForKey:@"viewnum"]integerValue];
                  _detailData.p_content_pic_name = [dataDic valueForKey:@"content_pic_name"];
                  _detailData.p_createdate = [dataDic valueForKey:@"createdate"];
                  _detailData.p_emptyflg = [[dataDic valueForKey:@"emptyflg"]integerValue];
                  _detailData.p_tel = [dataDic valueForKey:@"tel"];
              }
              //              [self setupTextView];
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"%@",error);
          }];
}

//- (void)setupTextView
//{
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_topInfoView.frame) + 20, kScreenWidth - 20, kScreenHeight - 64 - TOP_WIEW_HEIGHT - 20)];
//    textView.text = _content;
//    textView.font = [UIFont systemFontOfSize:16.0];
//    [textView setEditable:NO];
//    [self.view addSubview:textView];
//}

@end