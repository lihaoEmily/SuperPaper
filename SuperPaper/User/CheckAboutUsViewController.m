//
//  CheckAboutUsViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/26.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "CheckAboutUsViewController.h"
#import "UserSession.h"

@interface CheckAboutUsViewController ()
{
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(strong, nonatomic) NSDictionary *textAttributeDictionary;

@end

@implementation CheckAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    
    _webIndicator = indicator;
    UIFont *font = [UIFont systemFontOfSize:18];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15; // 首行字间矩
    paragraphStyle.headIndent = 15; // 字间矩
    paragraphStyle.lineSpacing = 7; // 行间矩
    _textAttributeDictionary = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    self.textView.textContainerInset = UIEdgeInsetsMake(8, 16, 8, 16);
    
//    if (!self.content) {
        NSString *urlString = [NSString stringWithFormat:@"%@getmeinfo.php",BASE_URL];
        NSDictionary *params = @{@"uid":[NSNumber numberWithInteger:[UserSession sharedInstance].currentUserID]};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
                NSNumber *result = responseObject[@"result"];
                if (0 == result.integerValue) {//获取我的主页信息接口成功

                    self.content = responseObject[@"service_aboutme"];
                    self.textView.text = self.content;
//                    self.textView.font = [UIFont systemFontOfSize:16];
                    [self.textView setAttributedText:[[NSAttributedString alloc] initWithString:self.content
                                                                                     attributes:self.textAttributeDictionary]];
                    
                }else{
                    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"获取客服电话失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
//    }else{
//        self.textView.text = self.content;
////        self.textView.font = [UIFont systemFontOfSize:16];
//        [self.textView setAttributedText:[[NSAttributedString alloc] initWithString:self.content
//                                                                         attributes:self.textAttributeDictionary]];
//        self.textView.scrollsToTop = YES;
//    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([_webIndicator isAnimating]) {
        [_webIndicator removeFromSuperview];
    }
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
