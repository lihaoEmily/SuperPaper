//
//  ReadMyPapersViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/26.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ReadMyPapersViewController.h"
#import "ASSaveData.h"
@interface ReadMyPapersViewController ()
{
    UIActivityIndicatorView *_webIndicator;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ReadMyPapersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(deleteThisPaper) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.textView.text = self.content;
    self.dayLabel.text = self.dateString;
    self.title = self.paperTitle;
    self.titleLable.text = self.paperTitle;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 40)/2, ([UIScreen mainScreen].bounds.size.height - 40)/2, 40, 40);
    _webIndicator = indicator;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *urlString = [NSString stringWithFormat:@"%@get_papercontent.php",BASE_URL];
    NSDictionary *params = @{@"id":self.paperID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                self.textView.text = responseObject[@"content"];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"论文读取失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exportPaper:(id)sender {
    ASSaveData *data = [[ASSaveData alloc] init];
    [data saveToLocationwithStrings:self.content withTitle:self.paperTitle];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"论文已导出到Documents文件夹中，请注意查看" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [av show];
}

//MARK: 功能
- (void) deleteThisPaper
{
    NSString *urlString = [NSString stringWithFormat:@"%@mypaper_delete.php",BASE_URL];
    NSDictionary *params = @{@"paper_id":self.paperID};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"result"]respondsToSelector:NSSelectorFromString(@"integerValue")]) {
            NSNumber *result = responseObject[@"result"];
            if (0 == result.integerValue) {
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"论文已删除" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [av show];
            }else{
                UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"论文删除失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    if (!_webIndicator.isAnimating) {
        [_webIndicator startAnimating];
        [[UIApplication sharedApplication].keyWindow addSubview:_webIndicator];
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
