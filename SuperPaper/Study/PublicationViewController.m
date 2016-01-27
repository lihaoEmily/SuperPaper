//
//  PublicationViewController.m
//  SuperPaper
//
//  Created by admin on 16/1/19.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "PublicationViewController.h"
#import "JournalsPressView.h"

@interface PublicationViewController ()

@property (nonatomic, strong) JournalsPressView *contentView;

@end

@implementation PublicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _contentView = [[JournalsPressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = _contentView;
    // Do any additional setup after loading the view.
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
