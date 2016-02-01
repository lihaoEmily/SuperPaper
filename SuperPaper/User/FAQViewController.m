//
//  FAQViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/28.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "FAQViewController.h"
#import "UserSession.h"


@interface FAQViewController (){
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@getcommonqa.php",BASE_URL];
    NSDictionary *params = @{@"uid":[NSString stringWithFormat:@"%lu",[UserSession sharedInstance].currentUserID]};
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                self.textView.text = responseObject[@"service_commonqa"];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取常见问题失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }
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
