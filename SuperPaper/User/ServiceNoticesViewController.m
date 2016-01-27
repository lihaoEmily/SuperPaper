//
//  ServiceNoticesViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/22.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ServiceNoticesViewController.h"

@interface ServiceNoticesViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ServiceNoticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    NSString *urlString = [NSString stringWithFormat:@"%@service_protocol.php",BASE_URL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (0 == [responseObject[@"result"]integerValue]) {
            self.textView.text = responseObject[@"service_protocol"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];

    }];
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
