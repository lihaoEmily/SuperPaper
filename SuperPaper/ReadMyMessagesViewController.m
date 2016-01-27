//
//  ReadMyMessagesViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/25.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ReadMyMessagesViewController.h"

@interface ReadMyMessagesViewController ()
{
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ReadMyMessagesViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"分享" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(shareThisMessage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:btn];

    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.textView.text = self.messageContent;
    self.title = self.messageTitle;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@readusernotice.php",BASE_URL];
    NSDictionary *params = @{@"id":@(self.messageID)};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [_webIndicator stopAnimating];
        [_webIndicator removeFromSuperview];
    }];
    [_webIndicator startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: 功能
- (void) shareThisMessage
{
    NSLog(@"我要分享这条信息");
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
