//
//  TextWebViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/2/10.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "TextWebViewController.h"

#define TOP_WIEW_HEIGHT 112.0
#define TITLE_HEIGHT    56.0
#define kDefaultColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

@interface TextWebViewController ()<UIWebViewDelegate>
/**
 *  顶部View
 */
@property(nonatomic, strong) UIView   * topInfoView;
/**
 *  论文标题
 */
@property(nonatomic, strong) UILabel  * paperTitleLabel;
/**
 *  日期显示
 */
@property(nonatomic, strong) UILabel  * dateLabel;
/**
 *  浏览量
 */
@property(nonatomic, strong) UILabel  * viewLabel;
/**
 *  浏览图标
 */
@property(nonatomic, strong) UIImageView * viewIcon;
/**
 *  网页视图
 */
@property(nonatomic, strong) UIWebView * webView;
/**
 *  文本视图
 */
@property (nonatomic, strong) UITextView *textView;
/**
 *  加载进度
 */
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation TextWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _topInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    [_topInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topInfoView];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    [_textView setEditable:NO];
    [_textView setFont:[UIFont systemFontOfSize:17]];
    [_textView setTextContainerInset:UIEdgeInsetsMake(8, 16, 8, 16)];
    [self.view addSubview:_textView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];
    
    [self layoutTopInfoView];
    [self layoutWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestInfoFromeServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self requestWeb];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutTopInfoView {
    _paperTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_paperTitleLabel setText:@"标题"];
    [_paperTitleLabel setTextColor:[UIColor blackColor]];
    [_paperTitleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_paperTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_paperTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_paperTitleLabel setNumberOfLines:2];
    [_topInfoView addSubview:_paperTitleLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_dateLabel setText:@"日期"];
    [_dateLabel setTextColor:[UIColor grayColor]];
    [_dateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_dateLabel setTextAlignment:NSTextAlignmentLeft];
    [_topInfoView addSubview:_dateLabel];
    
    _viewIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_viewIcon setImage:[UIImage imageNamed:@"ViewCount"]];
    [_viewIcon setContentMode:UIViewContentModeScaleAspectFill];
    [_topInfoView addSubview:_viewIcon];
    
    _viewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_viewLabel setText:@"0"];
    [_viewLabel setTextColor:[UIColor grayColor]];
    [_viewLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_viewLabel setTextAlignment:NSTextAlignmentCenter];
    [_topInfoView addSubview:_viewLabel];
    
    
    
    [_topInfoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *conToTop = [NSLayoutConstraint constraintWithItem:_topInfoView
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0.0];
    NSLayoutConstraint *conToLeft = [NSLayoutConstraint constraintWithItem:_topInfoView
                                                                 attribute:NSLayoutAttributeLeft
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeLeft
                                                                multiplier:1.0
                                                                  constant:0.0];
    NSLayoutConstraint *conToRight = [NSLayoutConstraint constraintWithItem:_topInfoView
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:0.0];
    NSLayoutConstraint *conHeight = [NSLayoutConstraint constraintWithItem:_topInfoView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:TOP_WIEW_HEIGHT];
    NSArray *topViewConstraints = [NSArray arrayWithObjects:conToTop,conToLeft,conToRight,conHeight, nil];
    [self.view addConstraints:topViewConstraints];
    
    // Left view
    UIView *leftMarginVew = [[UIView alloc] initWithFrame:CGRectZero];
    [leftMarginVew setBackgroundColor:kDefaultColor];
    [_topInfoView addSubview:leftMarginVew];
    [leftMarginVew setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *leftMarginViewToTop = [NSLayoutConstraint constraintWithItem:leftMarginVew
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:_topInfoView
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1.0
                                                                            constant:8.0];
    NSLayoutConstraint *leftMarginViewToLeft = [NSLayoutConstraint constraintWithItem:leftMarginVew
                                                                            attribute:NSLayoutAttributeLeft
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_topInfoView
                                                                            attribute:NSLayoutAttributeLeft
                                                                           multiplier:1.0
                                                                             constant:8.0];
    NSLayoutConstraint *leftMarginViewHeight = [NSLayoutConstraint constraintWithItem:leftMarginVew
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0
                                                                             constant:TITLE_HEIGHT];
    NSLayoutConstraint *leftMarginViewWidth  = [NSLayoutConstraint constraintWithItem:leftMarginVew
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:1.0
                                                                             constant:7.0];
    NSArray *leftMarginViewContraints = [NSArray arrayWithObjects:leftMarginViewToTop, leftMarginViewToLeft, leftMarginViewHeight, leftMarginViewWidth, nil];
    [_topInfoView addConstraints:leftMarginViewContraints];
    
    // Title label
    [_paperTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *paperTitleToTop = [NSLayoutConstraint constraintWithItem:_paperTitleLabel
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:8.0];
    NSLayoutConstraint *paperTitleToLef = [NSLayoutConstraint constraintWithItem:_paperTitleLabel
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:leftMarginVew
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1.0
                                                                        constant:8.0];
    NSLayoutConstraint *paperTitleToRight = [NSLayoutConstraint constraintWithItem:_paperTitleLabel
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_topInfoView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:-8.0];
    NSLayoutConstraint *paperTitleHeight = [NSLayoutConstraint constraintWithItem:_paperTitleLabel
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:leftMarginVew
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:0.0];
    NSArray *paperTitleContraints = [NSArray arrayWithObjects:paperTitleToTop, paperTitleToLef, paperTitleToRight, paperTitleHeight, nil];
    [_topInfoView addConstraints:paperTitleContraints];
    
    // Horizonal separator view
//    UIView *horizontalSepView = [[UIView alloc] initWithFrame:CGRectZero];
//    [horizontalSepView setBackgroundColor:[UIColor lightGrayColor]];
//    [_topInfoView addSubview:horizontalSepView];
//    [horizontalSepView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    NSLayoutConstraint *horSepViewToTop = [NSLayoutConstraint constraintWithItem:horizontalSepView
//                                                                       attribute:NSLayoutAttributeTop
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:_paperTitleLabel
//                                                                       attribute:NSLayoutAttributeBottom
//                                                                      multiplier:1.0
//                                                                        constant:8.0];
//    NSLayoutConstraint *horSepViewToLef = [NSLayoutConstraint constraintWithItem:horizontalSepView
//                                                                       attribute:NSLayoutAttributeLeft
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:_topInfoView
//                                                                       attribute:NSLayoutAttributeLeft
//                                                                      multiplier:1.0
//                                                                        constant:0.0];
//    NSLayoutConstraint *horSepViewToRight = [NSLayoutConstraint constraintWithItem:horizontalSepView
//                                                                         attribute:NSLayoutAttributeRight
//                                                                         relatedBy:NSLayoutRelationEqual
//                                                                            toItem:_topInfoView
//                                                                         attribute:NSLayoutAttributeRight
//                                                                        multiplier:1.0
//                                                                          constant:0.0];
//    NSLayoutConstraint *horSepViewHeight = [NSLayoutConstraint constraintWithItem:horizontalSepView
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:nil
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                       multiplier:1.0
//                                                                         constant:1.0];
//    NSArray *horSepViewContraints = [NSArray arrayWithObjects:horSepViewToTop, horSepViewToLef, horSepViewToRight, horSepViewHeight, nil];
//    [_topInfoView addConstraints:horSepViewContraints];
    
    // Date Label
    [_dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *dateToTop = [NSLayoutConstraint constraintWithItem:_dateLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_paperTitleLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:8.0];
    NSLayoutConstraint *dateToLeft = [NSLayoutConstraint constraintWithItem:_dateLabel
                                                                  attribute:NSLayoutAttributeLeft
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_topInfoView
                                                                  attribute:NSLayoutAttributeLeft
                                                                 multiplier:1.0
                                                                   constant:8.0];
    NSLayoutConstraint *dateToBottom = [NSLayoutConstraint constraintWithItem:_dateLabel
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_topInfoView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-8.0];
    NSLayoutConstraint *dateWidth = [NSLayoutConstraint constraintWithItem:_dateLabel
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:nil
                                                                 attribute:NSLayoutAttributeWidth
                                                                multiplier:1.0
                                                                  constant:100.0];
    NSArray *dateContraints = [NSArray arrayWithObjects:dateToTop, dateToLeft, dateToBottom, dateWidth, nil];
    [_topInfoView addConstraints:dateContraints];
    
    // View Label
    [_viewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *viewLabelToTop = [NSLayoutConstraint constraintWithItem:_viewLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_paperTitleLabel
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:8.0];
    NSLayoutConstraint *viewLabelRight = [NSLayoutConstraint constraintWithItem:_viewLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_topInfoView
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-8.0];
    NSLayoutConstraint *viewLabelBottom = [NSLayoutConstraint constraintWithItem:_viewLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-8.0];
    NSLayoutConstraint *viewLabelWidth = [NSLayoutConstraint constraintWithItem:_viewLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_viewLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:0.0];
    NSArray *viewLabelContraints = [NSArray arrayWithObjects:viewLabelToTop, viewLabelRight, viewLabelBottom, viewLabelWidth, nil];
    [_topInfoView addConstraints:viewLabelContraints];
    
    // View Icon
    [_viewIcon setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *viewIconToTop = [NSLayoutConstraint constraintWithItem:_viewIcon
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_paperTitleLabel
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:12.0];
    NSLayoutConstraint *viewIconRight = [NSLayoutConstraint constraintWithItem:_viewIcon
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_viewLabel
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:-8.0];
    NSLayoutConstraint *viewIconBottom = [NSLayoutConstraint constraintWithItem:_viewIcon
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_topInfoView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:-12.0];
    NSLayoutConstraint *viewIconWidth = [NSLayoutConstraint constraintWithItem:_viewIcon
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:24.0];
    NSArray *viewIconContraints = [NSArray arrayWithObjects:viewIconToTop, viewIconRight, viewIconBottom, viewIconWidth, nil];
    [_topInfoView addConstraints:viewIconContraints];
    
    // Bottom separator view
    UIView *bottomBorderView = [[UIView alloc] initWithFrame:CGRectZero];
    [bottomBorderView setBackgroundColor:[UIColor lightGrayColor]];
    [_topInfoView addSubview:bottomBorderView];
    [bottomBorderView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *botBorViewToBottom = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                          attribute:NSLayoutAttributeBottom
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:_topInfoView
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:0.0];
    NSLayoutConstraint *botBorViewToLef = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:0.0];
    NSLayoutConstraint *botBorViewToRight = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_topInfoView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSLayoutConstraint *botBorViewHeight = [NSLayoutConstraint constraintWithItem:bottomBorderView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:1.0];
    NSArray *botBorViewContraints = [NSArray arrayWithObjects:botBorViewToBottom, botBorViewToLef, botBorViewToRight, botBorViewHeight, nil];
    [_topInfoView addConstraints:botBorViewContraints];
}

/**
 *  布局WebView
 */
- (void)layoutWebView {
    [_textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintToTop = [NSLayoutConstraint constraintWithItem:_textView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:0.0];
    NSLayoutConstraint *constraintToLeft = [NSLayoutConstraint constraintWithItem:_textView
                                                                        attribute:NSLayoutAttributeLeft
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                        attribute:NSLayoutAttributeLeft
                                                                       multiplier:1.0
                                                                         constant:0.0];
    NSLayoutConstraint *constraintToRight = [NSLayoutConstraint constraintWithItem:_textView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSLayoutConstraint *constraintToBottom = [NSLayoutConstraint constraintWithItem:_textView
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
 *  请求数据
 */
- (void)requestInfoFromeServer {
    // get_papercontent.php
    /*
    Request:
    方式	    关键字		      数据类型	说明
    POST	id		          整型	    论文ID
    Response:
    JSON	result		      整型	    0：成功；1：失败
    JSON	title		      字符串	    论文标题
    JSON	content		      字符串	    获取咨询内容
    JSON	content_pic_name  字符串	    论文内容中的图片名字
    */
    NSString *paperId = _userData[@"id"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"id":paperId};
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, @"get_papercontent.php"];
    TextWebViewController * __weak weakSelf = self;
    [manager POST:urlString
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([[NSString stringWithFormat:@"%@",responseObject[@"result"]] isEqualToString:@"0"]) {
            [weakSelf parseResponseData:responseObject];
        }
        NSLog(@"----> %@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"----> %@",error);
    }];

}

- (void)parseResponseData:(NSDictionary *)data {
    NSString *title   = data[@"title"];
    NSString *content = data[@"content"];
//    NSString *contentPicName = data[@"content_pic_name"];
    NSString *dateStr = data[@"createdate"];
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:@"yyyy-MM-dd"];
//    NSDate *date = [formater dateFromString:dateStr];
    if (dateStr.length > 1) {
        NSString *date = [dateStr componentsSeparatedByString:@" "][0];
        [_dateLabel setText:[NSString stringWithFormat:@"%@",date]];
    }
    
//    NSInteger emptyFlag = [data[@"emptyflg"] integerValue];
//    NSString *keyWords  = data[@"keywords"];
//    NSString *telNumber = data[@"tel"];
    NSInteger viewCount = [data[@"viewnum"] integerValue];
    [_viewLabel setText:[NSString stringWithFormat:@"%ld",(long)viewCount]];
    
    [_paperTitleLabel setText:title];
    [_textView setText:content];
    
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
        [_webView loadHTMLString:_contentText baseURL:nil];
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
}

#pragma mark - Export web to text
- (void)exportWebViewToDoc {
    NSLog(@"%s",__func__);
    // 1.checking login
    // 2.checking web content
    // 3.checking network
}

@end
