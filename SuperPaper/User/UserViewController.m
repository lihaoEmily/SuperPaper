//
//  UserViewController.m
//  SuperPaper
//
//  Created by AppStudio on 16/1/9.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "UserViewController.h"
#import "MainViewController.h"
@interface UserViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *backTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic)  UILabel *displayTypeLabel;
@property (weak, nonatomic)  UILabel *paperNumLabel;
@property (weak, nonatomic)  UILabel *telephoneNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;

@end

@implementation UserViewController

- (void)awakeFromNib
{
    self.backTableView.tableHeaderView = self.headerView;
// [[[NSBundle mainBundle] loadNibNamed:@"" owner:nil options:nil] lastObject];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableViewBottom.constant = 49 + 64 - 20;
}

- (NSString *)titleName {
    return @"我的";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (/* DISABLES CODE */ (1)) // 登陆状态
    {
        return section == 0 ? 6 : 3;
    }else
    {
        return section == 0 ? 3 : 3;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"userReuse%ld",indexPath.row ]];
        if (indexPath.row == 4)
        {
            self.displayTypeLabel = [cell viewWithTag:178802];
        }else if (indexPath.row == 5)
        {
            self.paperNumLabel = [cell viewWithTag:178803];
        }
    }else if (indexPath.section == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"userCell%ld",indexPath.row ]];
        if (indexPath.row == 2)
        {
            self.telephoneNumLabel = [cell viewWithTag:178804];
        }
    }
    
    if (cell == nil)
    {
        NSLog(@"indexpathsection %ld  indexpath.row = %ld",indexPath.section , indexPath.row);
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@""];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *colorString = nil;
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                colorString = @"green"; // 我的消息
                break;
            case 1:
                colorString = @"yellow"; // 我的信息
                break;
            case 2:
                colorString = @"orange"; // 我的账户
                break;
            case 3:
                colorString = @"pink";  // 我的邀请
                break;
            case 4:
                colorString = @"gray";  // 我的论文
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                colorString = @"blue"; // 关于我们
                break;
            case 1:
                colorString = @"purple"; // 意见反馈
                break;

            
            default:
                break;
        }
    }
    
    if (colorString.length > 0)
    {
        [self performSegueWithIdentifier:colorString sender:nil];
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
