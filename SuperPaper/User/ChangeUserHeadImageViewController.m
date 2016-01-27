//
//  ChangeUserHeadImageViewController.m
//  SuperPaper
//
//  Created by yu on 16/1/23.
//  Copyright © 2016年 Share technology. All rights reserved.
//

#import "ChangeUserHeadImageViewController.h"
#import "ChangeUserHeadImageHasNextTableViewCell.h"
#import "ChangeUserHeadImageTextShowTableViewCell.h"
#import "UserSession.h"

@interface ChangeUserHeadImageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

static NSString *const HasNextIdentifier = @"hasnext";
static NSString *const ShowTextIdentifier = @"showtext";
@implementation ChangeUserHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"usercell1"];
        cell.titleLabel.text = @"头像上传";
        cell.contentLabel.text = @"";
        return cell;
        
    }else if(1 == indexPath.row){
        ChangeUserHeadImageHasNextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HasNextIdentifier];
        cell.titleImageView.image = [UIImage imageNamed:@"usercell2"];
        cell.titleLabel.text = @"昵称";
        cell.contentLabel.text = [UserSession sharedInstance].currentUserNickname;
        return cell;
        
    }else{
        ChangeUserHeadImageTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ShowTextIdentifier];
        cell.contentLabel.text = [UserSession sharedInstance].currentUserTelNum;
        return cell;
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
