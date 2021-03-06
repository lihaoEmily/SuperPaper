//
//  ServiceNoticesViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/22.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ServiceNoticesViewController.h"

@interface ServiceNoticesViewController ()
{
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(strong, nonatomic) NSDictionary *textAttributeDictionary;

@end

@implementation ServiceNoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15; // 首行字间矩
    paragraphStyle.headIndent = 15; // 字间矩
    paragraphStyle.lineSpacing = 7; // 行间矩
    _textAttributeDictionary = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    self.textView.textContainerInset = UIEdgeInsetsMake(8, 16, 8, 16);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
    
    NSString *urlString = [NSString stringWithFormat:@"%@service_protocol.php",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (0 == [responseObject[@"result"]integerValue]) {
//            self.textView.text = responseObject[@"service_protocol"];
//            self.textView.font = [UIFont systemFontOfSize:16];
            NSString *content = responseObject[@"service_protocol"];
            [self.textView setAttributedText:[[NSAttributedString alloc] initWithString:content
                                                                             attributes:self.textAttributeDictionary]];
        }
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
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
