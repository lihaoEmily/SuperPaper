//
//  GetPapersViewController.m
//  SuperPaper
//
//  Created by Emily on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "GetPapersViewController.h"
#import "ASSaveData.h"
#import "LoginViewController.h"

#define TOP_WIEW_HEIGHT 136.0
#define TITLE_HEIGHT    72.0
#define kDefaultColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

@interface GetPapersViewController ()
/**
 *  论文标题
 */
@property(nonatomic, strong) UILabel  * paperTitleLabel;
/**
 *  日期显示
 */
@property(nonatomic, strong) UILabel  * dateLabel;
/**
 *  顶部View
 */
@property(nonatomic, strong) UIView   * topInfoView;
/**
 *  导出提示
 */
@property(nonatomic, strong) UILabel  * exportLabel;
/**
 *  导出按钮
 */
@property(nonatomic, strong) UIButton * exportButton;

@end

@implementation GetPapersViewController
{
    /// 资源图片文件路径
    NSString *_bundleStr;
    
    /// 获取到的论文
    NSString *_content;
    
    /// 获取到论文的标题
    NSString *_title;
    
    /// 指示器
    UIActivityIndicatorView * _indicatorView;
    
    UITextView *_textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _bundleStr = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    [self setupUI];
    [self getData];
}

#pragma mark - 获取数据
- (void)getData
{
    NSDictionary *parameters = @{@"id":self.paperID};
    NSString *urlString =  [NSString stringWithFormat:@"%@get_papercontent.php",BASE_URL];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setTimeoutInterval:15.0f];
    [manager POST:urlString
       parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
           
       } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [_indicatorView stopAnimating];
           [_indicatorView setHidden:YES];
           if (responseObject) {
               _content = [responseObject valueForKey:@"content"];
               _title = [responseObject valueForKey:@"title"];
           }
           _textView.text = _content;
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [_indicatorView stopAnimating];
           [_indicatorView setHidden:YES];
           NSLog(@"%@",error);
       }];
    
    if ([_indicatorView isHidden]) {
        [_indicatorView setHidden:NO];
    }
    [_indicatorView startAnimating];
}

- (void)setupUI
{
    _topInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, TOP_WIEW_HEIGHT)];
    [_topInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topInfoView];
    
    // Left view
    UIView *leftMarginVew = [[UIView alloc] initWithFrame:CGRectMake(4, 0, 7, TITLE_HEIGHT)];
    [leftMarginVew setBackgroundColor:[AppConfig appNaviColor]];
    [_topInfoView addSubview:leftMarginVew];
    
    _paperTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftMarginVew.frame) + 15, leftMarginVew.frame.origin.y, kScreenWidth - 30 - leftMarginVew.frame.size.width - 4, TITLE_HEIGHT)];
    [_paperTitleLabel setText:self.paperTitleStr];
    [_paperTitleLabel setTextColor:[UIColor blackColor]];
    [_paperTitleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_paperTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_paperTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_paperTitleLabel setNumberOfLines:2];
    [_topInfoView addSubview:_paperTitleLabel];
    
    // Horizonal separator view
    UIView *horizontalSepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_paperTitleLabel.frame) + 8, kScreenWidth, 1)];
    [horizontalSepView setBackgroundColor:[UIColor lightGrayColor]];
    [_topInfoView addSubview:horizontalSepView];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(horizontalSepView.frame) + 21, 100, 20)];
    [_dateLabel setText:self.dateStr];
    [_dateLabel setTextColor:[UIColor grayColor]];
    [_dateLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_dateLabel setTextAlignment:NSTextAlignmentLeft];
    [_topInfoView addSubview:_dateLabel];
    
    UIImage *exportImage = [UIImage imageNamed:[[NSBundle bundleWithPath:_bundleStr] pathForResource:@"txtIcon" ofType:@"png" inDirectory:@"Paper"]];
    _exportButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 30 - 26, CGRectGetMaxY(horizontalSepView.frame) + 18, 26, 26)];
    [_exportButton setImage:exportImage
                   forState:UIControlStateNormal];
    [[_exportButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [_exportButton addTarget:self
                      action:@selector(exportWebViewToDoc)
            forControlEvents:UIControlEventTouchUpInside];
    [_topInfoView addSubview:_exportButton];
    
    _exportLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_exportButton.frame) - 50, _dateLabel.frame.origin.y, 40, _dateLabel.frame.size.height)];
    [_exportLabel setText:@"导出:"];
    [_exportLabel setTextColor:[UIColor blackColor]];
    [_exportLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_exportLabel setTextAlignment:NSTextAlignmentRight];
    [_topInfoView addSubview:_exportLabel];
    
    // Bottom separator view
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topInfoView.frame) - 1, kScreenWidth, 1)];
    [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
    [_topInfoView addSubview:bottomBorderView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_topInfoView.frame) + 20, kScreenWidth - 20, kScreenHeight - 64 - TOP_WIEW_HEIGHT - 20)];
    _textView.font = [UIFont systemFontOfSize:16.0];
    [_textView setEditable:NO];
    [self.view addSubview:_textView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [_indicatorView setCenter:CGPointMake(kScreenWidth / 2, CGRectGetMidY(self.view.frame) - 100)];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setHidden:YES];
    [_textView addSubview:_indicatorView];
}

- (void)exportWebViewToDoc
{
    if ([UserSession sharedInstance].currentUserID == 0) {
        LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"User" bundle:nil]instantiateViewControllerWithIdentifier:@"login"];
        [AppDelegate.app.nav pushViewController:loginVC animated:YES];
    }else{
        if (_content && _content.length > 0) {
            ASSaveData *data = [[ASSaveData alloc] init];
            [data saveToLocationwithStrings:_content withTitle:_title];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"论文已导出到Documents文件夹中，请注意查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无论文可导出" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

@end
