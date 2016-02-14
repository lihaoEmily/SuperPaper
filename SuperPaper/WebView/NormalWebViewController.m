//
//  NormalWebViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalWebViewController.h"
#import "ShareManage.h"
#import "UMSocial.h"
#import "ShareView.h"

@interface NormalWebViewController ()<UIWebViewDelegate, UMSocialUIDelegate, shareCustomDelegate>
/**
 *  网页视图
 */
@property(nonatomic, strong) UIWebView * webView;
/**
 *  加载进度
 */
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation NormalWebViewController

#pragma mark - UIViewControllerLifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];
    [self layoutWebView];
    
    [self setupTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self requestWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 分享按钮
- (void)setupTitleView
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 40, 30);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareItem;
}

#pragma mark - Actions
- (void)share
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"56af0b3be0f55ab9b1001511" shareText:@"更多精彩内容尽在[超级论文]" shareImage:nil shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,nil] delegate:self];
    
    // 分享的图片
    UIImage *image = [UIImage imageNamed:@"LOGO-181"];
    
    // 微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.fileData = UIImagePNGRepresentation(image);
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlString;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.title;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareImage = image;
    
    // 微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.fileData = UIImagePNGRepresentation(image);
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlString;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareImage = image;
    
    // QQ好友
    [UMSocialData defaultData].extConfig.qqData.url = self.urlString;
    [UMSocialData defaultData].extConfig.qqData.title = self.title;
    [UMSocialData defaultData].extConfig.qqData.shareImage = image;
    
    // QQ空间
    [UMSocialData defaultData].extConfig.qzoneData.url = self.urlString;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.title;
    [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
    
    // 以下是自定义分享view，同android线上版
//    ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(50, ([UIScreen mainScreen].bounds.size.height - 64) / 2 - (([UIScreen mainScreen].bounds.size.width - 100) / 4 + 20) / 2, [UIScreen mainScreen].bounds.size.width - 100, ([UIScreen mainScreen].bounds.size.width - 100) / 4 + 40)];
//    shareView.backgroundColor = [UIColor whiteColor];
//    shareView.shareDelegate = self;
//    [_webView addSubview:shareView];
}

#pragma mark - shareCustomDelegate
- (void)shareBtnClickWithIndex:(NSInteger)tag
{
    NSString *text = @"更多精彩内容尽在[超级论文]";
    switch (tag) {
        case 1000:
            [[ShareManage shareManage] QQFriendsShareWithViewControll:self text:text urlString:self.urlString title:self.title];
            break;
        case 1001:
            [[ShareManage shareManage] QzoneShareWithViewControll:self text:text urlString:self.urlString title:self.title];
            break;
        case 1002:
            [[ShareManage shareManage] wxShareWithViewControll:self text:text urlString:self.urlString title:self.title];
            break;
        case 1003:
            [[ShareManage shareManage] wxpyqShareWithViewControll:self text:text urlString:self.urlString title:self.title];
            break;
            
        default:
            break;
    }
}

/**
 *  布局WebView
 */
- (void)layoutWebView {
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintToTop = [NSLayoutConstraint constraintWithItem:_webView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.view
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0.0];
    NSLayoutConstraint *constraintToLeft = [NSLayoutConstraint constraintWithItem:_webView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:0.0];
    NSLayoutConstraint *constraintToRight = [NSLayoutConstraint constraintWithItem:_webView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSLayoutConstraint *constraintToBottom = [NSLayoutConstraint constraintWithItem:_webView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0];
    NSArray *webViewConstraints = [NSArray arrayWithObjects:constraintToTop, constraintToLeft, constraintToRight, constraintToBottom, nil];
    [self.view addConstraints:webViewConstraints];
    
    [_indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:_indicatorView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:_indicatorView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSArray *indicatorConstraints = [NSArray arrayWithObjects:constraintCenterX, constraintCenterY, nil];
    [self.view addConstraints:indicatorConstraints];

}

/**
 *  请求网页
 */

- (void)requestWeb {
    if (_urlString && _urlString.length > 0) {
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    } else {
        return;
    }    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([_indicatorView isHidden]) {
        [_indicatorView setHidden:NO];
    }
    [_indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_indicatorView stopAnimating];
    [_indicatorView setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_indicatorView stopAnimating];
    [_indicatorView setHidden:YES];
    NSLog(@"----> WebViewLoadError: %@",error);
}

#pragma mark - UMSocialUIDelegate
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
