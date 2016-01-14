//
//  NormalWebViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "NormalWebViewController.h"

@interface NormalWebViewController ()<UIWebViewDelegate>
/**
 *  网页视图
 */
@property(nonatomic, strong) UIWebView * webView;
@property(nonatomic, strong) UIActivityIndicatorView * indicatorView;

@end

@implementation NormalWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_webView];
    
    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    _indicatorView.center = CGPointMake(self.view.bounds.size.width/2.0f,self.view.bounds.size.height/2.0f);
    [_indicatorView setHidden:YES];
    [self.view addSubview:_indicatorView];
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

@end
