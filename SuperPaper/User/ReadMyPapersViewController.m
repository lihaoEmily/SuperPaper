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
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation ReadMyPapersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.textView.text = self.content;
    self.dayLabel.text = self.dateString;
    self.title = self.paperTitle;
    self.titleLable.text = self.paperTitle;
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
- (IBAction)deleteThisPaper:(id)sender {
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
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"网络连接失败！" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }];
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
