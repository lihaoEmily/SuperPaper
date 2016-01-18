//
//  ExportableWebViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/16.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ExportableWebViewController.h"

#define TOP_WIEW_HEIGHT 136.0
#define TITLE_HEIGHT    72.0
#define kDefaultColor  [UIColor colorWithRed:232/255.0 green:79/255.0 blue:135./255.0 alpha:1.0f]

@interface ExportableWebViewController ()<UIWebViewDelegate>
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
 *  导出提示
 */
@property(nonatomic, strong) UILabel  * exportLabel;
/**
 *  导出按钮
 */
@property(nonatomic, strong) UIButton * exportButton;
/**
 *  网页视图
 */
@property(nonatomic, strong) UIWebView * webView;
/**
 *  加载进度
 */
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation ExportableWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _topInfoView = [[UIView alloc] initWithFrame:CGRectZero];
    [_topInfoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_topInfoView];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [_webView setDelegate:self];
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];
    
    [self layoutTopInfoView];
    [self layoutWebView];
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

- (void)layoutTopInfoView {
    _paperTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_paperTitleLabel setText:@"TitleTitleTitleTitleTitleTitleTitleTitleTitleTitleTitleTitle"];
    [_paperTitleLabel setTextColor:[UIColor blackColor]];
    [_paperTitleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_paperTitleLabel setTextAlignment:NSTextAlignmentLeft];
    [_paperTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_paperTitleLabel setNumberOfLines:2];
    [_topInfoView addSubview:_paperTitleLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_dateLabel setText:@"2016-01-16"];
    [_dateLabel setTextColor:[UIColor grayColor]];
    [_dateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_dateLabel setTextAlignment:NSTextAlignmentLeft];
    [_topInfoView addSubview:_dateLabel];
    
    _exportLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_exportLabel setText:@"导出:"];
    [_exportLabel setTextColor:[UIColor blackColor]];
    [_exportLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_exportLabel setTextAlignment:NSTextAlignmentRight];
    [_topInfoView addSubview:_exportLabel];
    
    _exportButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_exportButton setImage:[UIImage imageNamed:@"TextExport"]
                   forState:UIControlStateNormal];
    [[_exportButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
    [_exportButton addTarget:self
                      action:@selector(exportWebViewToDoc)
            forControlEvents:UIControlEventTouchUpInside];
    [_topInfoView addSubview:_exportButton];
    
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
                                                                             constant:64.0];
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
    UIView *horizontalSepView = [[UIView alloc] initWithFrame:CGRectZero];
    [horizontalSepView setBackgroundColor:[UIColor lightGrayColor]];
    [_topInfoView addSubview:horizontalSepView];
    [horizontalSepView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *horSepViewToTop = [NSLayoutConstraint constraintWithItem:horizontalSepView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_paperTitleLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:8.0];
    NSLayoutConstraint *horSepViewToLef = [NSLayoutConstraint constraintWithItem:horizontalSepView
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0
                                                                        constant:0.0];
    NSLayoutConstraint *horSepViewToRight = [NSLayoutConstraint constraintWithItem:horizontalSepView
                                                                         attribute:NSLayoutAttributeRight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_topInfoView
                                                                         attribute:NSLayoutAttributeRight
                                                                        multiplier:1.0
                                                                          constant:0.0];
    NSLayoutConstraint *horSepViewHeight = [NSLayoutConstraint constraintWithItem:horizontalSepView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:1.0];
    NSArray *horSepViewContraints = [NSArray arrayWithObjects:horSepViewToTop, horSepViewToLef, horSepViewToRight, horSepViewHeight, nil];
    [_topInfoView addConstraints:horSepViewContraints];
    
    // Date Label
    [_dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *dateToTop = [NSLayoutConstraint constraintWithItem:_dateLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:horizontalSepView
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
    
    // Exportable button
    [_exportButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *expButtonToTop = [NSLayoutConstraint constraintWithItem:_exportButton
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:horizontalSepView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:8.0];
    NSLayoutConstraint *expButtonRight = [NSLayoutConstraint constraintWithItem:_exportButton
                                                                  attribute:NSLayoutAttributeRight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:_topInfoView
                                                                  attribute:NSLayoutAttributeRight
                                                                 multiplier:1.0
                                                                   constant:-16.0];
    NSLayoutConstraint *expButtonBottom = [NSLayoutConstraint constraintWithItem:_exportButton
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_topInfoView
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.0
                                                                     constant:-8.0];
    NSLayoutConstraint *expButtonWidth = [NSLayoutConstraint constraintWithItem:_exportButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_exportButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1.0
                                                                  constant:0.0];
    NSArray *expButtonContraints = [NSArray arrayWithObjects:expButtonToTop, expButtonRight, expButtonBottom, expButtonWidth, nil];
    [_topInfoView addConstraints:expButtonContraints];
    
    // Exportable title
    [_exportLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *expLabelToTop = [NSLayoutConstraint constraintWithItem:_exportLabel
                                                                      attribute:NSLayoutAttributeTop
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:horizontalSepView
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:8.0];
    NSLayoutConstraint *expLabelRight = [NSLayoutConstraint constraintWithItem:_exportLabel
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_exportButton
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:-8.0];
    NSLayoutConstraint *expLabelBottom = [NSLayoutConstraint constraintWithItem:_exportLabel
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:-8.0];
    NSLayoutConstraint *expLabelWidth = [NSLayoutConstraint constraintWithItem:_exportLabel
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:1.0
                                                                       constant:80.0];
    NSArray *expLabelContraints = [NSArray arrayWithObjects:expLabelToTop, expLabelRight, expLabelBottom, expLabelWidth, nil];
    [_topInfoView addConstraints:expLabelContraints];
    
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
    [_webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintToTop = [NSLayoutConstraint constraintWithItem:_webView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_topInfoView
                                                                       attribute:NSLayoutAttributeBottom
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
 *  请求数据
 */
- (void)requestInfoFromeServer {
    ;
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
}

#pragma mark - Export web to text
- (void)exportWebViewToDoc {
    NSLog(@"%s",__func__);
    // 1.checking login
    // 2.checking web content
    // 3.checking network
}

@end
