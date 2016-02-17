//
//  VoucherIntroViewController.m
//  SuperPaper
//
//  Created by  mapbar_ios on 16/1/26.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "VoucherIntroViewController.h"

@interface VoucherIntroViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation VoucherIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.textView.text = self.content;
    self.textView.font = [UIFont systemFontOfSize:16];
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
